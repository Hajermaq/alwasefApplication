import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';

class PastPrescriptions extends StatefulWidget {
  PastPrescriptions({this.uid});
  final String uid;
  @override
  _PastPrescriptionsState createState() => _PastPrescriptionsState();
}

class _PastPrescriptionsState extends State<PastPrescriptions> {
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
                builder: (context) => AddPrescriptions(
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
                      .collection('/PastPrescriptions ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot prescription =
                                snapshot.data.docs[index];
                            String status = prescription.data()['status'];
                            //search by
                            String tradeName = prescription.data()['tradeName'];
                            String dose =
                                prescription.data()['dose'].toString();
                            // search logic
                            if (tradeName
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                tradeName
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase()) ||
                                dose
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                dose
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
                                          // TODO: change it to different names maybe?
                                          prescription.data()['tradeName'],
                                          style: kBoldLabelTextStyle,
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            prescription.data()[
                                                'prescription-creation-date'],
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15.0,
                                                letterSpacing: 2.0),
                                          ),
                                        ),
                                        trailing: OutlinedButton.icon(
                                          icon: status == 'pending'
                                              ? Icon(
                                                  Icons.hourglass_top_outlined,
                                                  color: kBlueColor,
                                                )
                                              : Icon(
                                                  Icons.update,
                                                  color: kBlueColor,
                                                ),
                                          label: Text(
                                            "${prescription.data()['status']}",
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
                                                    'الجرعة',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${prescription.data()['dose']} ${prescription.data()['dose-unit']}',
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
                                                    ' التكرار',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${'${prescription.data()['frequency']}'}',
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
                                                    'التعليمات',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${prescription.data()['instruction-note']}',
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
                                                    'عدد مرات إعادة العبئة',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${prescription.data()['refill']}',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
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
