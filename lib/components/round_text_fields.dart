import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoundTextFields extends StatelessWidget {
  final Function onChanged;
  final Function onSaved;
  final Function validator;
  final String hintMessage;
  final Color color;
  final TextInputType textInputType;

// <<<<<<< HEAD
  final bool isObscure;
  RoundTextFields(
      {this.hintMessage,
      this.onChanged,
      this.color,
      this.isObscure,
      this.onSaved,
      this.textInputType,
      this.validator});
// =======
  //final bool hiddenPass;

// >>>>>>> 50793c904c9ea87e33850f0c1d542a79068dbf28
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
      child: Container(
        margin: EdgeInsets.only(
          right: 50,
          left: 50,
        ),
        child: TextFormField(
          onSaved: onSaved,
          validator: validator,
          keyboardType: textInputType,
          obscureText: isObscure,
          onChanged: onChanged,
          decoration: InputDecoration(

            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 15.0, 10.0),
            errorStyle: TextStyle(
              color: kRedColor,
              fontWeight: FontWeight.bold,
              fontSize: 11.0,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: kRedColor,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(35.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kRedColor, width: 3.0),
              borderRadius: BorderRadius.circular(35.0),
            ),
            hintText: hintMessage,
            hintStyle: kTextFieldHintStyle,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPinkColor, width: 3.0),
              borderRadius: BorderRadius.circular(35.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPinkColor, width: 3.0),
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
          //obscureText: hiddenPass,
        ),
      ),
    );
  }
}
