class Like {
  final String postId;
  final String userId;

  Like({required this.postId, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
    };
  }

  factory Like.fromMap(Map<String, dynamic> data) {
    return Like(
      postId: data['postId'],
      userId: data['userId'],
    );
  }
}
