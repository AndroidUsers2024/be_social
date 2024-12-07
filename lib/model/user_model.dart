// user_model.dart
class UserModel {
  final String id;
  final String username;
  final String email;
  final String mobile;
  final String bio;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.bio,
    required this.profileImageUrl,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'mobile': mobile,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl']??'',
    );
  }
}
