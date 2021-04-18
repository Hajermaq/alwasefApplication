import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class PatientPastDiagnoses extends StatefulWidget {
  PatientPastDiagnoses({this.uid});
  final String uid;

  @override
  _PatientPastDiagnosesState createState() => _PatientPastDiagnosesState();
}

class _PatientPastDiagnosesState extends State<PatientPastDiagnoses> {
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
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
                      .collection('/PastDiagnosis')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator(
                          backgroundColor: kGreyColor,
                          valueColor: AlwaysStoppedAnimation(kBlueColor)
                      )
                      );
                    } if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text(
                          'لا توجد تشخيصات سابقة.',
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
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              width: 2.0, color: kBlueColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                        ),
                                        onPressed: () {},
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
                                            Row(
                                              children: [
                                                Text(
                                                  'النصيحة الطبية',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
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
