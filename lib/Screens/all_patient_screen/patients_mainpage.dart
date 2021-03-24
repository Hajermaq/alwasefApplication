import 'package:alwasef_app/Screens/all_patient_screen/prescriptions_calendar.dart';
import 'package:alwasef_app/Screens/all_patient_screen/prescriptions_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/Screens/services/provider_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import '../../constants.dart';
import 'patient_profile_info.dart';

class PatientMainPage extends StatefulWidget {
  static const String id = 'patient_screen';
  @override
  _PatientMainPageState createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String name = ' ';

  getName() async {
    await FirebaseFirestore.instance
        .collection('/Patient')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      name = doc.data()['patient-name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getName();
    });

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
              PrescriptionsReports(
                uid: FirebaseAuth.instance.currentUser.uid,
              ),
              //search Page
              PrescriptionsCalendar(
                uid: FirebaseAuth.instance.currentUser.uid,
              ),
              //Profile Page
              PatientProfileInfo(
                uid: currentUser.uid.toString(),
                email: currentUser.email.toString(),
                name: name.toString(),
              ),
            ], //end of pages
            items: [
              ScrollNavigationItem(
                icon: Icon(Icons.receipt_outlined),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.calendar_today),
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
