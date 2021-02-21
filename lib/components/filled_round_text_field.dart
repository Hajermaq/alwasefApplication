import 'package:flutter/material.dart';

import '../constants.dart';

class FilledRoundTextFields extends StatelessWidget {
  final Function onChanged;
  final String hintMessage;
  final Color color;
  final Color fillColor;
  FilledRoundTextFields(
      {this.hintMessage, this.onChanged, this.color, this.fillColor});
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
          onChanged: onChanged,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            fillColor: fillColor,
            icon: Icon(Icons.search_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
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
