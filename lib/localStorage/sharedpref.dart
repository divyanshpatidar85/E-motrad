import 'package:att/api.dart';
import 'package:att/bloc/user-cubit.dart';
import 'package:att/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _pref;

  // Initialize SharedPreferences instance
  static Future<void> _init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  // Store user email
  static Future<void> storeUserInfo({required String emailId,required String role,required String userName,required String uid}) async {
    await _init(); 
    await _pref!.setString("email", emailId);
    await _pref!.setString("role", role);
    await _pref!.setString("username", userName);
    await _pref!.setString("uid", uid);
    

   
  }

  // Get stored user email
  static Future<List<String?>> getUserInfo(BuildContext context) async {
    await _init(); // Ensure SharedPreferences is initialized
    UserModel user=UserModel(uid:_pref!.getString("uid")??'', email:_pref!.getString("email")??'', username:_pref!.getString("username")??'', role:_pref!.getString("role")??'');
    String res=await GoogleSheetsApi.loginUser(email: _pref!.getString("email")??'', password:'', userType: _pref!.getString("role")??'', context: context,loggedStatus:true);
    if(res=="success"){
    context.read<UserCubit>().setUser(user);

    return [_pref!.getString("email"),_pref!.getString("role")];
    }else{
     await clearUserInfo();
      return ['',''];
    }
  }
  // Clears all stored preferences

   static Future<void> clearUserInfo() async {
    await _init();
    await _pref!.clear(); 
  }

}
