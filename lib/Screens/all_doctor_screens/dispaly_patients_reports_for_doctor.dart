import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class DisplayReportsForDoctor extends StatefulWidget {
  @override
  _DisplayReportsForDoctorState createState() =>
      _DisplayReportsForDoctorState();
}

class _DisplayReportsForDoctorState extends State<DisplayReportsForDoctor> {
  //variables
  String searchValue = ' ';
  int mapKey;
// methods
  getDoctorSpeciality() async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      if (doc.data()['doctor-speciality'] == 'طبيب قلب') {
        mapKey = 1;
      } else if (doc.data()['doctor-speciality'] == 'طبيب باطنية') {
        mapKey = 2;
      } else if (doc.data()['doctor-speciality'] == 'طبيب نفسي') {
        mapKey = 3;
      } else {
        mapKey = 4;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void initState() {
    super.initState();
    getDoctorSpeciality();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.grey,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(6.0),
              bottomLeft: Radius.circular(6.0),
            ),
          ),
          title: Text(
            'تقارير المرضى',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FilledRoundTextFields(
                hintMessage: 'ابحث باسم المريض أو الدواء',
                fillColor: kGreyColor,
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 15),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Patient')
                        .where('doctors_map.$mapKey',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: LinearProgressIndicator(
                                  backgroundColor: kGreyColor,
                                  valueColor:
                                      AlwaysStoppedAnimation(kBlueColor))),
                        );
                      }
                      if (snapshot.data.docs.length == 0) {
                        return Center(
                          child: Text(
                            'ليس لديك أي مرضى حاليا.',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 17),
                          ),
                        );
                      }
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot patient =
                                snapshot.data.docs[index];
                            String patientName = patient.data()['patient-name'];
                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('/Patient')
                                    .doc(patient.id)
                                    .collection('/Reports')
                                    .where('prescriber-id',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: LinearProgressIndicator(
                                              backgroundColor: kGreyColor,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      kBlueColor))),
                                    );
                                  }
                                  var reportQuery = snapshot.data;
                                  var reportsDocs = reportQuery.docs;

                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: reportsDocs.length,
                                      itemBuilder: (context, index) {
                                        var report = reportsDocs[index];
                                        String pharmacistID =
                                            report.data()['pharmacist-id'];
                                        String sideEffects = report
                                            .data()['side effects']
                                            .join('\n');
                                        String tradeName =
                                            report.data()['tradeName'];
                                        // search logic
                                        if (tradeName.toLowerCase().contains(
                                                searchValue.toLowerCase()) ||
                                            tradeName.toUpperCase().contains(
                                                searchValue.toUpperCase()) ||
                                            patientName.toLowerCase().contains(
                                                searchValue.toLowerCase()) ||
                                            patientName.toUpperCase().contains(
                                                searchValue.toUpperCase())) {
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            color: kGreyColor,
                                            margin: EdgeInsets.fromLTRB(
                                                8.0, 8.0, 8.0, 0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ListTile(
                                                    leading: Icon(Icons
                                                        .assignment_rounded),
                                                    title: Text(
                                                        'اسم المريض: $patientName',
                                                        style:
                                                            ksubBoldLabelTextStyle),
                                                    subtitle: Text(
                                                        'اسم الدواء: $tradeName '),
                                                  ),
                                                  Divider(
                                                    color: klighterColor,
                                                    thickness: 0.9,
                                                    endIndent: 20,
                                                    indent: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10.0, 7.0, 10.0, 10),
                                                    child: Container(
                                                      //height: 100,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(children: [
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                              'تم الانتهاء من الوصفة: ',
                                                              style:
                                                                  ksubBoldLabelTextStyle,
                                                            ),
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                                '${report.data()['completed']}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ]),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Row(children: [
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                                'تم الالتزام بالوصفة: ',
                                                                style:
                                                                    ksubBoldLabelTextStyle),
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                                '${report.data()['committed']}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ]),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Row(children: [
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                                'الأعراض الجانبية: ',
                                                                style:
                                                                    ksubBoldLabelTextStyle),
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text('$sideEffects',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ]),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Row(children: [
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text('ملاحظات: ',
                                                                style:
                                                                    ksubBoldLabelTextStyle),
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                                '${report.data()['notes']}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ]),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Divider(
                                                            color:
                                                                klighterColor,
                                                            thickness: 0.9,
                                                            endIndent: 20,
                                                            indent: 20,
                                                          ),
                                                          FutureBuilder(
                                                              future: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      '/Pharmacist')
                                                                  .doc(
                                                                      pharmacistID)
                                                                  .get(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Center(
                                                                      child: CircularProgressIndicator(
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation(Colors.transparent)));
                                                                }
                                                                DocumentSnapshot
                                                                    doc =
                                                                    snapshot
                                                                        .data;
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Text(
                                                                        'الصيدلي',
                                                                        style:
                                                                            ksubBoldLabelTextStyle,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            15.0,
                                                                      ),
                                                                      Text(
                                                                        'ص.  ${doc.data()['pharmacist-name']}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black45,
                                                                          fontSize:
                                                                              15.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      });
                                });
                          });
                    }),
              ),
            ],
          ),
        ));
  }
}
