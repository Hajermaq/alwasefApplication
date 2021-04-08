import 'package:alwasef_app/Screens/all_admin_screen/patient_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';

import '../../constants.dart';
import 'doctor_management.dart';

class HospitalDoctors extends StatefulWidget {
  static const String id = 'hospital_doctors_screen';
  @override
  _HospitalDoctorsState createState() => _HospitalDoctorsState();
}

class _HospitalDoctorsState extends State<HospitalDoctors> {
  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FilledRoundTextFields(
                fillColor: kGreyColor,
                color: kScaffoldBackGroundColor,
                hintMessage: 'ابحث',
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                }),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('/Doctors')
                        .where('hospital-uid',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document =
                                snapshot.data.docs[index];
                            String name = document.data()['doctor-name'];
                            if (name
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                name
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase())) {
                              return Container(
                                color: kGreyColor,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        '${document.data()['doctor-name']}',
                                        // textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 20.0),
                                      ),
                                      subtitle: Text(
                                        '${document.data()['email']}',
                                        // textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 20.0),
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_left),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorManagement(
                                              doctor_id: document.data()['uid'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTileDivider(
                                      color: kLightColor,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox();
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
