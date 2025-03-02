// import 'dart:ui';


import 'package:att/const/theme.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
 

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onHover: (value) {
            // hovering.toggle();
          },
          onTap: widget.onPressed,
          child: Container(
            width: 150,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:  red,
              border: Border.all(
                color: 1==1? red : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child:widget.text,
          ),
        );
  }
}