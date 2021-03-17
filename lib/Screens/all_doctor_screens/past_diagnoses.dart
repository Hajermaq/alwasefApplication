import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';

class PastDiagnoses extends StatelessWidget {
  PastDiagnoses({this.uid});
  final String uid;

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
                builder: (context) => AddPrescriptions(
                  uid: uid,
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
        body: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/Patient')
                  .doc(uid)
                  .collection('/Pas')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot prescription =
                            snapshot.data.docs[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context, builder: buildBottomSheet);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: kGreyColor,
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.build_circle_outlined,
                                    size: 50,
                                  ),
                                  title: Text(
                                    prescription.data()['tradeName'],
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
                                        prescription.data()[
                                            'prescription-creation-date'],
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       '',
                                        //       style: ksubBoldLabelTextStyle,
                                        //     ),
                                        //     SizedBox(
                                        //       width: 15.0,
                                        //     ),
                                        //     Text(
                                        //       '${prescription.data()['start-date']}',
                                        //       style: kValuesTextStyle,
                                        //     ),
                                        //   ],
                                        // ),
                                        // VerticalDivider(
                                        //   indent: 20,
                                        //   endIndent: 20.0,
                                        //   color: kLightColor,
                                        //   thickness: 1.5,
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       ' نهاية الوصفة',
                                        //       style: ksubBoldLabelTextStyle,
                                        //     ),
                                        //     SizedBox(
                                        //       width: 15.0,
                                        //     ),
                                        //     Text(
                                        //       '${prescription.data()['end-date']}',
                                        //       style: kValuesTextStyle,
                                        //     ),
                                        //   ],
                                        // ),
                                        // VerticalDivider(
                                        //   indent: 20,
                                        //   endIndent: 20.0,
                                        //   color: kLightColor,
                                        //   thickness: 1.5,
                                        // ),
                                        Row(
                                          children: [
                                            Text(
                                              ' التكرار',
                                              style: ksubBoldLabelTextStyle,
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              '${'${prescription.data()['frequency']}'}',
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // VerticalDivider(
                                        //   indent: 20,
                                        //   endIndent: 20.0,
                                        //   color: kLightColor,
                                        //   thickness: 1.5,
                                        // ),
                                        Row(
                                          children: [
                                            Text(
                                              'التعليمات',
                                              style: ksubBoldLabelTextStyle,
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              '${prescription.data()['instruction-note']}',
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'عدد مرات إعادة العبئة',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text(
                                                  '${prescription.data()['refill']}',
                                                  style: kValuesTextStyle,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [],
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
                      });
                }
              }),
        ));
  }
}
