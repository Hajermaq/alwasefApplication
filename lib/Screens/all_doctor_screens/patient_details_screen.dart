import 'package:alwasef_app/Screens/all_doctor_screens/diagnoses_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/past_diagnoses_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/patient_medical_history.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/prescriptions_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class PatientDetails extends StatefulWidget {
  static final String id = 'patient_details_screen';
  final UserManagement user = UserManagement();
  final String name;
  final String email;
  final String uid;
  PatientDetails({this.name, this.email, this.uid});
  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails>
    with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: kLightColor),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    color: klighterColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: kLightColor,
                            child: Icon(
                              Icons.person,
                              color: kBlueColor,
                              size: 50,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.name,
                                style: TextStyle(
                                    color: kBlueColor, fontSize: 30.0),
                              ),
                              SizedBox(
                                height: 7.0,
                              ),
                              Text(
                                widget.email,
                                style: TextStyle(
                                    color: kBlueColor, fontSize: 20.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      color: klighterColor,
                      child: Column(
                        children: [
                          DefaultTabController(
                            length: 5,
                            child: TabBar(
                              controller: _tabController,
                              labelStyle: TextStyle(
                                  //up to your taste
                                  fontWeight: FontWeight.w700),
                              indicatorSize:
                                  TabBarIndicatorSize.label, //makes it better
                              labelColor: kBlueColor, //Google's sweet blue
                              unselectedLabelColor: kGreyColor, //niceish grey
                              isScrollable: true, //up to your taste
                              indicator: MD2Indicator(
                                  //it begins here
                                  indicatorHeight: 3,
                                  indicatorColor: kBlueColor,
                                  indicatorSize: MD2IndicatorSize
                                      .normal //3 different modes tiny-normal-full
                                  ),
                              tabs: <Widget>[
                                Tab(
                                  text: "الوصفات الطبية",
                                ),
                                Tab(
                                  text: "التشخيصات",
                                ),
                                Tab(
                                  text: "التاريخ الطبي",
                                ),
                                Tab(
                                  text: "الوصفات السابقة",
                                ),
                                Tab(
                                  text: "التشخيصات السابقة",
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DefaultTabController(
                              length: 5,
                              child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Prescriptions(
                                      uid: widget.uid,
                                    ),
                                    Diagnoses(
                                      uid: widget.uid,
                                    ),
                                    PatientMedicalHistory(
                                      uid: widget.uid,
                                    ),
                                    PastPrescriptions(
                                      uid: widget.uid,
                                    ),
                                    PastDiagnoses(
                                      uid: widget.uid,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //tabs
              ],
            ),
          ),
        ),
      ),
    );
  }
}
