import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class PharmacistManagement extends StatefulWidget {
  PharmacistManagement({this.pharmacist_id, this.speciality});
  final String pharmacist_id;
  final String speciality;
  @override
  _PharmacistManagementState createState() => _PharmacistManagementState();
}

class _PharmacistManagementState extends State<PharmacistManagement> {
  String _selectedSpeciality;

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
            'صفحة الصيدلي ',
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
                                'المسمى \nالوظيفي',
                                style: ksubBoldLabelTextStyle,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('/Pharmacist')
                                      .where('uid',
                                          isEqualTo: widget.pharmacist_id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('has no data');
                                    } else {
                                      var doc = snapshot.data;
                                      String speciality =
                                          doc.docs[0].data()['speciality'];
                                      print(speciality);
                                      List<String> specialities = [
                                        'صيدلي',
                                        'صيدلي إكلينيكي',
                                        'صيدلي استشاري',
                                      ];
                                      return Container(
                                        // padding:
                                        //     EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                        margin: EdgeInsets.only(
                                            right: 30, left: 10),

                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedSpeciality == null
                                                ? speciality
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

                                                  print(speciality);
                                                  print(widget.pharmacist_id);
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
                        .collection('/Pharmacist')
                        .doc(widget.pharmacist_id)
                        .set(
                      {
                        'speciality': _selectedSpeciality == null
                            ? widget.speciality
                            : _selectedSpeciality,
                      },
                      SetOptions(merge: true),
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
