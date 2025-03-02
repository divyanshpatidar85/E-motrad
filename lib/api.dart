import 'dart:convert';
import 'package:att/bloc/attendance-bloc.dart';
import 'package:att/bloc/clock-in-out-status.dart';
import 'package:att/bloc/employee-bloc.dart';
import 'package:att/bloc/user-cubit.dart';
import 'package:att/const/keys.dart';
import 'package:att/localStorage/sharedpref.dart';
import 'package:att/model/attendance-model.dart';
import 'package:att/model/clock-in-model.dart';
import 'package:att/model/login_model.dart';
import 'package:att/model/user-model.dart';
import 'package:att/screen/admin-home-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';

class GoogleSheetsApi {
  static const String baseUrl = "https://script.google.com/macros/s/AKfycbxrTXPi0n2OkOU9FAOZKEV48o_nsNGzv-h7rXLN1-2VIutbA31yKsrROoE91WCqRzy_oQ/exec"; //  Base URL for Google Sheets API

  // Register User - Registers a new user with encrypted password
  static Future<String> registerUser({required String email, required String password, required String name, required String userType}) async {
    final iv = encrypt.IV.fromLength(16); //  Create encryption IV (Initialization Vector)
    final encrypter = encrypt.Encrypter(encrypt.AES(key)); // Encrypting password using AES encryption
    final encrypted = encrypter.encrypt(password, iv: iv); //  Encrypt the password
    var res = await _postRequest({
      "action": "register", //  Register action
      "email": email,
      "key": iv.base64, // Store IV as base64 for decryption later
      "password": encrypted.base64, //  Store encrypted password
      "username": name,
      "role": userType,
    });

    // If the response status is success, return success
    if (res["status"] == "success") {
      return "success"; //  Success message
    } else {
      return res["message"]; //Error message if registration failed
    }
  }

  //  Update User Information - Updates user info based on their email
  static Future updateUserStatus({required String email}) async {
    final res = await _postRequest({
      "action": "updateuserinfo", //  Update user info action
      "email": email,
    });
  }

  //  Update Clock-In/Out - Updates time for clock in/out
  static Future updateClockInOut({
    required String email,
    required String date,
    required String clockInTime,
    required String nclockInTime,
    required String nclockOutTime,
    required String uid,
    required BuildContext context,
  }) async {
    final res = await _postRequest({
      "action": "updateClockInOut", //  Update clock-in/out times
      "email": email,
      "date": date.trim(),
      "clockInTime": clockInTime.trim(),
      "nclockInTime": nclockInTime.trim(),
      "nclockOutTime": nclockOutTime.trim(),
      "uid": uid.trim(),
    });
    await getAttendanceByUidandEmail(email: email, uid: uid, context: context);
    return res;
  }

  //  Clock Action - Gets clock-in status or updates clock-in
    static Future<bool> clockAction({ // "clockin", "clockout", or "getclockin"
  required String email,
  required String uid,
  required BuildContext context
}) async {
  var res = await _postRequest({
    "action":"getclockin",
    "email": email,
    "uid": uid,
  });
print("here status is i am su${res.toString()}");
  if (res["status"] == "success") {
     print("here status is i am su${res.toString()}");
     ClockInStatus clockInStatuss=ClockInStatus(clockInTime:res["data"]["clockIn"] , status:true);
     context.read<clockInStatus>().setStatus(clockInStatuss);
    return  true;
  } else {
     ClockInStatus clockInStatuss=ClockInStatus(clockInTime:"N/A", status:false);
    context.read<clockInStatus>().setStatus(clockInStatuss);
    return false;
  }
}

  // static Future<bool> clockAction({
  //   required String email,
  //   required String uid,
  //   required BuildContext context,
  // }) async {
  //   var res = await _postRequest({
  //     "action": "getclockin", //  Get clock-in status action
  //     "email": email,
  //     "uid": uid,
  //   });

  //   if (res["status"] == "success") {
  //     ClockInStatus clockInStatus = ClockInStatus(clockInTime: res["data"]["clockIn"], status: true); //  If clock-in time found
  //     context.read<clockInStatus>().setStatus(clockInStatus); // 📲 Update status in Bloc
  //     return res["message"] ?? true;
  //   } else {
  //     ClockInStatus clockInStatus = ClockInStatus(clockInTime: "N/A", status: false); //  No clock-in time found
  //     context.read<clockInStatus>().setStatus(clockInStatus); // 📲 Update status in Bloc
  //     return res["message"] ?? false;
  //   }
  // }

  //  Get Attendance by Date - Fetch attendance records by specific date
  static Future<bool> getAttendanceByDate({
    required String date,
    required BuildContext context,
  }) async {
    var res = await _postRequest({
      "action": "attendancebydate", //  Fetch attendance by date
      "date": date,
    });

    if (res["status"] == "success") {
      List<dynamic> data = res["data"];
      List<AttendanceRecord> records = data.map((item) => AttendanceRecord.fromJson(item)).toList(); //  Map response data to AttendanceRecord objects
      context.read<AttendanceCubit>().featchAttendance(records); //  Update attendance in Bloc
      return true; //  Success
    } else {
      context.read<AttendanceCubit>().featchAttendance([]); //  No data found
      return false;
    }
  }

