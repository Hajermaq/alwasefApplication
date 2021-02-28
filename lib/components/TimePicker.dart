// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:flutter/material.dart';
// // import 'my_flutter_app_icons.dart';
//
// final timeFormat = DateFormat('hh:mm'
//     //"h:mm a"
//     );
//
// class TimePicker extends StatelessWidget {
//   String labelText;
//   Color borderColor;
//   Color textColor;
//   Color labelColor;
//   Function onChanged;
//   TimePicker(
//       {this.labelText,
//       this.textColor = white,
//       this.borderColor = white,
//       this.labelColor = white,
//       this.onChanged});
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       width: 350,
//       child: DateTimeField(
//         onChanged: onChanged,
//         style: TextStyle(
//             fontSize: 23, fontWeight: FontWeight.bold, color: textColor),
//         resetIcon: Icon(
//           Icons.cancel_outlined,
//           color: white,
//         ),
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             MyFlutterApp.alarm_clock,
//             color: yellow,
//             size: 30,
//           ),
//           labelText: "وقت تناول الدواء",
//           labelStyle: TextStyle(
//               fontSize: 23, fontWeight: FontWeight.bold, color: labelColor),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: borderColor,
//             ),
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: borderColor,
//             ),
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//         ),
//         format: timeFormat,
//         onShowPicker: (context, currentValue) async {
//           final time = await showTimePicker(
//             builder: (BuildContext context, Widget child) {
//               return Theme(
//                 data: ThemeData.dark().copyWith(
//                     colorScheme: ColorScheme.dark(
//                       primary: nave,
//                       onPrimary: yellow,
//                       surface: white,
//                       onSurface: nave,
//                     ),
//                     textTheme: TextTheme(
//                         headline2: textStyle4, //selected numbers
//                         bodyText1: textStyle1, //for the numbers
//                         overline: textStyle1, //for the title
//                         subtitle1: textStyle1, // for am or pm
//                         caption: textStyle1, //for h and m
//                         button: textStyle1)),
//                 child: child,
//               );
//             },
//             context: context,
//             initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//           );
//           return DateTimeField.convert(time);
//         },
//       ),
//     );
//   }
// }
