
import 'package:cloud_firestore/cloud_firestore.dart';

import 'likes_model.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  int likes;

  Post( {required this.id,required this.userId,required this.userName,required this.userProfileImageUrl, required this.content, this.imageUrl, required this.timestamp,required this.likes});

  factory Post.fromFirestore(Map<String, dynamic> data, String id,String userName,String profileImageUrl) {
    return Post(
      id: id,
      userId: data['userId'] ?? '',
      userName: userName,
      userProfileImageUrl: profileImageUrl,
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'], // optional image URL
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0
    );
  }
}
