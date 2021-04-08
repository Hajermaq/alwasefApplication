import 'package:alwasef_app/Screens/all_admin_screen/admin_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/profile_pages.dart';
import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      try {
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
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                    'لم يتم العثور على مستخدم لهذا البريد الإلكتروني.',
                                    style: TextStyle(color: kBlueColor)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      "حسنا",
                                      style: TextStyle(color: kBlueColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (e.code == 'wrong-password') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                    'كلمة المرور خاطئة. أعد المحاولة، أو انقر على "نسيت كلمة المرور" لإعادة ضبطها. ',
                                    style: TextStyle(color: kBlueColor)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      "حسنا",
                                      style: TextStyle(color: kBlueColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (e.code == 'too-many-requests') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                    'يوجد محاولات كثيرة لتسجيل الدخول بهذا المستخدم، حاول مرة اخرى لاحقا.',
                                    style: TextStyle(color: kBlueColor)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      "حسنا",
                                      style: TextStyle(color: kBlueColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text('حدث خطأ غير محدد.',
                                    style: TextStyle(color: kBlueColor)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      "حسنا",
                                      style: TextStyle(color: kBlueColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(
                            currentEmail: email,
                          ),
                        ),
                      );
                    },
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

Future<void> resetPassword(String email, String collectionName,
    BuildContext context, String currentemail) async {
  if (email == currentemail) {
    await auth.sendPasswordResetEmail(email: email);
  } else {
    print('no');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('البريد الإلكتروني المدخل لا يطابق بريدك الإلكتروني.',
              style: TextStyle(color: kBlueColor)),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "حسنا",
                style: TextStyle(color: kBlueColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({this.collectionName, this.currentEmail});
  final String collectionName;
  final currentEmail;
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  GlobalKey<FormState> _key2 = GlobalKey();
  String writtenEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
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
          'تغيير كلمة المرور',
          style: GoogleFonts.almarai(
            color: kGreyColor,
            fontSize: 28.0,
          ),
        ),
      ),
      backgroundColor: kLightColor,
      body: SingleChildScrollView(
        child: Builder(builder: (BuildContext context) {
          return Form(
            key: _key2,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                ),
                Text(
                  'أعد إدخال البريد الإلكتروني الخاصة بك للمتابعة',
                  style: TextStyle(color: kBlueColor, fontSize: 16.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 50.0,
                    right: 50.0,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: Validation().validateEmailReset,
                    onSaved: (value) {
                      writtenEmail = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'البريد الإلكتروني',
                      fillColor: kGreyColor,
                      filled: true,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kRedColor,
                          width: 3.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (_key2.currentState.validate()) {
                          //there is no error
                          _key2.currentState.save();
                          resetPassword(writtenEmail, widget.collectionName,
                                  context, widget.currentEmail)
                              .then((value) => Navigator.pop(context));
                          _key2.currentState.save();
                        } else {
                          setState(() {
                            autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      },
                      color: kBlueColor,
                      child: Text(
                        'تحديث',
                        style: TextStyle(
                          color: Colors.white,
                          // fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
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
