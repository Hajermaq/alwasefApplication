import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants.dart';

class PatientPastPrescriptions extends StatefulWidget {
  PatientPastPrescriptions({this.uid});
  final String uid;

  @override
  _PatientPastPrescriptionsState createState() => _PatientPastPrescriptionsState();
}

class _PatientPastPrescriptionsState extends State<PatientPastPrescriptions> {
  String searchValue = '';
  // doctor info
  String doctorName = '';
  String doctorSpeciality = '';
  String experienceYears = '';
  String doctorPhoneNumber = '';

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
      body: Column(
          children: [
            FilledRoundTextFields(
              hintMessage: 'ابحث عن وصفة',
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
                      .collection('/PastPrescriptions')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text(
                          'لا يوجد وصفات سايقة.',
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot prescription =
                            snapshot.data.docs[index];

                            String prescriberID = prescription.data()['prescriber-id'];
                            getDoctorInfo(prescriberID); //TODO: test this يمكن يكون اسم الواصف لكل الوصفات نفس الاسم

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
                                        icon: Icon(Icons.delete, color: Colors.brown),
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
                                            SizedBox(),
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
            )
          ]
      ),
    );
  }
}