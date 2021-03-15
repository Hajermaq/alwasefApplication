import 'package:alwasef_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundRaisedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  RoundRaisedButton({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: RaisedButton(
          textColor: kButtonTextColor,
          color: kButtonColor,
          child: Text(
            text,
            style: kButtonTextStyle,
          ),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
