import 'package:att/api.dart';
import 'package:att/bloc/attendance-bloc.dart';
import 'package:att/bloc/user-cubit.dart';
import 'package:att/const/overlays.dart';
import 'package:att/const/theme.dart';
import 'package:att/localStorage/sharedpref.dart';
import 'package:att/model/attendance-model.dart';
import 'package:att/screen/attendance-list-view.dart';
import 'package:att/screen/employee-list-screen.dart';
import 'package:att/screen/tab-controller-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreenContent();
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // Default index for Home Screen
  int _selectedIndex = 0; 

  final List<Widget> _screens = [
    // Home Screen
    const HomeScreenTab(), 
    // Employee Management Page
     EmployeeListScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      // Update selected index
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // Display selected screen
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Employees",
          ),
        ],
      ),
    );
  }
}




// Ensure this import is correct

class HomeScreenTab extends StatefulWidget {
  const HomeScreenTab({super.key});

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
   // Default to today's date
  DateTime _selectedDate = DateTime.now();
  // To track the refresh state
  bool _isRefreshing = false; 

  // Function to show Date Picker
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
       // Set range of dates
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AttendanceCubit>().state.isEmpty) {
        getData();
      }
    });
  }

  void getData() async {
    print("here $_selectedDate");
    AnotherClass.showTransparentDialog(context);
    await GoogleSheetsApi.getAttendanceByDate(
      context: context,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
    AnotherClass.hideTransparentDialog(context);
    setState(() {});
  }

  // Function to refresh data
  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      // Directly call the API to refresh data
       getData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to refresh data!")),
      );
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  // Function to handle logout
  void _logout() async{
    await UserPreferences.clearUserInfo();
              context.read<UserCubit>().logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TabControllerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bitterSweet.withValues(alpha: 0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "🏠 Home Screen",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          
           
          ],
        ),
        actions: [
          // Refresh Button
          IconButton(
            icon: _isRefreshing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             InkWell(
              onTap: () => _pickDate(context),
              child: Container(
                width:140,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  
                  color: bitterSweet,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height:5),
            Expanded(
              child: BlocBuilder<AttendanceCubit, List<AttendanceRecord>>(
                builder: (context, attendanceList) {
                  return AttendanceListView(records: attendanceList, admin: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class EmployeeManagementTab extends StatelessWidget {
  const EmployeeManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("👥 Employee Management Page Content"));
  }
}
