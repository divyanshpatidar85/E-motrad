class ClockInStatus {
  final String clockInTime;
  final bool status;

  ClockInStatus({required this.clockInTime, required this.status});

  // Factory method to create an instance from JSON
  factory ClockInStatus.fromJson(Map<String, dynamic> json) {
    return ClockInStatus(
      clockInTime: json["clockIn"] ?? "N/A", // Default "N/A" if clock-in time is missing
      status: json["clockIn"] != null && json["clockIn"] != "N/A", // True if clock-in exists
    );
  }
}
