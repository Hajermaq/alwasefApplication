import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants.dart';
import 'check_prescriptions_inconsistencies.dart';

class Prescriptions2 extends StatefulWidget {
  Prescriptions2({this.uid});
  final String uid;
  @override
  _Prescriptions2State createState() => _Prescriptions2State();
}

class _Prescriptions2State extends State<Prescriptions2> {
  String searchValue = '';
  List inconsistencyResult;
  Widget yesButton;
  Widget noButton;
  String doctorName = '';
  String doctorSpeciality = '';
  String experienceYears = '';
  String doctorPhoneNumber = '';

  List<Widget> alertContent(List<dynamic> result){
    List<Widget> list = [];
    for (var i=0; i<result.length ;i++){
      list.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('- '),
                    Text(result[i][0]),
                    Text(' (!) '),
                    Text(result[i][1]),
                  ],
                ),
              ],
            ),
          )
      );
    }
    return list;
  }

  getDoctorInfo(String doctorID) async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(doctorID)
        .get()
        .then((doc) {
      doctorName = doc.data()['doctor-name'];
      experienceYears = doc.data()['experience-years'];
      doctorPhoneNumber = doc.data()['phone-number'];
      if (doc.data()['speciality'] == 'طبيب قلب') {
        doctorSpeciality = 'cardiologist';
      } else if (doc.data()['speciality'] == 'طبيب باطنية') {
        doctorSpeciality = 'Internal medicine physicians';
      } else if (doc.data()['speciality'] == 'طبيب أسرة') {
        doctorSpeciality = 'family physician';
      } else {
        doctorSpeciality = 'Psychologist';
      }
      print(doctorName);
      if (mounted) {
        setState(() {});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.build),
          backgroundColor: kBlueColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (inconsistencyResult[0] == 'can not compare less than 2'){
                    return AlertDialog(
                      title: Column(
                        children: [
                          Icon(Icons.announcement_outlined, color: Colors.white, size: 75),
                          SizedBox(height: 50),
                          Text('ليس هناك عدد كاف من الوصفات لمقارنته',
                              style: TextStyle(fontFamily: 'Almarai',),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      elevation: 24.0,
                      backgroundColor: kScaffoldBackGroundColor,
                    );
                  } else if (inconsistencyResult[0] == 'no inconsistencies') {
                    int compared = inconsistencyResult[1];
                    return AlertDialog(
                      title: Column(
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, color: Colors.green, size: 75),
                          SizedBox(height: 50),
                          Text('تم مقارنة $compared وصفة',
                            style: TextStyle(fontFamily: 'Almarai',),
                            textAlign: TextAlign.center),
                          SizedBox(height: 13),
                          Text('ولم يتم تحديد أي خطر على المريض',
                              style: TextStyle(fontFamily: 'Almarai',),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      elevation: 24.0,
                      backgroundColor: kScaffoldBackGroundColor,
                    );
                  } else {
                    int compared = inconsistencyResult[1];
                    return AlertDialog(
                      title: Column(
                        children: [
                          Icon(Icons.warning_amber_outlined, color: Colors.red, size: 75),
                          SizedBox(height: 50),
                          Text('تم مقارنة $compared وصفة',
                              style: TextStyle(fontFamily: 'Almarai',),
                              textAlign: TextAlign.center),
                          SizedBox(height: 13),
                          Text('وتم تحديد خطر على المريض',
                              style: TextStyle(fontFamily: 'Almarai',),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      content: Column(
                        children: alertContent(inconsistencyResult[0]),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      elevation: 24.0,
                      backgroundColor: kScaffoldBackGroundColor,
                    );
                  }
                }
            );
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
                      .collection('/Prescriptions')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // the prescriptions list that will be checked
                    List drugsToCheck = [];
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } if(snapshot.data.docs.length == 0){
                      inconsistencyResult = CheckInconsistencies().check(drugsToCheck);
                      return Center(
                          child: Text(
                          'لا يوجد وصفات طبية لهذا المريض.',
                          style: TextStyle(color: Colors.black54, fontSize: 17),));
                    } else {
                      snapshot.data.docs.forEach((doc){
                        String scientificName = doc.data()['scientificName'];
                        drugsToCheck.add(scientificName);
                      });
                      inconsistencyResult = CheckInconsistencies().check(drugsToCheck);
                      // to test
                      //inconsistencyResult = CheckInconsistencies().check(['Acetylsalicylicacid', 'Warfarin','Atenolol']);

                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            Widget statusIcon;
                            DocumentSnapshot prescription =
                              snapshot.data.docs[index];
                            String status = prescription.data()['status'];
                            String prescriberID = prescription.data()['prescriber-id'];
                            //search by
                            String tradeName = prescription.data()['tradeName'];
                            String dose = prescription.data()['dose'].toString();

                            if(status == 'pending'){
                              statusIcon = Icon(Icons.hourglass_top_outlined, color: kBlueColor,);
                            } else if (status == 'updated') {
                              statusIcon = Icon(Icons.update, color: kBlueColor,);
                            } else if (status == 'inconsistent') {
                              statusIcon = Icon(Icons.warning_amber_outlined, color: Colors.red);
                            } else if (status == 'dispensed') {
                              statusIcon = Icon(Icons.assignment_turned_in_outlined, color: Colors.green);
                            }

                            getDoctorInfo(prescriberID);

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
                                        icon: statusIcon,
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
                                                  'الاسم العلمي',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text(
                                                  '${prescription.data()['scientificName']}',
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
                                                  'الجرعة',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 65.0,
                                                ),
                                                Text(
                                                  '${prescription.data()['strength-unit']}',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  '${prescription.data()['strength']}',
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
                                                  'شكل الجرعة',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 19.0,
                                                ),
                                                Text(
                                                  '${prescription.data()['pharmaceutical-form']}',
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
                                                  'التكرار',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 65.0,
                                                ),
                                                Text(
                                                  '${prescription.data()['frequency']}',
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
                                                  'تعليمات',
                                                  style: ksubBoldLabelTextStyle,
                                                ),
                                                SizedBox(
                                                  width: 50.0,
                                                ),
                                                InkWell(
                                                  child: Text(
                                                    'انقر هنا للقراءة',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            height: 250,
                                                            child: Card(
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    15.0),
                                                              ),
                                                              color: kGreyColor,
                                                              child: Column(
                                                                children: [
                                                                  ListTile(
                                                                    title: Text(
                                                                      'تعليمات عن الوصفة',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style:
                                                                      kBoldLabelTextStyle,
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    color:
                                                                    klighterColor,
                                                                    thickness:
                                                                    0.9,
                                                                    endIndent:
                                                                    20,
                                                                    indent: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .all(
                                                                        15.0),
                                                                    child:
                                                                    Container(
                                                                      child:
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          prescription.data()['note_2'] == ''
                                                                              ? Padding(
                                                                            padding: const EdgeInsets.only(right: 80.0),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      '( 1 )',
                                                                                      style: ksubBoldLabelTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 15.0,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${prescription.data()['instruction-note']}',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black45,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
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
                                                                                      '( 2 )',
                                                                                      style: ksubBoldLabelTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 15.0,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${prescription.data()['note_1']}',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black45,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                              : Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    '( 1 )',
                                                                                    style: ksubBoldLabelTextStyle,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15.0,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      '${prescription.data()['instruction-note']}',
                                                                                      style: TextStyle(
                                                                                        color: Colors.black45,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
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
                                                                                    '( 2 )',
                                                                                    style: ksubBoldLabelTextStyle,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15.0,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      '${prescription.data()['note_1']}',
                                                                                      style: TextStyle(
                                                                                        color: Colors.black45,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
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
                                                                                    '( 3 )',
                                                                                    style: ksubBoldLabelTextStyle,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15.0,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      '${prescription.data()['note_2']}',
                                                                                      style: TextStyle(
                                                                                        color: Colors.black45,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
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
                                                        });
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
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
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Column(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceEvenly,
                                            //   children: [
                                            //     prescription.data()['note_2'] ==
                                            //             ''
                                            //         ? Padding(
                                            //             padding:
                                            //                 const EdgeInsets
                                            //                         .only(
                                            //                     right: 80.0),
                                            //             child: Column(
                                            //               children: [
                                            //                 Row(
                                            //                   children: [
                                            //                     Text(
                                            //                       '( 1 )',
                                            //                       style:
                                            //                           ksubBoldLabelTextStyle,
                                            //                     ),
                                            //                     SizedBox(
                                            //                       width: 15.0,
                                            //                     ),
                                            //                     Expanded(
                                            //                       child: Text(
                                            //                         '${prescription.data()['instruction-note']}',
                                            //                         style:
                                            //                             TextStyle(
                                            //                           color: Colors
                                            //                               .black45,
                                            //                           fontSize:
                                            //                               15.0,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .bold,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //                 SizedBox(
                                            //                   height: 10,
                                            //                 ),
                                            //                 Row(
                                            //                   children: [
                                            //                     Text(
                                            //                       '( 2 )',
                                            //                       style:
                                            //                           ksubBoldLabelTextStyle,
                                            //                     ),
                                            //                     SizedBox(
                                            //                       width: 15.0,
                                            //                     ),
                                            //                     Expanded(
                                            //                       child: Text(
                                            //                         '${prescription.data()['note_1']}',
                                            //                         style:
                                            //                             TextStyle(
                                            //                           color: Colors
                                            //                               .black45,
                                            //                           fontSize:
                                            //                               15.0,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .bold,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           )
                                            //         : Column(
                                            //             children: [
                                            //               Row(
                                            //                 children: [
                                            //                   Text(
                                            //                     '( 1 )',
                                            //                     style:
                                            //                         ksubBoldLabelTextStyle,
                                            //                   ),
                                            //                   SizedBox(
                                            //                     width: 15.0,
                                            //                   ),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       '${prescription.data()['instruction-note']}',
                                            //                       style:
                                            //                           TextStyle(
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         fontSize:
                                            //                             15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               SizedBox(
                                            //                 height: 10,
                                            //               ),
                                            //               Row(
                                            //                 children: [
                                            //                   Text(
                                            //                     '( 2 )',
                                            //                     style:
                                            //                         ksubBoldLabelTextStyle,
                                            //                   ),
                                            //                   SizedBox(
                                            //                     width: 15.0,
                                            //                   ),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       '${prescription.data()['note_1']}',
                                            //                       style:
                                            //                           TextStyle(
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         fontSize:
                                            //                             15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               SizedBox(
                                            //                 height: 10,
                                            //               ),
                                            //               Row(
                                            //                 children: [
                                            //                   Text(
                                            //                     '( 3 )',
                                            //                     style:
                                            //                         ksubBoldLabelTextStyle,
                                            //                   ),
                                            //                   SizedBox(
                                            //                     width: 15.0,
                                            //                   ),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       '${prescription.data()['note_2']}',
                                            //                       style:
                                            //                           TextStyle(
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         fontSize:
                                            //                             15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //             ],
                                            //           ),
                                            //   ],
                                            // ),
                                            Divider(
                                              color: klighterColor,
                                              thickness: 0.9,
                                              endIndent: 20,
                                              indent: 20,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'الواصف',
                                                      style:
                                                      ksubBoldLabelTextStyle,
                                                    ),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    Text(
                                                      'د.  $doctorName',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 20),
                                                  child: IconButton(
                                                    icon: Icon(
                                                        Icons.info_outline),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                              height: 200,
                                                              child: Card(
                                                                shape:
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      15.0),
                                                                ),
                                                                color:
                                                                kGreyColor,
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                      Text(
                                                                        'معلومات عن الطبيب',
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                        style:
                                                                        kBoldLabelTextStyle,
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color:
                                                                      klighterColor,
                                                                      thickness:
                                                                      0.9,
                                                                      endIndent:
                                                                      20,
                                                                      indent:
                                                                      20,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          15.0),
                                                                      child:
                                                                      Container(
                                                                        child:
                                                                        Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  'اسم الطبيب:',
                                                                                  style: ksubBoldLabelTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 47.0,
                                                                                ),
                                                                                Text(
                                                                                  'د.  $doctorName',
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
                                                                                  'عدد سنين الخبرة:',
                                                                                  style: ksubBoldLabelTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 15.0,
                                                                                ),
                                                                                Text(
                                                                                  '$experienceYears',
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
                                                                                  'مجال الإختصاص:',
                                                                                  style: ksubBoldLabelTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 15.0,
                                                                                ),
                                                                                Text(
                                                                                  '$doctorSpeciality',
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
                                                                                  'رقم الهاتف:',
                                                                                  style: ksubBoldLabelTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 54.0,
                                                                                ),
                                                                                Text(
                                                                                  '$doctorPhoneNumber',
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
                                                              ),
                                                            );
                                                          });
                                                    },
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
                                                    // alert doctor
                                                    RaisedButton(
                                                      color: klighterColor,
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: kGreyColor,
                                                              width: 2),
                                                          borderRadius:
                                                          BorderRadius.circular(10)),
                                                      child: Text("إرسال تنبيه للطبيب"),
                                                      onPressed: () async{
                                                        await FirebaseFirestore.instance
                                                            .collection('/Patient')
                                                            .doc(widget.uid)
                                                            .collection('/Prescriptions')
                                                            .doc(prescription.id)
                                                            .update({
                                                          'status': 'inconsistent',
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 10.0,),
                                                    // dispense prescription
                                                    RaisedButton(
                                                      color: klighterColor,
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: kGreyColor,
                                                              width: 2),
                                                          borderRadius:
                                                          BorderRadius.circular(10)),
                                                      child: Text("تأكيد الوصفة"),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              yesButton = FlatButton(
                                                                  child: Text('نعم'),
                                                                  onPressed:() async {
                                                                    await FirebaseFirestore.instance
                                                                        .collection('/Patient')
                                                                        .doc(widget.uid)
                                                                        .collection('/Prescriptions')
                                                                        .doc(prescription.id)
                                                                        .update({
                                                                      'status': 'dispensed'
                                                                    });
                                                                    Navigator.pop(context);
                                                                  }
                                                              );
                                                              noButton = FlatButton(
                                                                child: Text('لا'),
                                                                onPressed:() {
                                                                  Navigator.pop(context);
                                                                },
                                                              );

                                                              return AlertDialog(
                                                                title: Text('هل تريد تأكيد الوصفة؟',
                                                                    style: TextStyle(fontFamily: 'Almarai',),
                                                                    textAlign: TextAlign.center),
                                                                titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                actions: [
                                                                  yesButton,
                                                                  noButton
                                                                ],
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                ),
                                                                elevation: 24.0,
                                                                backgroundColor: Colors.black,
                                                              );
                                                            }
                                                        );
                                                      },
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
