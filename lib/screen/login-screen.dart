// ignore_for_file: use_build_context_synchronously

import 'package:att/api.dart';
import 'package:att/const/custom-alert.dart';
import 'package:att/const/custom-button.dart';
import 'package:att/const/custom-drop-down-menu.dart';
import 'package:att/const/custom-text-field.dart';
import 'package:att/const/overlays.dart';
import 'package:att/const/theme.dart';
import 'package:att/screen/admin-home-screen.dart';
import 'package:att/screen/employee-home-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool tapstatus = false;
  bool obsecuretext = true;
  String selectedUserType = 'Select User Type';
  TextEditingController emailId = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // hideTextInput();
    // FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: getWidth(context) * 0.9,
                child: CustomDropDownMenu(
                  selectedValue: selectedUserType,
                  option: const [
                    'Select User Type',
                    'Admin',
                    "Employee"
                  ],
                  onSelectedChanged: (String value) {
                    selectedUserType = value;
                    print('selected user type $selectedUserType');
                    setState(() {});
                  },
                )
                ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: getWidth(context) * 0.9,
                // height:60,
                child: CustomTextField(
                    controller: emailId,
                    hintText: 'Enter Email Id',
                    alternateHintText: 'Enter Email Id',
                    labelText: 'Email Id',
                    icon: const FaIcon(
                      FontAwesomeIcons.user,
                      color: red,
                    ),
                    keyboardType: TextInputType.text)),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: getWidth(context) * 0.9,
                // height:60,
                child: CustomTextField(
                    controller: password,
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    alternateHintText: 'Enter Password',
                    icon: const FaIcon(
                      FontAwesomeIcons.eye,
                      color: red,
                    ),
                    obsecuretext: obsecuretext,
                    keyboardType: TextInputType.text)),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: getWidth(context) * 0.9,
              child: CustomButton(
                  onPressed: () async {
                    if(emailId.text.trim().isEmpty ||password.text.trim().isEmpty){
                       CustomAlertDialog().showAlertMyDialog(
                          context, 'Creadintal is not matched','Please fll all the filed');
                    }else{
                    AnotherClass.showTransparentDialog(context);
                    var res=await GoogleSheetsApi.loginUser(email:emailId.text.trim(),password:password.text,userType:selectedUserType,context:context);
                    // print("haahhaha $res");
                    if (res == 'success') {
                    
                      if (selectedUserType == 'Admin') {
                       AnotherClass.hideTransparentDialog(context);
                       Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>HomeScreen()));
                     
                      } else if (selectedUserType == 'Employee') {
                        AnotherClass.hideTransparentDialog(context);
                        Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>EmployeeHomeScreen()));
                       
                      } else {
                       AnotherClass.hideTransparentDialog(context);

                       
                      }
                    } else {
                      AnotherClass.hideTransparentDialog(context);
                      CustomAlertDialog().showAlertMyDialog(
                          context, 'Creadintal is not matched', res.toString());
                    }

                    setState(() {});
                    }
                  },
                  text: Text(
                    'Login',
                    style: buttonTextStyle,
                  )),
            )
          ],
        ),
      ),
    );
  }
}