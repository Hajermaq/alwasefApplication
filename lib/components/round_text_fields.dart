import 'package:flutter/material.dart';

import '../constants.dart';

class RoundTextFields extends StatelessWidget {
  final Function onChanged;
  final String hintMessage;
  final Color color;
  final bool isObscure;
  RoundTextFields(
      {this.hintMessage, this.onChanged, this.color, this.isObscure});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
      margin: EdgeInsets.only(right: 50, left: 50),
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          style: BorderStyle.solid,
          width: 4.0,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        obscureText: isObscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintMessage,
          hintStyle: kTextFieldHintStyle,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
