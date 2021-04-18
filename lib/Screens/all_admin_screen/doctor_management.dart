import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class DoctorManagement extends StatefulWidget {
  DoctorManagement({this.doctor_id, this.experienceYears, this.speciality});
  final String doctor_id;
  final String experienceYears;
  final String speciality;

  @override
  _DoctorManagementState createState() => _DoctorManagementState();
}

class _DoctorManagementState extends State<DoctorManagement> {
  String _selectedSpeciality;
  String _selectedExperience;

  @override
  Widget build(BuildContext context) {
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
            'صفحة الطبيب ',
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
              height: 50,
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
                      'تعيين مجال الإختصاص ',
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
                                'التخصص',
                                style: ksubBoldLabelTextStyle,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('/Doctors')
                                      .where('uid', isEqualTo: widget.doctor_id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('has no data');
                                    } else {
                                      var doc = snapshot.data;
                                      String heart =
                                          doc.docs[0].data()['speciality'];
                                      List<String> specialities = [
                                        'طبيب قلب',
                                        'طبيب نفسي',
                                        'طبيب أسرة',
                                        'طبيب باطنية'
                                      ];
                                      return Container(
                                        // padding:
                                        //     EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 30, left: 10),

                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedSpeciality == null
                                                ? heart
                                                : _selectedSpeciality,
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر مجال اختصاص',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items:
                                                specialities.map((speciality) {
                                              return DropdownMenuItem(
                                                child: new Text(
                                                  speciality,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 17),
                                                ),
                                                value: speciality,
                                                onTap: () {
                                                  speciality = speciality;
                                                },
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedSpeciality = newValue;
                                              });
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
                                'سنين الخبرة',
                                style: ksubBoldLabelTextStyle,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('/Doctors')
                                      .where('uid', isEqualTo: widget.doctor_id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('has no data');
                                    } else {
                                      var doc = snapshot.data;
                                      String experience = doc.docs[0]
                                          .data()['experience-years'];
                                      List<String> experienceYears = [
                                        'أقل من 5 سنوات خبرة (متخصص)',
                                        'أكثر من 5 سنوات خبرة (مستشار)',
                                      ];
                                      return Container(
                                        // padding:
                                        //     EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        margin: EdgeInsets.only(
                                            right: 10, left: 10),

                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedExperience == null
                                                ? experience
                                                : _selectedExperience,
                                            isExpanded: true,
                                            dropdownColor: kLightColor,
                                            style: kDropDownHintStyle,
                                            hint: Text(
                                              'فضلا اختر سنين الخبرة',
                                              style: GoogleFonts.almarai(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            items:
                                                experienceYears.map((option) {
                                              return DropdownMenuItem(
                                                child: new Text(
                                                  option,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 15),
                                                ),
                                                value: option,
                                                onTap: () {
                                                  experience = option;
                                                },
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedExperience = newValue;
                                              });
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
              padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
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
                    FirebaseFirestore.instance
                        .collection('/Doctors')
                        .doc(widget.doctor_id)
                        .update(
                      {
                        'speciality': _selectedSpeciality == null
                            ? widget.speciality
                            : _selectedSpeciality,
                      },
                    );
                    FirebaseFirestore.instance
                        .collection('/Doctors')
                        .doc(widget.doctor_id)
                        .update(
                      {
                        'experience-years': _selectedExperience == null
                            ? widget.experienceYears
                            : _selectedExperience,
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
      ),
    );
  }
}