  // Get Attendance by UID and Email - Fetch attendance records by UID and Email
  static Future<bool> getAttendanceByUidandEmail({
    required String email,
    required String uid,
    required BuildContext context,
  }) async {
    var res = await _postRequest({
      "action": "getAttendByUid", //  Fetch attendance by UID and email
      "emai": email.trim(),
      "uid": uid.trim(),
    });
    print("i am form in uid and featching all the data ${res.toString()}  ${email}  ${uid}");
    if (res["status"] == "success") {
      List<dynamic> data = res["data"];
      List<AttendanceRecord> records = data.map((item) => AttendanceRecord.fromJson(item)).toList();
      records.sort((a, b) {
        DateTime aDate = DateFormat('yyyy-MM-dd').parse(a.idate);
        DateTime bDate = DateFormat('yyyy-MM-dd').parse(b.idate);
        return bDate.compareTo(aDate); //  Sort records by date
      });
      print("here status is i am su");
     await clockAction(context:context,email:email,uid:uid);
      context.read<AttendanceCubit>().featchAttendance(records); //  Update attendance in Bloc
      return true;
    } else {
      context.read<AttendanceCubit>().featchAttendance([]); //  No attendance data found
      return false;
    }
  }

  //  Login User - Handles user login and stores info in Bloc
  static Future<String> loginUser({
    required String email,
    required String password,
    required String userType,
    required BuildContext context,
    bool loggedStatus = false, // Default is false unless already logged in
  }) async {
    Map<String, dynamic> res = await _postRequest({
      "action": "login", //  Login action
      "email": email,
      "password": password,
    });

    if (res["status"] == "success" && !loggedStatus) {
      final keytodecypr = encrypt.IV.fromBase64(res["data"]["key"]);
      final encrypted1 = encrypter.encrypt(password, iv: keytodecypr);

      if (encrypted1.base64 == res["data"]["password"] && res["data"]["role"] == userType) {
        UserModel user = UserModel.fromJson(res["data"] as Map<String, dynamic>); // 👤 Create UserModel from API response
        context.read<UserCubit>().setUser(user); //  Store user in Bloc
        await UserPreferences.storeUserInfo(
          emailId: res["data"]["email"],
          role: res["data"]["role"],
          userName: res["data"]["username"],
          uid: res["data"]["uid"],
        );
        return "success"; //  Success message
      }
      return "Check your password or selected user type"; //  Password or role mismatch
    } else if (res["data"]["status"] == 1 && loggedStatus) {
      return "success"; //  Already logged in
    }

    return "Login failed"; //  Login failed message
  }

  //  Clock-In API - Handles clocking in of user
  static Future<String> clockIn(String uid, String email, String username, BuildContext context) async {
    var result = await _postRequest({
      "action": "clockin", //  Clock-in action
      "uid": uid,
      "email": email,
      "username": username,
    });
    clockAction(email: email, uid: uid, context: context); // 📲 Update clock-in status
    await getAttendanceByUidandEmail(email: email, uid: uid, context: context); //  Fetch updated attendance records
    return result["message"]; //  Return success message or error
  }

  //  Clock-Out API - Handles clocking out of user
  static Future<String> clockOut(String uid, String email, BuildContext context) async {
    var result = await _postRequest({
      "action": "clockout", //  Clock-out action
      "uid": uid,
      "email": email,
    });
    clockAction(email: email, uid: uid, context: context); // 📲 Update clock-out status
    await getAttendanceByUidandEmail(email: email, uid: uid, context: context); //  Fetch updated attendance records
    return result["message"]; //  Return success message or error
  }

  // Get Attendance - Fetch filtered attendance data (e.g., by year, month, or last week)
  static Future<Map<String, dynamic>> getAttendance(String filterType, String filterValue) async {
    return await _postRequest({
      "action": "getAttendance", //  Get attendance action
      "filterType": filterType,
      "filterValue": filterValue,
    });
  }

  //  Generic POST Request Handler - Sends POST request to the server
  static Future<Map<String, dynamic>> _postRequest(Map<String, dynamic> requestBody) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(requestBody), //  Sending request data as JSON
        headers: {"Content-Type": "application/json"}, //  Set headers
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location'];
        if (newUrl != null) {
          return await _fetchRedirect(newUrl); //  Handle redirect if status is 302
        }
      }

      return jsonDecode(response.body); //  Parse and return response body
    } catch (e) {
      print("Error: ${e.toString()}"); //  Catch error and log it
      return {"status": "error", "message": e.toString()}; // Return error response
    }
  }

  //  Handle Redirect Responses (302) - Follow URL redirection if needed
  static Future<Map<String, dynamic>> _fetchRedirect(String url) async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body); //  Fetch and return redirected response
  }

  //  Get All Employees - Fetch all employees and store them in Bloc
  static Future<String> getAllEmployees({required BuildContext context}) async {
    try {
      var res = await _postRequest({
        "action": "getallemployee", //  Fetch all employees
      });

      if (res["status"] == "success") {
        List<dynamic> employeesJson = res["data"];
        List<Employee> employees = employeesJson.map((json) => Employee.fromJson(json)).toList(); //  Map response to Employee model
        await context.read<EmployeeCubit>().fetchEmployees(employees); //  Update employees list in Bloc
        return "success"; //  Success message
      } else {
        return "Some error occurred"; //  Error fetching employees
      }
    } catch (e) {
      throw Exception("Error fetching employees: $e"); //  Handle fetch error
    }
  }
}
