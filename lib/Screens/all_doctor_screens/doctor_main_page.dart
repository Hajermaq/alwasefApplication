import 'package:alwasef_app/Screens/all_doctor_screens/doctor_profile_info.dart';
import 'package:alwasef_app/Screens/services/provider_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import '../../constants.dart';
import 'doctor_home_page.dart';
import 'doctor_patients_reports.dart';

class DoctorMainPage extends StatefulWidget {
  static const String id = 'doctor_main_screen';
  @override
  _DoctorMainPageState createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  //FireStore
  var db = FirebaseFirestore.instance;

  // Variables
  String currentName;
  String currentEmail;
  String currentUID;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xffE4E8F4),
      ),
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomPadding: false,
          body: ScrollNavigation(
            showIdentifier: false,
            barStyle: NavigationBarStyle(
              background: Color(0xffBBC6E3),
              activeColor: kScaffoldBackGroundColor,
              verticalPadding: 15.0,
            ),
            pages: [
              // Home page
              DoctorHomePage(),
              //search Page
              PatientData(),
              // patients reports
              PatientsReports(),
              //Profile Page
              DoctorProfileInfo(),
            ], //end of pages
            items: [
              ScrollNavigationItem(
                icon: Icon(Icons.home_outlined),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.search_outlined),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.receipt_outlined),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.account_circle_outlined),
              ),
            ], // end of items
          ),
        ),
      ),
    );
  }
}
