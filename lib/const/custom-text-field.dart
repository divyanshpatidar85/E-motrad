// import 'package:attendace_e/const/theme.dart';
import 'package:att/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  FaIcon? icon;
  final String hintText;
  final String alternateHintText;
  final TextInputType keyboardType;
  final VoidCallback? onIconPressed;
  int? maxline;
  bool obsecuretext = false;
  String? labelText;

  bool enableStatus = true;
  bool digit = true;
  int lengthlimit = 10;
  //  VoidCallback onPressed(e);

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.alternateHintText,
    required this.keyboardType,
    this.icon,
    this.onIconPressed,
    this.labelText,
    this.maxline = 1,
    this.obsecuretext = false,
    this.enableStatus = true,
    this.digit = false,
    this.lengthlimit = 10,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment:
                widget.icon != null ? Alignment.centerLeft : Alignment.center,
            child: TextField(
              controller: widget.controller,
              focusNode: myFocusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.obsecuretext,
              maxLines: widget.maxline,
              autofocus: false,
              cursorColor: red,
              inputFormatters: [
                if (widget.digit)
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                if (widget.digit)
                  LengthLimitingTextInputFormatter(widget.lengthlimit),
              ],
              decoration: InputDecoration(
                hintText: widget.alternateHintText,
                labelText: widget.labelText,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.icon?.icon != null
                      ? InkWell(
                          child: widget.icon,
                          onTap: () {
                            if (widget.icon?.icon ==
                                    FontAwesomeIcons.eyeSlash ||
                                widget.icon?.icon == FontAwesomeIcons.eye) {
                              widget.icon = (widget.icon?.icon ==
                                      FontAwesomeIcons.eyeSlash)
                                  ? const FaIcon(
                                      FontAwesomeIcons.eye,
                                      color: red,
                                    )
                                  : const FaIcon(
                                      FontAwesomeIcons.eyeSlash,
                                      color: red,
                                    );
                                widget.obsecuretext=!widget.obsecuretext;
                              setState(() {});
                            }
                          },
                        )
                      : null,
                ),
                labelStyle: const TextStyle(
                  color: red,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: red, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: 1 == 1 ? Colors.grey : red,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: 1 == 1 ? Colors.grey : red,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              enabled: widget.enableStatus,
            ),
          ),
        ),
      ],
    );
  }
}
