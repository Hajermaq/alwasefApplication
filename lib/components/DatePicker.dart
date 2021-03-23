import 'package:alwasef_app/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'my_flutter_app_icons.dart';

final dateFormat = DateFormat("yyyy-MM-dd");

class DatePicker extends StatelessWidget {
  final Widget child;
  final Function onChanged;
  final Function onSaved;
  final Function validator;
  final String labelText;
  final Color textColor;
  final Color borderColor;
  final Color labelColor;
  final String date;
  final DateTime initialValue;
  // final String date;
  DatePicker({
    this.onSaved,
    this.initialValue,
    this.labelText,
    this.date,
    this.textColor = Colors.black54,
    this.borderColor = klighterColor,
    this.labelColor = kGreyColor,
    this.onChanged,
    this.validator,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
      child: DateTimeField(
          onSaved: onSaved,
          textAlign: TextAlign.center,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          style: TextStyle(
            color: Colors.black54,
          ),
          resetIcon: Icon(
            Icons.cancel,
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            hintText: date.toString(),
            fillColor: Colors.white54,
            filled: true,
            labelText: labelText,
            labelStyle: GoogleFonts.almarai(
                color: kBlueColor, fontSize: 25.0, fontWeight: FontWeight.bold),
            errorStyle: TextStyle(
              color: kRedColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
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
          ),
          format: dateFormat,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: kBlueColor,
                        onPrimary: klighterColor,
                        surface: kLightColor,
                        onSurface: Colors.blueGrey, // numbers color
                      ),
                      dialogBackgroundColor: klighterColor,
                      // textTheme: TextTheme(
                      //     // headline4: textStyle3,
                      //     // headline2: textStyle1, //selected numbers
                      //     // bodyText1: textStyle1, //for the numbers
                      //     // overline: textStyle1, //for the title
                      //     // subtitle1: textStyle1, // for am or pm
                      //     // caption: textStyle1, //for h and m
                      //     // subtitle2: textStyle1, //for months
                      //     // button: textStyle1),
                      //     ),
                    ),
                    child: child,
                  );
                },
                context: context,
                firstDate: DateTime.now().subtract(Duration(days: 0)),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2070));
          }),
    );
  }
}
