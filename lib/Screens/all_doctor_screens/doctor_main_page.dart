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
  //requirements for the search
  TextEditingController editingController = TextEditingController();

//lists
  List<String> names = [];
  List<String> items = [];
  var db = FirebaseFirestore.instance;

  // Variables
  String currentName;
  String currentEmail;

  void getData() {
    print('hello');
    FirebaseFirestore.instance.collection('/Patient').get().then((value) {
      List<QueryDocumentSnapshot> documents = value.docs;
      for (var document in documents) {
        String name = document.get('patient-name');
        names.add(name);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  filterSearchResult(String query) {
    //created an empty list
    List<String> dummySearchList = List<String>();
    // added the duplicatedItems <fixed>
    dummySearchList.addAll(names);
    if (query.isNotEmpty) {
      List<String> sugguestedItems = List<String>();
      //loop through the duppySearchList and find a match in search bar
      // if found a match add the item in a new list >> sugguestedItems
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          sugguestedItems.add(item);
        }
      });
      // then notify the framework that there has been a change which is
      // 1. we cleared the items list
      // 2. instead we add the matched results
      setState(() {
        items.clear();
        items.addAll(sugguestedItems);
      });
      // if there is no match we skip
      return;
    } //end of if
    else {
      setState(() {
        items.clear();
        items.addAll(names);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xffE4E8F4),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
              Column(
                children: [
                  FilledRoundTextFields(
                      fillColor: kGreyColor,
                      color: kScaffoldBackGroundColor,
                      hintMessage: 'ابحث',
                      onChanged: (value) {
                        filterSearchResult(value);
                      }),
                  Provider.of<PatientData>(context).streamBuilder(),
                ],
              ),
              //Profile Page
              Container(
                child: Text('Home Page'),
              ),
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
