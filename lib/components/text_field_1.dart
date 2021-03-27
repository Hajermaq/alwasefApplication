import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class TextField_1 extends StatelessWidget {
  TextField_1(
      {this.onSaved,
      this.onChanged,
      this.labelText,
      this.initialValue,
      this.maxLines,
      this.validator,
      this.textInputType,
      this.controller});

  final Function onSaved;
  final Function onChanged;
  final Function validator;
  final String labelText;
  final String initialValue;
  final int maxLines;
  final TextInputType textInputType;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        keyboardType: textInputType,
        textAlign: TextAlign.center,
        validator: validator,
        maxLines: maxLines,
        onSaved: onSaved,
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black54,
        ),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          fillColor: Colors.white54,
          filled: true,
          labelText: labelText,
          labelStyle: GoogleFonts.almarai(
            color: kBlueColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          errorStyle: TextStyle(
            color: kRedColor,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor, width: 3.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kRedColor,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: kBlueColor, width: 3.0),
          ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          //   borderSide: BorderSide(color: kBlueColor),
          // ),
        ),
      ),
    );
  }
}
