// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:att/const/theme.dart';
// import 'package:attendace_e/const/theme.dart';


class CustomAlertDialog{
 void showAlertMyDialog(
      BuildContext context, String alertTitle, String alertNotes) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
          ),
          child: AlertDialog(
            title: Text(alertTitle,style:headingStyle(context),),
            
            content:  SingleChildScrollView(
              child: Column(
                children: [
                  Text(alertNotes,style:subHeadingStyle,),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(ctx); // Close the dialog
                },
              )
            ],
          ),
        );
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        Navigator.pop(context);
      },
    );
  }


}