
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
    _user = UserModel.fromFirestore(doc.data()!, doc.id);
    notifyListeners();
  }

  Future<void> updateProfile(String userId, String username, String bio) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': username,
      'bio': bio,
    });
    await fetchUser(); // Refresh user data
  }

  Future<void> signUp(String userMail,String password,String username,String mobile,String bio, File? image) async {
    try {
        await _auth.createUserWithEmailAndPassword(
          email: userMail,
          password: password,
        ).then((value) async {
          String? imageUrl;

          if (image != null) {
            // Upload the image to Firebase Storage
            final storageRef = FirebaseStorage.instance.ref().child('user_profile/${_auth.currentUser!.uid}');
            final uploadImage = storageRef.putFile(image);
            final snapshot = await uploadImage;
            imageUrl = await snapshot.ref.getDownloadURL();
          }


          _user = UserModel(id: value.user!.uid, username: username, email: userMail, mobile: mobile, bio: bio,profileImageUrl: imageUrl!);
          if(value.user!=null){
            await FirebaseFirestore.instance.collection('users').doc(_user!.id).set(_user!.toMap());
          }
        });
        notifyListeners();
    } catch (e) {
      print('Registration failed: $e');
      // Show an alert or message to the user
    }
  }

 /* Future<void> addPost(String content, File? image) async {
    String? imageUrl;

    if (image != null) {
      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('user_image/${_auth.currentUser!.uid}');
      final uploadImage = storageRef.putFile(image);
      final snapshot = await uploadImage;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    // Add post to Firestore
    final docRef = await FirebaseFirestore.instance.collection('posts').add({
      'userId' : _auth.currentUser!.uid,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0
    });

    _posts.add(Post(id: docRef.id, content: content, imageUrl: imageUrl, timestamp: DateTime.now(), likes: 0));
    notifyListeners();
  }*/



  Future<void> signIn(String email,String password) async{
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Login failed: $e');
      // Show an alert or message to the user
    }
  }

}
