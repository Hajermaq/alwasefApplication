// import ''/AndroidStudioProjects/alwasef_app/lib/models/prescription_model.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/prescriptions_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDiagnosis extends StatefulWidget {
  AddDiagnosis({this.uid});
  final String uid;
  static final String id = 'add_diagnosis_screen';
  @override
  _AddDiagnosisState createState() => _AddDiagnosisState();
}

class _AddDiagnosisState extends State<AddDiagnosis> {
  //Data from Api with default value

  String prescriberId = FirebaseAuth.instance.currentUser.uid;
  // formatted date
  static final DateTime now = DateTime.now();
  final String creationDate = formatter.format(now);
  //Data from TextFields
  String medicalDiagnosis;
  String diagnosisDescription;
  String medicalAdvice;
  //Random Variables
  String stringFromTF;
  final maxLines = 5;
  // the creation on the prescription date
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // start date
  String startDate;
  // end date
  String endDate;

  //Lists

  //Methods

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: kLightColor,
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Container(
                            child: Text(
                              'أضف تشخيص جديد',
                              style: TextStyle(
                                color: kGreyColor,
                                fontSize: 40.0,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: kGreyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'التشخيص \n الصحي',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: Container(
                                            child: TextField(
                                              onTap: () {},
                                              onChanged: (value) {
                                                medicalDiagnosis = value;
                                              },
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white54,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: klighterColor,
                                  thickness: 0.9,
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'وصف \n التشخيص',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: Container(
                                            margin: EdgeInsets.all(12),
                                            height: maxLines * 24.0,
                                            child: TextField(
                                              onChanged: (value) {
                                                diagnosisDescription = value;
                                              },
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              maxLines: maxLines,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white54,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: klighterColor,
                                  thickness: 0.9,
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'النصيحة\n الطبية\t\t\t\t',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: Container(
                                            margin: EdgeInsets.all(12),
                                            height: maxLines * 24.0,
                                            child: TextField(
                                              onChanged: (value) {
                                                medicalAdvice = value;
                                              },
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              maxLines: maxLines,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white54,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 100.0, vertical: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                              textColor: Colors.white54,
                              color: kGreyColor,
                              child: Text(
                                'إرسال',
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontFamily: 'Montserrat',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              onPressed: () {
                                UserManagement().newDiagnosisSetUp(
                                    context,
                                    widget.uid,
                                    prescriberId,
                                    creationDate,
                                    startDate,
                                    endDate,
                                    medicalDiagnosis,
                                    diagnosisDescription,
                                    medicalAdvice);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
