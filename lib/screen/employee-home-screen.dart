import 'package:att/api.dart';
import 'package:att/bloc/attendance-bloc.dart';
import 'package:att/bloc/clock-in-out-status.dart';
import 'package:att/bloc/user-cubit.dart';
import 'package:att/const/custom-alert.dart';
import 'package:att/const/overlays.dart';
import 'package:att/const/theme.dart';
import 'package:att/localStorage/sharedpref.dart';
import 'package:att/model/attendance-model.dart';
import 'package:att/model/clock-in-model.dart';
import 'package:att/screen/attendance-list-view.dart';
import 'package:att/screen/tab-controller-screen.dart';
import 'package:att/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
    getAttendance();
  }

  Future<void> getData() async {
    final user = context.read<UserCubit>().state;
    if (user != null) {
      await GoogleSheetsApi.clockAction(email: user.email, uid: user.uid, context: context);
    }
  }

  Future<void> getAttendance() async {
    final user = context.read<UserCubit>().state;
    if (user != null) {
      await GoogleSheetsApi.getAttendanceByUidandEmail(email: user.email, uid: user.uid, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🚀 Workforce Insights", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await UserPreferences.clearUserInfo();
              context.read<UserCubit>().logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TabControllerScreen()));
            },
          ),
        ],
        backgroundColor:bitterSweet.withValues(alpha:0.8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<UserCubit, UserModel?>(
              builder: (context, user) {
                return user == null
                    ? const Center(child: Text("No user logged in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                    : Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Employee Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const Divider(),
                              _infoRow("Email", user.email),
                              _infoRow("Role", user.role),
                              _infoRow("Username", user.username),
                            ],
                          ),
                        ),
                      );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<clockInStatus, ClockInStatus?>(
              builder: (context, status) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Attendance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Divider(),
                        Text("Clock In Time: ${status?.clockInTime ?? 'NA'}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: status == null || status.status
                                  ? null
                                  : () async {
                                      AnotherClass.showTransparentDialog(context);
                                      String res = await GoogleSheetsApi.clockIn(context.read<UserCubit>().state!.uid,
                                          context.read<UserCubit>().state!.email,context.read<UserCubit>().state!.username, context);
                                      AnotherClass.hideTransparentDialog(context);
                                      CustomAlertDialog().showAlertMyDialog(context, "Note", res);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Clock In'),
                            ),
                            ElevatedButton(
                              onPressed: status == null || !status.status
                                  ? null
                                  : () async {
                                      AnotherClass.showTransparentDialog(context);
                                      String res = await GoogleSheetsApi.clockOut(context.read<UserCubit>().state!.uid,
                                          context.read<UserCubit>().state!.email, context);
                                      AnotherClass.hideTransparentDialog(context);
                                      CustomAlertDialog().showAlertMyDialog(context, "Note", res);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Clock Out'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Attendance Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: BlocBuilder<AttendanceCubit, List<AttendanceRecord>>(
                builder: (context, attendanceList) {
                  return AttendanceListView(records: attendanceList,admin:false,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
