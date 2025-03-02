import 'package:att/api.dart';
import 'package:att/const/overlays.dart';
import 'package:att/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/attendance-model.dart';

class AttendanceListView extends StatefulWidget {
  final List<AttendanceRecord> records;
  // Admin Mode Toggle
  final bool admin; 

  const AttendanceListView({super.key, required this.records, required this.admin});

  @override
  _AttendanceListViewState createState() => _AttendanceListViewState();
}

class _AttendanceListViewState extends State<AttendanceListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) {
      return const Center(
        child: Text(
          "No attendance records found 😞",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.records.length,
      itemBuilder: (context, index) {
        final record = widget.records[index];
        String totalDuration = _calculateDuration(record.idate, record.odate, record.clockIn, record.clockOut);

        return Card(
          // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.black.withOpacity(0.8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //top levele employee name
                  if(widget.admin) Text('👔 Employee Name :${record.userName}',style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),),
                  // Top Row - Date and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "📅 ${record.idate}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      record.clockOut == "N/"
                          ? Padding(
                            padding: const EdgeInsets.only(right:9.0),
                            child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(right:9.0),
                            child: const Icon(Icons.check_circle, color: Colors.green, size: 22),
                          ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Clock In Row
                  Row(
                    children: [
                      const Icon(Icons.login, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text("Clock In: ${record.clockIn}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      const Spacer(),
                      if (widget.admin)
                        IconButton(
                          icon: const Icon(Icons.edit, color: lightPrimaryColor),
                          onPressed: () => _showEditDialog(context, record, true),
                        ),
                    ],
                  ),

                  // Clock Out Row
                  Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text("Clock Out: ${record.clockOut=='N/'?"N/A":record.clockOut}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      const Spacer(),
                      if (widget.admin)
                        IconButton(
                          icon: const Icon(Icons.edit, color: lightPrimaryColor),
                          onPressed: () => _showEditDialog(context, record, false),
                        ),
                    ],
                  ),

                  // Divider for Separation
                  const Divider(color: lightPrimaryColor, thickness: 1),

                  // Total Work Duration
                  Text(
                    "⏳ Total Work Duration: $totalDuration",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  // Overtime Calculation
                  _calculateOvertime(record.idate, record.odate, record.clockIn, record.clockOut),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Function to show an alert dialog for editing Clock In or Clock Out
  void _showEditDialog(BuildContext context, AttendanceRecord record, bool isClockIn) async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(record.clockIn),
      ),
    ).then((pickedTime) async {
      if (pickedTime != null) {
        String formattedTime =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00";

        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Update"),
              content: Text("Do you want to update ${isClockIn ? 'Clock-In' : 'Clock-Out'} time to $formattedTime?"),
              actions: [
                TextButton(
                   // Cancel
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    // Call API
                    AnotherClass.showTransparentDialog(context);
                    await GoogleSheetsApi.updateClockInOut(
                      email: record.email,
                      date: record.idate,
                      clockInTime: record.clockIn,
                      nclockInTime: isClockIn ? formattedTime : record.clockIn,
                      nclockOutTime: !isClockIn ? formattedTime : record.clockOut,
                      uid: record.uid,
                      context: context,
                    );
                    AnotherClass.hideTransparentDialog(context);
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        if (confirm) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clock-in time updated successfully!")),
          );
        }
      }
    });
  }

  /// Function to calculate duration
  String _calculateDuration(String idate, String odate, String clockIn, String clockOut) {
    if (clockOut == "N/") return "Not Available";

    try {
      DateTime da1 = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$idate$clockIn');
      DateTime da2 = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$odate$clockOut');

      var diff = da2.difference(da1);
      return '${diff.inHours}h ${diff.inMinutes % 60}m';
    } catch (e) {
      return "Invalid Data: ${e.toString()}";
    }
  }

  /// Function to calculate overtime if total hours exceed 9
  Widget _calculateOvertime(String idate, String odate, String clockIn, String clockOut) {
    if (clockOut == "N/A") return const SizedBox.shrink();

    try {
      DateTime da1 = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$idate$clockIn');
      DateTime da2 = DateFormat('yyyy-MM-dd hh:mm:ss').parse('$odate$clockOut');

      var diff = da2.difference(da1);
      int totalHours = diff.inHours;
      int totalMinutes = diff.inMinutes % 60;

      if (totalHours > 9) {
        int overtimeHours = totalHours - 9;
        return Text(
          "⏳ Overtime: $overtimeHours h ${totalMinutes}m",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
        );
      } else {
        return const SizedBox.shrink();
      }
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
