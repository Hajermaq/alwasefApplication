import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class DoctorManagement extends StatefulWidget {
  DoctorManagement({this.doctor_id});
  final String doctor_id;

  @override
  _DoctorManagementState createState() => _DoctorManagementState();
}

class _DoctorManagementState extends State<DoctorManagement> {
  String experience;

  String _selectedSpeciality;
  String _selectedExperience;

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser.uid);
    print(widget.doctor_id);
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
            'صفحة الطبيب ',
            style: GoogleFonts.almarai(
              color: kBlueColor,
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
                                      .where('hospital-uid',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser.uid)
                                      .where('speciality', isEqualTo: 'general')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('has no data');
                                    } else {
                                     snapshot.data.docs.forEach((element) {
                                       element.data()['speciality'];

                                     });
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
                                            value: snapshot.data,
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

                                                  print(speciality);

                                                  FirebaseFirestore.instance
                                                      .collection('/Doctors')
                                                      .doc(widget.doctor_id)
                                                      .update(
                                                    {
                                                      'speciality': speciality,
                                                    },
                                                  );
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
                                      .where('hospital-uid',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser.uid)
                                      .where('speciality', isEqualTo: 'general')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('has no data');
                                    } else {
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
                                            value: _selectedExperience,
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

                                                  FirebaseFirestore.instance
                                                      .collection('/Doctors')
                                                      .doc(widget.doctor_id)
                                                      .update(
                                                    {
                                                      'experience-years':
                                                          experience,
                                                    },
                                                  );
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
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15.0),
            //   ),
            //   color: kGreyColor,
            //   margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       ListTile(
            //         title: Text(
            //           'تعيين الصيدلي ',
            //           textAlign: TextAlign.center,
            //           style: kBoldLabelTextStyle,
            //         ),
            //       ),
            //       Divider(
            //         color: klighterColor,
            //         thickness: 0.9,
            //         endIndent: 20,
            //         indent: 20,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: Container(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               Row(
            //                 children: [
            //                   Text(
            //                     'طبيب عام',
            //                     style: ksubBoldLabelTextStyle,
            //                   ),
            //                   SizedBox(
            //                     width: 15.0,
            //                   ),
            //                   Expanded(
            //                     child: StreamBuilder<QuerySnapshot>(
            //                       stream: FirebaseFirestore.instance
            //                           .collection('/Pharmacist')
            //                           .where('hospital-uid',
            //                               isEqualTo: FirebaseAuth
            //                                   .instance.currentUser.uid)
            //                           .snapshots(),
            //                       builder: (context, snapshot) {
            //                         if (!snapshot.hasData) {
            //                           return Text('has no data');
            //                         } else {
            //                           List<DropdownMenuItem> hospitalsNames =
            //                               [];
            //                           var documents = snapshot.data.docs;
            //                           for (var document in documents) {
            //                             hospitalsNames.add(
            //                               DropdownMenuItem(
            //                                 child: Text(
            //                                   document
            //                                       .data()['Pharmacist-name']
            //                                       .toString(),
            //                                   style: TextStyle(
            //                                       color: Colors.black54),
            //                                 ),
            //                                 value: '${document.id}',
            //                               ),
            //                             );
            //                           }
            //                           return Container(
            //                             padding:
            //                                 EdgeInsets.fromLTRB(0, 0, 10.0, 0),
            //                             margin: EdgeInsets.only(
            //                                 right: 50, left: 50),
            //                             height: 50.0,
            //                             // decoration: BoxDecoration(
            //                             //   border: Border.all(
            //                             //     color: kButtonColor,
            //                             //     style: BorderStyle.solid,
            //                             //     width: 4.0,
            //                             //   ),
            //                             //   color: Colors.transparent,
            //                             //   borderRadius:
            //                             //       BorderRadius.circular(30.0),
            //                             // ),
            //                             child: DropdownButtonHideUnderline(
            //                               child: DropdownButton(
            //                                 isExpanded: true,
            //                                 dropdownColor: kLightColor,
            //                                 style: kDropDownHintStyle,
            //                                 hint: Text(
            //                                   'فضلا اختر طبيب',
            //                                   style: GoogleFonts.almarai(
            //                                     color: Colors.black54,
            //                                   ),
            //                                 ),
            //                                 items: hospitalsNames,
            //                                 onChanged: (value) {
            //                                   pharmacist_uid = value;
            //
            //                                   FirebaseFirestore.instance
            //                                       .collection('/Patient')
            //                                       .doc(widget.doctor_id)
            //                                       .update(
            //                                     {
            //                                       'pharmacist-uid':
            //                                           pharmacist_uid,
            //                                     },
            //                                   );
            //                                 },
            //                               ),
            //                             ),
            //                           );
            //                         }
            //                       }, // end of builder
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
