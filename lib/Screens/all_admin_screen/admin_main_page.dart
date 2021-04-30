import 'package:alwasef_app/Screens/all_admin_screen/bar_admin_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import '../../constants.dart';
import 'bar_doctors_list.dart';
import 'bar_patients_list.dart';
import 'bar_pharmacists_list.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_main_screen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
              HospitalPatients(),
              //search Page
              HospitalDoctors(),
              //Profile Page
              HospitalPharmacist(),
              AdminProfileInfo(),
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
