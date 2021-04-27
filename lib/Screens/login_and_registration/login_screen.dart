import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/Screens/services/profile_changes.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flushbar/flushbar.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:alwasef_app/components/round-button.dart';
import 'loading_screen.dart';

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
  Widget okButton;
  String hUID = '';
  String email;
  String password;
  String role;
  bool lodaing = false;
  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    setState(() {
      lodaing = false;
    });
  } //Functions

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  height: 200.0,
                  width: 200.0,
                  child: SvgPicture.asset(
                    'assets/images/password.svg',
                    color: kSVGcolor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'مرحبا !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        ' سجل دخولك باستخدام \nالبريد الإلكتروني وكلمة المرور.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.0,
                ),
                RoundTextFields(
                  validator: Validation().validateEmail,
                  isObscure: false,
                  color: kButtonColor,
                  hintMessage: 'البريد الإلكتروني',
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
                SizedBox(
                  height: 48.0,
                ),
                lodaing ? CircularProgressIndicator() : Text(''),
                RoundRaisedButton(
                  text: ' اذهب',
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
                                setState(() {
                                  lodaing = true;
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoadingScreen(
                                            role: element.data()['role'],
                                            password: password,
                                            email: email,
                                          )),
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
                                      builder: (context) => LoadingScreen(
                                            role: element.data()['role'],
                                            password: password,
                                            email: email,
                                          )),
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
                                      builder: (context) => LoadingScreen(
                                            role: element.data()['role'],
                                            password: password,
                                            email: email,
                                          )),
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
                                      builder: (context) => LoadingScreen(
                                            role: element.data()['role'],
                                            password: password,
                                            email: email,
                                          )),
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
                              okButton = FlatButton(
                                child: Text('حسنا'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                              return AlertDialog(
                                title: Text(
                                    'لم يتم العثور على مستخدم لهذا البريد الإلكتروني.',
                                    style: TextStyle(
                                      color: kBlueColor,
                                      fontFamily: 'Almarai',
                                    ),
                                    textAlign: TextAlign.center),
                                titleTextStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                actions: [
                                  okButton,
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                elevation: 24.0,
                              );
                            },
                          );
                        } else if (e.code == 'wrong-password') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              okButton = FlatButton(
                                child: Text('حسنا'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                              return AlertDialog(
                                title: Text(
                                  'كلمة المرور خاطئة. أعد المحاولة، أو انقر على "لاأتذكر كلمة المرور" لإعادة ضبطها. ',
                                  style: TextStyle(
                                    color: kBlueColor,
                                    fontFamily: 'Almarai',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                titleTextStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                actions: [
                                  okButton,
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                elevation: 24.0,
                              );
                            },
                          );
                        } else if (e.code == 'too-many-requests') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              okButton = FlatButton(
                                child: Text('حسنا'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                              return AlertDialog(
                                title: Text(
                                    'يوجد محاولات كثيرة لتسجيل الدخول بهذا المستخدم، حاول مرة اخرى لاحقا.',
                                    style: TextStyle(
                                      color: kBlueColor,
                                      fontFamily: 'Almarai',
                                    ),
                                    textAlign: TextAlign.center),
                                titleTextStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                actions: [
                                  okButton,
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                elevation: 24.0,
                              );
                            },
                          );
                        } else {
                          print(e);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              okButton = FlatButton(
                                child: Text('حسنا'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                              return AlertDialog(
                                title: Text('حدث خطأ غير محدد.',
                                    style: TextStyle(
                                      color: kBlueColor,
                                      fontFamily: 'Almarai',
                                    ),
                                    textAlign: TextAlign.center),
                                titleTextStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                actions: [
                                  okButton,
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                elevation: 24.0,
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
                SizedBox(
                  height: 20.0,
                ),
                Container(
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
                      'لا أتذكر كلمة المرور؟',
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

  Future<bool> DoctorLogIn(String collectionName, String emailFromDB,
      String password, String email) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection('/$collectionName')
          .where('email', isEqualTo: value.user.email)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if ('موظف استقبال' == element.data()['role']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoadingScreen(
                        role: element.data()['role'],
                        password: password,
                        email: email,
                      )),
            );
          }
        });
      });
    });
  }
}

Future<void> resetPassword(String email, String collectionName,
    BuildContext context, String currentemail) async {
  if (email == currentemail) {
    await auth.sendPasswordResetEmail(email: email);
    Flushbar(
      backgroundColor: Colors.white,
      borderRadius: 4.0,
      margin: EdgeInsets.all(8.0),
      duration: Duration(seconds: 4),
      messageText: Text(
        ' تم إرسال رسالة تغيير كلمة المرور لبريدك الإلكتروني.',
        style: TextStyle(
          color: kBlueColor,
          fontFamily: 'Almarai',
        ),
        textAlign: TextAlign.center,
      ),
    )..show(context).then((r) => Navigator.pop(context));
  } else {
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
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white54,
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
      backgroundColor: kBlueColor,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Column(
                    children: [
                      Text(
                        'فضلا!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 25.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'أعد إدخال البريد الإلكتروني الخاصة بك للمتابعة.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                RoundTextFields(
                  validator: Validation().validateEmailReset,
                  textInputType: TextInputType.name,
                  isObscure: false,
                  color: kButtonColor,
                  hintMessage: 'البريد الإلكتروني',
                  onSaved: (value) {
                    writtenEmail = value;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                RoundRaisedButton(
                  text: 'حفظ',
                  onPressed: () async {
                    if (_key2.currentState.validate()) {
                      //there is no error
                      _key2.currentState.save();
                      resetPassword(writtenEmail, widget.collectionName,
                          context, widget.currentEmail);
                    } else {
                      // there is an error
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
