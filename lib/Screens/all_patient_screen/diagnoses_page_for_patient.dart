import 'package:alwasef_app/Screens/all_doctor_screens/add_diagnosis.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class PatientDiagnoses extends StatelessWidget {
  PatientDiagnoses({this.uid});
  final String uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
        body: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/Patient')
                  .doc(uid)
                  .collection('/Diagnoses')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot diagnoses = snapshot.data.docs[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: kGreyColor,
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.build_circle_outlined,
                                  size: 50,
                                ),
                                title: Text(
                                  diagnoses.data()['medical-diagnosis'],
                                  style: kBoldLabelTextStyle,
                                ),
                                // subtitle: Text(
                                //   '  ${prescription.data()['administration-route']}  -   ${prescription.data()['tradeName']} ${prescription.data()['tradeName']} ',
                                //   style: TextStyle(
                                //       color: Colors.black45,
                                //       fontSize: 14.0,
                                //       fontWeight: FontWeight.w500),
                                // ),

                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      diagnoses
                                          .data()['diagnosis-creation-date'],
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13.0),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: klighterColor,
                                thickness: 0.9,
                                endIndent: 20,
                                indent: 20,
                              ),
                              ListTile(
                                title: Text(
                                  ' وصف التشخيص',
                                  style: ksubBoldLabelTextStyle,
                                ),
                                subtitle: Text(
                                  '${'${diagnoses.data()['diagnosis-description']}'}',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'النصيحة الطبية',
                                  style: ksubBoldLabelTextStyle,
                                ),
                                subtitle: Text(
                                  '${diagnoses.data()['medical-advice']}',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Container(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(10.0),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             Text(
                              //               ' وصف التشخيص',
                              //               style: ksubBoldLabelTextStyle,
                              //             ),
                              //             SizedBox(
                              //               height: 6.0,
                              //             ),
                              //             Text(
                              //               '${'${diagnoses.data()['diagnosis-description']}'}',
                              //               style: TextStyle(
                              //                 color: Colors.black45,
                              //                 fontSize: 15.0,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         SizedBox(
                              //           height: 10.0,
                              //         ),
                              //         Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               'النصيحة الطبية',
                              //               style: ksubBoldLabelTextStyle,
                              //             ),
                              //             SizedBox(
                              //               height: 6.0,
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Container(
                              //                   width: 200,
                              //                   child: Text(
                              //                     '${diagnoses.data()['medical-advice']}',
                              //                     style: TextStyle(
                              //                       color: Colors.black45,
                              //                       fontSize: 15.0,
                              //                       fontWeight: FontWeight.bold,
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 Row(
                              //                   children: [
                              //                     Icon(
                              //                       Icons.edit_outlined,
                              //                       color: Colors.black54,
                              //                     ),
                              //                     Icon(
                              //                       Icons.delete_outline,
                              //                       color: Colors.black54,
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      });
                }
                return SizedBox();
              }),
        ));
  }
}