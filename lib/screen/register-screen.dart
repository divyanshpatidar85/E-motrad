import 'package:att/api.dart';
import 'package:att/const/custom-alert.dart';
import 'package:att/const/custom-button.dart';
import 'package:att/const/custom-drop-down-menu.dart';
import 'package:att/const/custom-text-field.dart';
import 'package:att/const/overlays.dart';
import 'package:att/const/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool enableStatus = true;
  String selectedUserType = 'Select User Type';
  TextEditingController userId = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController startYear = TextEditingController();
  TextEditingController endYear = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // hideTextInput();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '👤 Add User to System',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bitterSweet.withValues(alpha: 0.8),
      ),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: getWidth(context) * 0.9,
                  child: CustomDropDownMenu(
                    selectedValue: selectedUserType,
                    option: const ['Select User Type', 'Admin', 'Employee'],
                    onSelectedChanged: (String value) {
                      selectedUserType = value;
                      // setState(() {
                      selectedUserType = value;
                      setState(() {});
                    },
                  )),
              SizedBox(height: 8),
              SizedBox(
                width: getWidth(context) * 0.9,
                child: CustomTextField(
                  controller: userName,
                  hintText: 'Name',
                  labelText: 'Name',
                  alternateHintText: 'Enter your name ...',
                  icon: const FaIcon(
                    FontAwesomeIcons.user,
                    color: red,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: getWidth(context) * 0.9,
                height: 45,
                child: CustomTextField(
                  controller: email,
                  hintText: 'Email',
                  labelText: 'Email',
                  alternateHintText: 'Enter your email id ..',

                  // enableStatus:true,
                  icon: const FaIcon(
                    Icons.mail,
                    color: red,
                  ),
                  digit: false,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 8),
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
                      obsecuretext: true,
                      keyboardType: TextInputType.text)),
              const SizedBox(
                height: 10,
              ),

              SizedBox(
                width: getWidth(context) * 0.9,
                child: CustomButton(
                    onPressed: () async {
                      final RegExp emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );

                      if (selectedUserType == 'Select User Type') {
                        CustomAlertDialog().showAlertMyDialog(
                            context,
                            'Ohhh no Error !!!',
                            'please select correct user type');
                      } else if (userName.text.trim() == '') {
                        CustomAlertDialog().showAlertMyDialog(
                            context,
                            'Ohhh no Error !!!',
                            'please enter correct user name');
                      } else if (email.text.trim() == '' ||
                          !isValidEmail(email.text.trim())) {
                        CustomAlertDialog().showAlertMyDialog(
                            context,
                            'Ohhh no Error !!!',
                            'please enter a valid email address');
                      } else if (password.text.length < 6) {
                        CustomAlertDialog().showAlertMyDialog(
                            context,
                            'Ohhh no Error !!!',
                            'Password length must be greater than 5');
                      } else {
                        AnotherClass.showTransparentDialog(context);

                        var res = await GoogleSheetsApi.registerUser(
                            email: email.text,
                            password: password.text,
                            name: userName.text,
                            userType: selectedUserType);
                        print("here is my result ${res.toString()}");
                        if (res == "success") {
                          // ignore: use_build_context_synchronously
                          AnotherClass.hideTransparentDialog(context);
                          // ignore: use_build_context_synchronously
                          CustomAlertDialog().showAlertMyDialog(
                              context,
                              'User is registered succesfully',
                              'now try to login');
                        } else {
                          // ignore: use_build_context_synchronously
                          AnotherClass.hideTransparentDialog(context);
                          // ignore: use_build_context_synchronously
                          CustomAlertDialog().showAlertMyDialog(
                              context, 'Error !!!', res.toString());
                        }
                      }
                    },
                    text: Text(
                      'Register',
                      style: buttonTextStyle,
                    )),
              ),
              // if (_showOverlay)
              // const TransparentProgressOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}
