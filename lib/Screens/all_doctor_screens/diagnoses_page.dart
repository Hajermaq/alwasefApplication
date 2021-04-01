import 'package:alwasef_app/Screens/all_doctor_screens/add_diagnosis.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_diagnosis.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';

class Diagnoses extends StatefulWidget {
  final String uid;
  Diagnoses({this.uid});
  @override
  _DiagnosesState createState() => _DiagnosesState();
}

class _DiagnosesState extends State<Diagnoses> {
  String searchValue = '';

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: klighterColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            ListTile(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.note_add_outlined),
          backgroundColor: kBlueColor,
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDiagnosis(
                  uid: widget.uid,
                ),
              ),
            );
            // showModalBottomSheet(
            //   isScrollControlled: true,
            //   context: context,
            //   builder: (context) => AddPrescriptions(),
            // );
          },
        ),
        body: Column(
          children: [
            FilledRoundTextFields(
              hintMessage: 'ابحث عن الوصفة',
              fillColor: kGreyColor,
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/Patient')
                      .doc(widget.uid)
                      .collection('/Diagnoses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot diagnoses =
                                snapshot.data.docs[index];
                            String status = diagnoses.data()['status'];
                            String medicalDiagnosis =
                                diagnoses.data()['medical-diagnosis'];
                            // search logic
                            if (medicalDiagnosis
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                medicalDiagnosis
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase())) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: buildBottomSheet);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: kGreyColor,
                                  margin:
                                      EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          ' ${diagnoses.data()['medical-diagnosis']}',
                                          style: kBoldLabelTextStyle,
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            diagnoses.data()[
                                                'diagnosis-creation-date'],
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15.0,
                                                letterSpacing: 2.0),
                                          ),
                                        ),
                                        trailing: OutlinedButton.icon(
                                          icon: status == 'ongoing'
                                              ? Icon(
                                                  Icons.replay_circle_filled,
                                                  color: kBlueColor,
                                                )
                                              : Icon(
                                                  Icons.update,
                                                  color: kBlueColor,
                                                ),
                                          label: Text(
                                            "${diagnoses.data()['status']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: kBlueColor),
                                          ),
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 2.0, color: kBlueColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: klighterColor,
                                        thickness: 0.9,
                                        endIndent: 20,
                                        indent: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'وصف التشخيص',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${'${diagnoses.data()['diagnosis-description']}'}',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'النصيحة الطبية',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${diagnoses.data()['medical-advice']}',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      RaisedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpdateDiagnosis(
                                                                documentID:
                                                                    diagnoses
                                                                        .id,
                                                                uid: widget.uid,
                                                                medicalDiagnosis:
                                                                    diagnoses
                                                                            .data()[
                                                                        'medical-diagnosis'],
                                                                diagnosisDescription:
                                                                    diagnoses
                                                                            .data()[
                                                                        'diagnosis-description'],
                                                                medicalAdvice: diagnoses
                                                                        .data()[
                                                                    'medical-advice'],
                                                                creationDate: diagnoses
                                                                        .data()[
                                                                    'diagnosis-creation-date'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        color: klighterColor,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    kGreyColor,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text("Edit"),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () async {
                                                          UserManagement().PastDiagnosisSetUp(
                                                              context,
                                                              widget.uid,
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid,
                                                              diagnoses.data()[
                                                                  'diagnosis-creation-date'],
                                                              diagnoses.data()[
                                                                  'medical-diagnosis'],
                                                              diagnoses.data()[
                                                                  'diagnosis-description'],
                                                              diagnoses.data()[
                                                                  'medical-advice']);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  '/Patient')
                                                              .doc(widget.uid)
                                                              .collection(
                                                                  '/Diagnoses')
                                                              .doc(diagnoses.id)
                                                              .delete();
                                                        },
                                                        color: klighterColor,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    kGreyColor,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text("Delete"),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          });
                    }
                    return SizedBox();
                  }),
            ),
          ],
        ));
  }
}
