import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class OutinedButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  OutinedButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        height: 50.0,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kButtonColor,
                style: BorderStyle.solid,
                width: 4.0,
              ),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    text,
                    style: kButtonTextStyle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
