class UserModel {
  final String uid;
  final String email;
  final String username;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("json data is here ${json.toString()}");
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
    );
  }

  // Method to convert a UserModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'role': role,
    };
  }
}
