import 'package:flutter/material.dart';

import '../constants.dart';

class RoundTextFields extends StatelessWidget {
  final Function onChanged;
  final String hintMessage;
  final Color color;
  RoundTextFields({this.hintMessage, this.onChanged, this.color});
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
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintMessage,
          hintStyle: kTextFieldHintStyle,
          focusedBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}
