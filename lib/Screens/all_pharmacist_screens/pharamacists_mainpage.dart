import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import '../../constants.dart';
import 'bar_pharmacist_home_page.dart';
import 'bar_pharmacist_profile.dart';
import 'bar_search_patients.dart';

class PharmacistMainPage extends StatefulWidget {
  static const String id = 'pharmacist_screen';
  @override
  _PharmacistMainPageState createState() => _PharmacistMainPageState();
}

class _PharmacistMainPageState extends State<PharmacistMainPage> {
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
              PharmacistHomePage(),
              //search Page
              SearchPatientPage(),
              //patients reports
              //PatientsReports(condition: 'pharmacist-id'),
              //profile
              PharmacistProfileInfo(),
            ],
            //end of pages
            items: [
              ScrollNavigationItem(
                icon: Icon(Icons.home_outlined),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.search_outlined),
              ),
              // ScrollNavigationItem(
              //   icon: Icon(Icons.receipt_outlined),
              // ),
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
