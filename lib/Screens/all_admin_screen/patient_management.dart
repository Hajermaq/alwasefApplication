import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class PatientManagement extends StatefulWidget {
  PatientManagement({this.patient_id, this.map});
  final String patient_id;
  final Map map;

  @override
  _PatientManagementState createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  String doctor1_uid;
  String doctor2_uid;
  String doctor3_uid;
  String doctor4_uid;
  // String doctor1_name;
  // String doctor2_name;
  // String doctor3_name;
  // String doctor4_name;
  String pharmacist_uid;
  String speciality;
  var _selectedName;

  getDoctorinfo() async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      speciality = doc.data()['speciality'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    print(widget.map);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kLightColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: kLightColor,
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
            'صفحة المريض ',
            style: GoogleFonts.almarai(
              color: kBlueColor,
              fontSize: 28.0,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Patient')
                .doc(widget.patient_id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: kGreyColor,
                      valueColor: AlwaysStoppedAnimation(kBlueColor)),
                );
              }
              DocumentSnapshot doc = snapshot.data;
              Map docsMap = doc.get('doctors_map');

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kGreyColor,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ListTile(
                            title: Text(
                              'تعيين الأطباء',
                              textAlign: TextAlign.center,
                              style: kBoldLabelTextStyle,
                            ),
                          ),
                          Divider(
                            color: klighterColor,
                            thickness: 0.9,
                            endIndent: 20,
                            indent: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'طبيب قلب',
                                        style: ksubBoldLabelTextStyle,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('/Doctors')
                                              .where('hospital-uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance.currentUser.uid)
                                              .where('speciality',
                                                  isEqualTo: 'طبيب قلب')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text('has no data');
                                            } else {
                                              List<DropdownMenuItem>
                                                  hospitalsNames = [];
                                              var documents =
                                                  snapshot.data.docs;
                                              for (var document in documents) {
                                                hospitalsNames.add(
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      document.data()[
                                                                  'doctor-name'] ==
                                                              null
                                                          ? ''
                                                          : document.data()[
                                                              'doctor-name'],
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 15),
                                                    ),
                                                    value: '${document.id}',
                                                  ),
                                                );
                                              }
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 10.0, 0),
                                                margin: EdgeInsets.only(
                                                    right: 20, left: 50),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor: kLightColor,
                                                    style: kDropDownHintStyle,
                                                    hint: Text(
                                                      'فضلا اختر طبيبا',
                                                      style:
                                                          GoogleFonts.almarai(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    items: hospitalsNames,
                                                    // onTap: () {
                                                    //   setState(() {});
                                                    // },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        doctor1_uid = value;
                                                      });
                                                    },
                                                    value: doctor1_uid == null
                                                        ? widget.map['1']
                                                        : doctor1_uid,
                                                  ),
                                                ),
                                              );
                                            }
                                          }, // end of builder
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'طبيب باطنية',
                                        style: ksubBoldLabelTextStyle,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('/Doctors')
                                              .where('hospital-uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance.currentUser.uid)
                                              .where('speciality',
                                                  isEqualTo: 'طبيب باطنية')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text('has no data');
                                            } else {
                                              List<DropdownMenuItem>
                                                  hospitalsNames = [];
                                              var documents =
                                                  snapshot.data.docs;
                                              for (var document in documents) {
                                                hospitalsNames.add(
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      document.data()[
                                                          'doctor-name'],
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 15),
                                                    ),
                                                    value: '${document.id}',
                                                  ),
                                                );
                                              }
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 10.0, 0),
                                                margin: EdgeInsets.only(
                                                    right: 10, left: 50),

                                                // ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor: kLightColor,
                                                    style: kDropDownHintStyle,
                                                    hint: Text(
                                                      'فضلا اختر طبيبا',
                                                      style:
                                                          GoogleFonts.almarai(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    items: hospitalsNames,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        doctor2_uid = value;
                                                      });
                                                    },
                                                    value: doctor2_uid == null
                                                        ? widget.map['2']
                                                        : doctor2_uid,
                                                  ),
                                                ),
                                              );
                                            }
                                          }, // end of builder
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'طبيب نفسي',
                                        style: ksubBoldLabelTextStyle,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('/Doctors')
                                              .where('hospital-uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance.currentUser.uid)
                                              .where('doctor-speciality',
                                                  isEqualTo: 'طبيب نفسي')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text('has no data');
                                            } else {
                                              List<DropdownMenuItem>
                                                  hospitalsNames = [];
                                              var documents =
                                                  snapshot.data.docs;
                                              for (var document in documents) {
                                                hospitalsNames.add(
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      document.data()[
                                                          'doctor-name'],
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 15),
                                                    ),
                                                    value: '${document.id}',
                                                  ),
                                                );
                                              }
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 10.0, 0),
                                                margin: EdgeInsets.only(
                                                    right: 10, left: 50),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor: kLightColor,
                                                    style: kDropDownHintStyle,
                                                    hint: Text(
                                                      'فضلا اختر طبيبا',
                                                      style:
                                                          GoogleFonts.almarai(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    items: hospitalsNames,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        doctor3_uid = value;
                                                      });
                                                    },
                                                    value: doctor3_uid == null
                                                        ? widget.map['3']
                                                        : doctor3_uid,
                                                  ),
                                                ),
                                              );
                                            }
                                          }, // end of builder
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'طبيب أسرة',
                                        style: ksubBoldLabelTextStyle,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('/Doctors')
                                              .where('hospital-uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance.currentUser.uid)
                                              .where('speciality',
                                                  isEqualTo: 'طبيب أسرة')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text('has no data');
                                            } else {
                                              List<DropdownMenuItem>
                                                  hospitalsNames = [];
                                              var documents =
                                                  snapshot.data.docs;
                                              for (var document in documents) {
                                                hospitalsNames.add(
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      document.data()[
                                                                  'doctor-name'] ==
                                                              null
                                                          ? ''
                                                          : document.data()[
                                                              'doctor-name'],
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 15),
                                                    ),
                                                    value: '${document.id}',
                                                  ),
                                                );
                                              }
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 10.0, 0),
                                                margin: EdgeInsets.only(
                                                    right: 18, left: 50),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor: kLightColor,
                                                    style: kDropDownHintStyle,
                                                    hint: Text(
                                                      'فضلا اختر طبيبا',
                                                      style:
                                                          GoogleFonts.almarai(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    items: hospitalsNames,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        doctor4_uid = value;
                                                      });
                                                    },
                                                    value: doctor4_uid == null
                                                        ? widget.map['4']
                                                        : doctor4_uid,
                                                  ),
                                                ),
                                              );
                                            }
                                          }, // end of builder
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
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kGreyColor,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ListTile(
                            title: Text(
                              'تعيين الصيدلي ',
                              textAlign: TextAlign.center,
                              style: kBoldLabelTextStyle,
                            ),
                          ),
                          Divider(
                            color: klighterColor,
                            thickness: 0.9,
                            endIndent: 20,
                            indent: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'صيدلي',
                                        style: ksubBoldLabelTextStyle,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('/Pharmacist')
                                              .where('hospital-uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance.currentUser.uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text('has no data');
                                            } else {
                                              List<DropdownMenuItem>
                                                  hospitalsNames = [];
                                              var documents =
                                                  snapshot.data.docs;
                                              for (var document in documents) {
                                                hospitalsNames.add(
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      document
                                                                  .data()[
                                                                      'pharmacist-name']
                                                                  .toString() ==
                                                              null
                                                          ? ''
                                                          : document
                                                              .data()[
                                                                  'pharmacist-name']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 15),
                                                    ),
                                                    value: '${document.id}',
                                                  ),
                                                );
                                              }
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 10.0, 0),
                                                margin: EdgeInsets.only(
                                                    right: 50, left: 50),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor: kLightColor,
                                                    style: kDropDownHintStyle,
                                                    hint: Text(
                                                      'فضلا اختر صيدليا',
                                                      style:
                                                          GoogleFonts.almarai(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    items: hospitalsNames,
                                                    onChanged: (value) {
                                                      pharmacist_uid = value;

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              '/Patient')
                                                          .doc(
                                                              widget.patient_id)
                                                          .update(
                                                        {
                                                          'pharmacist-uid':
                                                              pharmacist_uid,
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          }, // end of builder
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 20.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          textColor: Colors.white54,
                          color: kGreyColor,
                          child: Text(
                            '     حفظ     ',
                            style: TextStyle(
                              color: Colors.white,
                              // fontFamily: 'Montserrat',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          onPressed: () async {
                            // if (_key.currentState
                            //     .validate()) {
                            //   _key.currentState.save();
                            await FirebaseFirestore.instance
                                .collection('/Patient')
                                .doc(widget.patient_id)
                                .update(
                              {
                                'doctors_map': {
                                  '1': doctor1_uid == null
                                      ? widget.map['1']
                                      : doctor1_uid,
                                  '2': doctor2_uid == null
                                      ? widget.map['2']
                                      : doctor2_uid,
                                  '3': doctor3_uid == null
                                      ? widget.map['3']
                                      : doctor3_uid,
                                  '4': doctor4_uid == null
                                      ? widget.map['4']
                                      : doctor4_uid,
                                },
                              },
                            );

                            // Flushbar(
                            //   backgroundColor:
                            //   Colors.white,
                            //   borderRadius: 4.0,
                            //   margin: EdgeInsets.all(8.0),
                            //   duration:
                            //   Duration(seconds: 4),
                            //   messageText: Text(
                            //     ' تم إضافة وصفة جديدة لهذا المريض',
                            //     style: TextStyle(
                            //       color: kBlueColor,
                            //       fontFamily: 'Almarai',
                            //     ),
                            //     textAlign:
                            //     TextAlign.center,
                            //   ),
                            // )..show(context).then((r) =>
                            //     Navigator.pop(context));
                            // } else {
                            //   // there is an error
                            //   setState(() {
                            //     autovalidateMode =
                            //         AutovalidateMode.always;
                            //   });
                            // }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
