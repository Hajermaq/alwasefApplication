import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class DoctorMainPage extends StatefulWidget {
  static const String id = 'doctor_main_screen';
  @override
  _DoctorMainPageState createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  //requirements for the search
  TextEditingController editingController = TextEditingController();
  //list of 9999 items
  // final datas = List<String>.generate(100, (i) => " $i رقم ");
  // empty list
  List<String> names = [];
  var db = FirebaseFirestore.instance;

  void getData() {
    print('hello');
    FirebaseFirestore.instance.collection('/Patient').get().then((value) {
      var alldocument = value.data();
    });
  }

  //
  // return StreamBuilder(
  // stream: FirebaseFirestore.instance.collection('Patient').snapshots(),
  // builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  // if (!snapshot.hasData) {
  // return Text('has no data');
  // } else {
  // final allDocuments = snapshot.data.docs;
  // for (var document in allDocuments) {
  // final patientName = document.get('patient-name').toString();
  // names.add(patientName);
  // }
  // return Container();
  // }
  // });
  @override
  void initState() {
    super.initState();
    getData();
  }

  // filterSearchResult(String query) {
  //   //created an empty list
  //   List<String> dummySearchList = List<String>();
  //   // added the duplicatedItems <fixed>
  //   dummySearchList.addAll(duplicateItems);
  //   if (query.isNotEmpty) {
  //     List<String> sugguestedItems = List<String>();
  //     //loop through the duppySearchList and find a match in search bar
  //     // if found a match add the item in a new list >> sugguestedItems
  //     dummySearchList.forEach((item) {
  //       if (item.contains(query) || item.contains(query.toLowerCase())) {
  //         sugguestedItems.add(item);
  //       }
  //     });
  //     // then notify the framework that there has been a change which is
  //     // 1. we cleared the items list
  //     // 2. instead we add the matched results
  //     setState(() {
  //       items.clear();
  //       items.addAll(sugguestedItems);
  //     });
  //     // if there is no match we skip
  //     return;
  //   } //end of if
  //   else {
  //     setState(() {
  //       items.clear();
  //       items.addAll(duplicateItems);
  //     });
  //   }
  // }
  //

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < names.length; i++) {
      print(names[i]);
    }
    return Scaffold(
      body: ScrollNavigation(
        barStyle: NavigationBarStyle(
          background: Colors.white,
          activeColor: kDarkGreenColor,
          verticalPadding: 15.0,
        ),
        identiferStyle: NavigationIdentiferStyle(
          color: kDarkGreenColor,
        ),
        pages: [
          Container(
            child: Text('Home Page'),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: TextField(
                      textAlign: TextAlign.end,
                      onChanged: (value) {
                        // filterSearchResult(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        hintText: 'ابحث',
                        hintStyle: kTextFieldHintStyle,
                        suffixIcon: Icon(
                          Icons.search,
                          color: kLightColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kLightGreenColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kLightGreenColor,
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: UserManagement().listPatients(),
                ),
              ],
            ),
          ),
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
    );
  }
}
