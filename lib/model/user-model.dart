class Employee {
  final String uid;
  final String email;
  final String username;
  final String role;
  final int status;

  Employee({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
    required this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      status: json['status'],
    );
  }
}
