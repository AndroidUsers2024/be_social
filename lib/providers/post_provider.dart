import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../model/likes_model.dart';
import '../model/post_model.dart';


class PostProvider with ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;
  List<Post> _userPosts = [];

  List<Post> get userPosts => _userPosts;

  List<Like> _likes = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addPost(String content, File? image) async {
    String? imageUrl;

    if (image != null) {
      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('posts/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
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

    _posts.add(Post(id: docRef.id,userId: _auth.currentUser!.uid, content: content, imageUrl: imageUrl, timestamp: DateTime.now(), likes: 0,userName: "",userProfileImageUrl: ""));
    notifyListeners();
  }

  Future<void> fetchPosts_old() async {
    final snapshot = await FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).get();

    _posts = snapshot.docs.map((doc) async{
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(doc.data()['userId']).get();

      String profileImageUrl = userDoc['profileImageUrl'];
      String userName = userDoc['username'];
      return Post.fromFirestore(doc.data(), doc.id,userName,profileImageUrl);
    }).cast<Post>().toList();
    notifyListeners();
  }


  Future<void> fetchPosts() async {
    // Fetch posts ordered by timestamp
    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    // Temporary list to hold the posts
    List<Post> tempPosts = [];
    _posts =[];

    // Loop through the documents to create Post objects
    for (var doc in snapshot.docs) {

      // Fetch user document for each post
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.data()['userId'])
          .get();

      // Safely retrieve profile image URL and username
      String profileImageUrl = userDoc.exists ? userDoc['profileImageUrl']??'' : '';
      String userName = userDoc.exists ? userDoc['username'] : 'Unknown';

      // Create the Post object
      tempPosts.add(Post.fromFirestore(doc.data(), doc.id, userName, profileImageUrl));
    }

    // Assign the fetched posts to the provider's posts list
    _posts = tempPosts;
    notifyListeners();
  }

  Future<void> fetchUserPosts() async {
    final snapshot = await FirebaseFirestore.instance.collection('posts')
        .where('userId',isEqualTo: _auth.currentUser!.uid)
        // .orderBy('timestamp')
        .get();
    _userPosts = snapshot.docs.map((doc) => Post.fromFirestore(doc.data(), doc.id,"","")).toList();
    notifyListeners();
  }




}
