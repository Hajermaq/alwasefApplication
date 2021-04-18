import 'dart:async';

import 'package:alwasef_app/Screens/all_admin_screen/admin_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/all_patient_screen/patients_mainpage.dart';
import 'package:alwasef_app/Screens/all_pharmacist_screens/pharamacists_mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({this.email, this.password, this.role});
  final String password;
  final String email;
  final String role;
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  // logIn() async {
  //   try {
  //     // Doctor
  //     await auth
  //         .signInWithEmailAndPassword(
  //             email: widget.email, password: widget.password)
  //         .then((value) {
  //       FirebaseFirestore.instance
  //           .collection('/Doctors')
  //           .where('email', isEqualTo: value.user.email)
  //           .get()
  //           .then((value) {
  //         value.docs.forEach((element) {
  //           if ('طبيب' == element.data()['role']) {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (BuildContext context) => DoctorMainPage(),
  //               ),
  //             );
  //           }
  //         });
  //       });
  //     });
  //     //patient
  //     await auth
  //         .signInWithEmailAndPassword(
  //             email: widget.email, password: widget.password)
  //         .then((value) {
  //       FirebaseFirestore.instance
  //           .collection('/Patient')
  //           .where('email', isEqualTo: value.user.email)
  //           .get()
  //           .then((value) {
  //         value.docs.forEach((element) {
  //           if ('مريض' == element.data()['role']) {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (BuildContext context) => PatientMainPage(),
  //               ),
  //             );
  //           }
  //         });
  //       });
  //     });
  //     //pharamacist
  //     await auth
  //         .signInWithEmailAndPassword(
  //             email: widget.email, password: widget.password)
  //         .then((value) {
  //       FirebaseFirestore.instance
  //           .collection('/Pharmacist')
  //           .where('email', isEqualTo: value.user.email)
  //           .get()
  //           .then((value) {
  //         SpinKitFadingCircle(
  //           itemBuilder: (BuildContext context, int index) {
  //             return DecoratedBox(
  //               decoration: BoxDecoration(
  //                 color: index.isEven ? Colors.red : Colors.green,
  //               ),
  //             );
  //           },
  //         );
  //         value.docs.forEach((element) {
  //           if ('صيدلي' == element.data()['role']) {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (BuildContext context) => PharmacistMainPage(),
  //               ),
  //             );
  //           }
  //         });
  //       });
  //     });
  //     //Hospital
  //     await auth
  //         .signInWithEmailAndPassword(
  //             email: widget.email, password: widget.password)
  //         .then((value) {
  //       FirebaseFirestore.instance
  //           .collection('/Hospital')
  //           .where('email', isEqualTo: value.user.email)
  //           .get()
  //           .then((value) {
  //         value.docs.forEach((element) {
  //           if ('موظف استقبال' == element.data()['role']) {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (BuildContext context) => AdminScreen(),
  //               ),
  //             );
  //           }
  //         });
  //       });
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: new Text(
  //                 'لم يتم العثور على مستخدم لهذا البريد الإلكتروني.',
  //                 style: TextStyle(color: kBlueColor)),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: new Text(
  //                   "حسنا",
  //                   style: TextStyle(color: kBlueColor),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else if (e.code == 'wrong-password') {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: new Text(
  //                 'كلمة المرور خاطئة. أعد المحاولة، أو انقر على "نسيت كلمة المرور" لإعادة ضبطها. ',
  //                 style: TextStyle(color: kBlueColor)),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: new Text(
  //                   "حسنا",
  //                   style: TextStyle(color: kBlueColor),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else if (e.code == 'too-many-requests') {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: new Text(
  //                 'يوجد محاولات كثيرة لتسجيل الدخول بهذا المستخدم، حاول مرة اخرى لاحقا.',
  //                 style: TextStyle(color: kBlueColor)),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: new Text(
  //                   "حسنا",
  //                   style: TextStyle(color: kBlueColor),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       print(e);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: new Text('حدث خطأ غير محدد.',
  //                 style: TextStyle(color: kBlueColor)),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: new Text(
  //                   "حسنا",
  //                   style: TextStyle(color: kBlueColor),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  // Navigator.pushReplacement(
  @override
  void initState() {
    super.initState();
    if (widget.role == 'طبيب') {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DoctorMainPage())));
    } else if (widget.role == 'مريض') {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PatientMainPage())));
    } else if (widget.role == 'صيدلي') {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PharmacistMainPage())));
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: kBlueColor,
        child: SpinKitRotatingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
