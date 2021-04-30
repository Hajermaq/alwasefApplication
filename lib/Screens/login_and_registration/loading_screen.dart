import 'dart:async';

import 'package:alwasef_app/Screens/all_admin_screen/admin_main_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/all_patient_screen/patients_mainpage.dart';
import 'package:alwasef_app/Screens/all_pharmacist_screens/pharamacists_mainpage.dart';
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
