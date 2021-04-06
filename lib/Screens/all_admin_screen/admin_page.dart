import 'package:alwasef_app/Screens/all_doctor_screens/doctor_profile_info.dart';
import 'package:alwasef_app/Screens/services/provider_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import '../../constants.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'doctor_main_screen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
              Text(' '),
              //search Page
              Text(' '),
              //Profile Page
              Text(' '),
            ], //end of pages
            items: [
              ScrollNavigationItem(
                icon: Icon(
                  Icons.airline_seat_flat_outlined,
                ),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.person),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.person_add),
              ),
            ], // end of items
          ),
        ),
      ),
    );
  }
}
