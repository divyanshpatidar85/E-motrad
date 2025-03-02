// import 'package:attendace_e/const/theme.dart';
import 'package:att/const/theme.dart';
import 'package:flutter/material.dart';


class AnotherClass {
  static void showTransparentDialog(BuildContext context) {
    showDialog(
      context: context,
      // barrierDismissible:true,
      // useSafeArea:false,
      builder: (BuildContext context) {
        return  AlertDialog(
          insetPadding:const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width:getWidth(context),
            height:getHeight(context),
            child:const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
    static void hideTransparentDialog(BuildContext context) {
    Navigator.pop(context);
  }
}

// To use it from another widget:
