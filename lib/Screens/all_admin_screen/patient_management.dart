import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class PatientManagement extends StatefulWidget {
  PatientManagement({this.patient_id});
  final String patient_id;

  @override
  _PatientManagementState createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  String doctor1_uid;
  String doctor2_uid;
  String doctor3_uid;
  String doctor4_uid;
  String pharmacist_uid;
  String speciality;
  var _selectedName;
  List<String> doctors = [];
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
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser.uid);
    print(widget.patient_id);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kLightColor,
        appBar: AppBar(
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
              color: kGreyColor,
              fontSize: 28.0,
            ),
          ),
        ),
        body: Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      List<DropdownMenuItem> hospitalsNames =
                                          [];
                                      var documents = snapshot.data.docs;
                                      var documentt = '';
                                      for (var document in documents) {
                                        hospitalsNames.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              document.data()['doctor-name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                            ),
                                            value: '${document.id}',
                                          ),
                                        );
                                      }
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 20, left: 50),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر طبيب',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items: hospitalsNames,
                                            onTap: () {},
                                            onChanged: (value) async {
                                              doctors.clear();
                                              doctor1_uid = value;
                                              setState(() {
                                                _selectedName = value;
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection('/Doctors')
                                                  .doc(doctor1_uid)
                                                  .get()
                                                  .then((doc) {
                                                documentt = doc
                                                    .data()['doctor-name']
                                                    .toString();
                                              });
                                              doctors.add(doctor1_uid);
                                              FirebaseFirestore.instance
                                                  .collection('/Patient')
                                                  .doc(widget.patient_id)
                                                  .update(
                                                {
                                                  'doctors': doctors,
                                                },
                                              );
                                            },
                                            value: _selectedName == ''
                                                ? documentt
                                                : _selectedName,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      List<DropdownMenuItem> hospitalsNames =
                                          [];
                                      var documents = snapshot.data.docs;
                                      for (var document in documents) {
                                        hospitalsNames.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              document.data()['doctor-name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                            ),
                                            value: '${document.id}',
                                          ),
                                        );
                                      }
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 10, left: 50),

                                        // ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر طبيب',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items: hospitalsNames,
                                            onChanged: (value) {
                                              doctor2_uid = value;
                                              doctors.add(doctor2_uid);
                                              FirebaseFirestore.instance
                                                  .collection('/Patient')
                                                  .doc(widget.patient_id)
                                                  .update(
                                                {
                                                  'doctors': doctors,
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
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      .where('speciality',
                                          isEqualTo: 'طبيب نفسي')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('has no data');
                                    } else {
                                      List<DropdownMenuItem> hospitalsNames =
                                          [];
                                      var documents = snapshot.data.docs;
                                      for (var document in documents) {
                                        hospitalsNames.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              document.data()['doctor-name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                            ),
                                            value: '${document.id}',
                                          ),
                                        );
                                      }
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 10, left: 50),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر طبيب',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items: hospitalsNames,
                                            onChanged: (value) {
                                              doctor3_uid = value;
                                              doctors.add(doctor3_uid);
                                              FirebaseFirestore.instance
                                                  .collection('/Patient')
                                                  .doc(widget.patient_id)
                                                  .update(
                                                {
                                                  'doctors': doctors,
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
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      List<DropdownMenuItem> hospitalsNames =
                                          [];
                                      var documents = snapshot.data.docs;
                                      for (var document in documents) {
                                        hospitalsNames.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              document.data()['doctor-name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                            ),
                                            value: '${document.id}',
                                          ),
                                        );
                                      }
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 18, left: 50),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            // value: ,
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر طبيب',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items: hospitalsNames,
                                            onChanged: (value) {
                                              doctor4_uid = value;
                                              doctors.add(doctor4_uid);

                                              FirebaseFirestore.instance
                                                  .collection('/Patient')
                                                  .doc(widget.patient_id)
                                                  .update(
                                                {
                                                  'doctors': doctors,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      List<DropdownMenuItem> hospitalsNames =
                                          [];
                                      var documents = snapshot.data.docs;
                                      for (var document in documents) {
                                        hospitalsNames.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              document
                                                  .data()['pharmacist-name']
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
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 50, left: 50),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر صيدلي',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items: hospitalsNames,
                                            onChanged: (value) {
                                              pharmacist_uid = value;

                                              FirebaseFirestore.instance
                                                  .collection('/Patient')
                                                  .doc(widget.patient_id)
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
          ],
        ),
      ),
    );
  }
}
