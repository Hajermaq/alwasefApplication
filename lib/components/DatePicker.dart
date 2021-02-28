import 'package:alwasef_app/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
// import 'my_flutter_app_icons.dart';

final dateFormat = DateFormat("yyyy-MM-dd");

class DatePicker extends StatelessWidget {
  final Widget child;
  final Function onChanged;
  final Function validator;
  final String labelText;
  final Color textColor;
  final Color borderColor;
  final Color labelColor;
  final DateTime date;
  DatePicker({
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
    return SizedBox(
      height: 50,
      width: 350,
      child: DateTimeField(
          validator: validator,
          onChanged: onChanged,
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: textColor),
          resetIcon: Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              size: 42,
            ),
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: kGreyColor,
              size: 30,
            ),
            labelText: labelText,
            labelStyle: TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold, color: labelColor),
            fillColor: klighterColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(),
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
                        onSurface: kGreyColor, // numbers color
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
                firstDate: DateTime(2021),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2070));
          }),
    );
  }
}
