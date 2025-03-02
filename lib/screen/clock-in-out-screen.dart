import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockInOutScreen extends StatefulWidget{
  @override
  State<ClockInOutScreen> createState() =>_ClockInOutScreenState();
}

class _ClockInOutScreenState extends State<ClockInOutScreen> {
  String? clockInTime;
  String? clockOutTime;
  final List<Map<String, String>> attendanceRecords = [];

  void _clockIn() {
    setState(() {
      clockInTime = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  void _clockOut() {
    if (clockInTime == null) return; // Prevent clock-out without clock-in

    setState(() {
      clockOutTime = DateFormat('hh:mm a').format(DateTime.now());
      attendanceRecords.insert(0, {
        'date': DateFormat('dd MMM yyyy').format(DateTime.now()),
        'clockIn': clockInTime!,
        'clockOut': clockOutTime!,
      });
      clockInTime = null;
      clockOutTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clock In & Out')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Clock In & Out Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clockIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Clock In'),
                ),
                ElevatedButton(
                  onPressed: clockInTime != null ? _clockOut : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Clock Out'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Current Clock-In Time Display
            if (clockInTime != null)
              Text(
                "Clocked In at: $clockInTime",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20),

            // Attendance List Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("    Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("       Clock-In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Clock-Out ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Attendance List using ListView.builder
            Expanded(
              child: attendanceRecords.isEmpty
                  ? const Center(
                      child: Text(
                        "No Records Yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: attendanceRecords.length,
                      itemBuilder: (context, index) {
                        final record = attendanceRecords[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(' '+record['date']!, style: const TextStyle(fontSize: 16)),
                                Text(record['clockIn']!, style: const TextStyle(fontSize: 16, color: Colors.green)),
                                Text(record['clockOut']!+' ', style: const TextStyle(fontSize: 16, color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
