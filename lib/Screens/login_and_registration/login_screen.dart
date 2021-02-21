import 'file:///C:/Users/hajer/AndroidStudioProjects/alwasef_app/lib/Screens/all_patient_screen/patients_mainpage.dart';
import 'file:///C:/Users/hajer/AndroidStudioProjects/alwasef_app/lib/Screens/all_pharmacist_screens/pharamacists_mainpage.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:alwasef_app/components/round-button.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  //FireStore
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  //Variables
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
              color: kSVGcolor,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا  ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          RoundTextFields(
            color: kButtonColor,
            hintMessage: 'ايميل',
            onChanged: (value) {
              email = value;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundTextFields(
            color: kButtonColor,
            hintMessage: 'كلمة المرور',
            onChanged: (value) {
              password = value;
            },
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'مريض',
                  groupValue: role,
                  onChanged: (selectedRole) {
                    setState(() {
                      role = selectedRole;
                    });
                  },
                ),
                Text(
                  'مريض',
                ),
                Radio(
                  value: 'طبيب',
                  groupValue: role,
                  onChanged: (selectedRole) {
                    setState(() {
                      role = selectedRole;
                    });
                  },
                ),
                Text('طبيب'),
                Radio(
                  value: 'صيدلي',
                  groupValue: role,
                  onChanged: (selectedRole) {
                    setState(() {
                      role = selectedRole;
                    });
                  },
                ),
                Text('صيدلي'),
                // Flexible(
                //   child: ListTile(
                //     title: Text('طبيب'),
                //     trailing: Radio(
                //       value: 'طبيب',
                //       groupValue: role,
                //       onChanged: (selectedRole) {
                //         setState(() {
                //           role = selectedRole;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                // Flexible(
                //   child: ListTile(
                //     title: Text('صيدلي'),
                //     trailing: Radio(
                //       value: 'صيدلي',
                //       groupValue: role,
                //       onChanged: (selectedRole) {
                //         setState(() {
                //           role = selectedRole;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                // Flexible(
                //   child: ListTile(
                //     title: Text('مريض'),
                //     trailing: Radio(
                //       value: 'مريض',
                //       groupValue: role,
                //       onChanged: (selectedRole) {
                //         setState(() {
                //           role = selectedRole;
                //         });
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          RoundRaisedButton(
              text: ' إذهب',
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
              }),
          Container(
            // TODO write this code
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
