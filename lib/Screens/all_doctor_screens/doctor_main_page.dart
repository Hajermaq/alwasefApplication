import 'package:alwasef_app/Screens/all_doctor_screens/doctor_profile_info.dart';
import 'package:alwasef_app/Screens/services/provider_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';

import '../../constants.dart';

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
            barStyle: NavigationBarStyle(
              background: Color(0xffBBC6E3),
              activeColor: kScaffoldBackGroundColor,
              verticalPadding: 15.0,
            ),
            identiferStyle: NavigationIdentiferStyle(
              color: kScaffoldBackGroundColor,
            ),
            pages: [
              // Home page
              Container(
                child: Text('Home Page'),
              ),
              //search Page
              PatientData(),
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
                icon: Icon(Icons.account_circle_outlined),
              ),
            ], // end of items
          ),
        ),
      ),
    );
  }
}
