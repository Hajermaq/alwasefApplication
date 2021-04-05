import 'package:alwasef_app/Screens/all_admin_screen/admin_page.dart';
import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import '../all_patient_screen/patients_mainpage.dart';
import '../all_pharmacist_screens/pharamacists_mainpage.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
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
  String hUID = '';
  String email;
  String password;
  String role;

  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            autovalidateMode: autovalidateMode,
            child: Column(
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
                  validator: Validation().validateEmail,
                  isObscure: false,
                  color: kButtonColor,
                  hintMessage: 'ايميل',
                  // onSaved: (value) {
                  //   email = value;
                  // },
                  onChanged: (value) {
                    email = value;
                  },
                  textInputType: TextInputType.emailAddress,
                  //hiddenPass: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                RoundTextFields(
                  validator: Validation().validatePasswordLogin,
                  isObscure: true,
                  color: kButtonColor,
                  hintMessage: 'كلمة المرور',
                  // onSaved: (value) {
                  //   password = value;
                  // },
                  onChanged: (value) {
                    password = value;
                  },
                  textInputType: TextInputType.text,
                  //hiddenPass: true,
                ),
                RoundRaisedButton(
                  text: ' إذهب',
                  onPressed: () async {
                    if (_key.currentState.validate()) {
                      //there is no error
                      _key.currentState.save();
                      // Doctor
                      await auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('/Doctors')
                            .where('email', isEqualTo: value.user.email)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            if ('طبيب' == element.data()['role']) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DoctorMainPage(),
                                ),
                              );
                            }
                          });
                        });
                      });
                      //patient
                      await auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('/Patient')
                            .where('email', isEqualTo: value.user.email)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            if ('مريض' == element.data()['role']) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PatientMainPage(),
                                ),
                              );
                            }
                          });
                        });
                      });
                      //pharamacist
                      await auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('/Pharmacist')
                            .where('email', isEqualTo: value.user.email)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            if ('صيدلي' == element.data()['role']) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PharmacistMainPage(),
                                ),
                              );
                            }
                          });
                        });
                      });
                      //Hospital
                      await auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('/Hospital')
                            .where('email', isEqualTo: value.user.email)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            if ('موظف استقبال' == element.data()['role']) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AdminScreen(),
                                ),
                              );
                            }
                          });
                        });
                      });
                    } else {
                      // there is an error
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                ),
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
          ),
        ),
      ),
    );
  }
}
