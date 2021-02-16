import 'dart:developer';

import 'package:alwasef_app/Screens/doctors_mainpage.dart';
import 'package:alwasef_app/Screens/patients_mainpage.dart';
import 'package:alwasef_app/Screens/pharamacists_mainpage.dart';
import 'package:alwasef_app/Screens/reset_password_screen.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  String email;
  String password;
  String role;
  String selectedRadio;
  String dbDoctorRole;
  String dbPatientRole;
  String dbPharmacistRole;
  String dbHospitalRole;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserManagement().getDoctor(role).then((QuerySnapshot documents) {
      if (documents.docs.isNotEmpty) {
        for (int i = 0; i < documents.docs.length; i++) {
          dbDoctorRole = documents.docs[i].get('role');
        }
      }
    });
    UserManagement().getPatient(role).then((QuerySnapshot documents) {
      if (documents.docs.isNotEmpty) {
        for (int i = 0; i < documents.docs.length; i++) {
          dbPatientRole = documents.docs[i].get('role');
        }
      }
    });
    UserManagement().getPharmacist(role).then((QuerySnapshot documents) {
      if (documents.docs.isNotEmpty) {
        for (int i = 0; i < documents.docs.length; i++) {
          dbPharmacistRole = documents.docs[i].get('role');
        }
      }
    });
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            height: 200.0,
            width: 200.0,
            child: SvgPicture.asset(
              'assets/images/password.svg',
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا  ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontFamily: 'Segoe UI',
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 50, left: 50),
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(0xffabd1c6),
                width: 3.0,
              ),
            ),
            child: TextField(
              onChanged: (selectedEmail) {
                email = selectedEmail;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'إيميل',
                hintStyle: kTextFieldHintStyle,
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 50, left: 50),
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(0xffabd1c6),
                width: 3.0,
              ),
            ),
            child: TextField(
              onChanged: (selectedPassword) {
                password = selectedPassword;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                hintStyle: TextStyle(
                  color: kLightColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: ListTile(
                    title: Text('طبيب'),
                    trailing: Radio(
                      value: 'طبيب',
                      groupValue: role,
                      onChanged: (selectedRole) {
                        setState(() {
                          role = selectedRole;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text('صيدلي'),
                    trailing: Radio(
                      value: 'صيدلي',
                      groupValue: role,
                      onChanged: (selectedRole) {
                        setState(() {
                          role = selectedRole;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text('مريض'),
                    trailing: Radio(
                      value: 'مريض',
                      groupValue: role,
                      onChanged: (selectedRole) {
                        setState(() {
                          role = selectedRole;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 120.0),
            child: RaisedButton(
              child: Text(
                'إذهب',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () async {
                // Doctor
                if (dbDoctorRole == role) {
                  await auth
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((value) {
                    Navigator.pushNamed(context, DoctorMainPage.id);
                  }).catchError((e) {
                    print(e);
                  });
                  //patient
                } else if (dbPatientRole == role) {
                  await auth
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((value) {
                    Navigator.pushNamed(context, PatientMainPage.id);
                  }).catchError((e) {
                    print(e);
                  });
                }
                //pharamacist
                else {
                  await auth
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((value) {
                    Navigator.pushNamed(context, PharmacistMainPage.id);
                  }).catchError((e) {
                    print(e);
                  });
                }
              },
              color: Color(0xffabd1c6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {},
              child: Text(
                'هل نسيت كلمة المرور؟',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
