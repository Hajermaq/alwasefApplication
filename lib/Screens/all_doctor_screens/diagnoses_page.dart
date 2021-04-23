import 'package:alwasef_app/Screens/all_doctor_screens/add_diagnosis.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_diagnosis.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';

class Diagnoses extends StatefulWidget {
  final String uid;
  Diagnoses({this.uid});
  @override
  _DiagnosesState createState() => _DiagnosesState();
}

class _DiagnosesState extends State<Diagnoses> {
  String searchValue = '';
  Widget noButton;
  Widget yesButton;

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
          },
        ),
        body: Column(
          children: [
            FilledRoundTextFields(
              hintMessage: 'ابحث عن تشخيص',
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
                      return Center(
                          child: CircularProgressIndicator(
                              backgroundColor: kGreyColor,
                              valueColor: AlwaysStoppedAnimation(kBlueColor)));
                    }
                    if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text(
                          'لا توجد تشخيصات.',
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
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
                              return Card(
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
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text(
                                                  '${'${diagnoses.data()['diagnosis-description']}'}',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'النصيحة الطبية',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 25.0,
                                                ),
                                                Text(
                                                  '${diagnoses.data()['medical-advice']}',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
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
                                                                  diagnoses.id,
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color:
                                                                      kGreyColor,
                                                                  width: 2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Text("تعديل"),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              yesButton =
                                                                  FlatButton(
                                                                      child: Text(
                                                                          'نعم'),
                                                                      onPressed:
                                                                          () async {
                                                                        UserManagement().PastDiagnosisSetUp(
                                                                            context,
                                                                            widget.uid,
                                                                            FirebaseAuth.instance.currentUser.uid,
                                                                            diagnoses.data()['diagnosis-creation-date'],
                                                                            diagnoses.data()['medical-diagnosis'],
                                                                            diagnoses.data()['diagnosis-description'],
                                                                            diagnoses.data()['medical-advice']);
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('/Patient')
                                                                            .doc(widget.uid)
                                                                            .collection('/Diagnoses')
                                                                            .doc(diagnoses.id)
                                                                            .delete();
                                                                        Flushbar(
                                                                          backgroundColor:
                                                                              kLightColor,
                                                                          borderRadius:
                                                                              4.0,
                                                                          margin:
                                                                              EdgeInsets.all(8.0),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                          messageText:
                                                                              Text(
                                                                            ' تم حذف التشخيص بنجاح.',
                                                                            style:
                                                                                TextStyle(
                                                                              color: kBlueColor,
                                                                              fontFamily: 'Almarai',
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        )..show(context).then((r) =>
                                                                            Navigator.pop(context));
                                                                      });
                                                              noButton =
                                                                  FlatButton(
                                                                child:
                                                                    Text('لا'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              );

                                                              return AlertDialog(
                                                                title: Text(
                                                                    'هل أنت متأكد من حذف التشخيص؟',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kBlueColor,
                                                                      fontFamily:
                                                                          'Almarai',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                titleTextStyle: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                actions: [
                                                                  yesButton,
                                                                  noButton
                                                                ],
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25)),
                                                                ),
                                                                elevation: 24.0,
                                                              );
                                                            });
                                                      },
                                                      color: klighterColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color:
                                                                      kGreyColor,
                                                                  width: 2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Text("حذف"),
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
                              );
                            }
                            return SizedBox();
                          });
                    }
                  }),
            ),
          ],
        ));
  }
}
