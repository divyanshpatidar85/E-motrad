class AttendanceRecord {
  final String uid;
  final String email;
  final String idate;
  final String odate;
  final String clockIn;
  final String clockOut;
  final String userName;

  AttendanceRecord({
    required this.uid,
    required this.email,
    required this.userName,
    required this.idate,
    required this.odate,
    required this.clockIn,
    required this.clockOut,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      uid: json["uid"],
      email: json["email"],
      idate: (json["idate"]).toString().split('A')[0],
      odate: json["odate"].toString().split('A')[0],
      clockIn: json["clockIn"].toString().split('A')[0],
      clockOut:json["clockOut"].toString().split('A').first,
      userName:json["username"]??"NA"
      // :json["username"]??"NA"
    );
  }
}
