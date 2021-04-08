import 'package:flutter/material.dart';

import '../constants.dart';

class FilledRoundTextFields extends StatelessWidget {
  final Function onChanged;
  final Function onPressed;
  final String hintMessage;
  final Color color;
  final Color fillColor;
  FilledRoundTextFields(
      {this.hintMessage,
      this.onChanged,
      this.color,
      this.fillColor,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TextField(
          style: TextStyle(color: Colors.black54),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.all(16),
            fillColor: fillColor,
            icon: IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: onPressed,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 0, style: BorderStyle.none, color: Colors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: hintMessage,
            hintStyle: TextStyle(
              color: kBlueColor,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
