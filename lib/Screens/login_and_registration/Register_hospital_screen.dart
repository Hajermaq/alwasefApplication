import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/Screens/login_and_registration/verify_email.dart';
import 'package:alwasef_app/components/round-button.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:alwasef_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterHospitalScreen extends StatefulWidget {
  static const String id = 'register_hospital_screen';
  @override
  _RegisterHospitalScreenState createState() => _RegisterHospitalScreenState();
}

class _RegisterHospitalScreenState extends State<RegisterHospitalScreen> {
  //Firebase
  FirebaseAuth auth = FirebaseAuth.instance;
  //Variables
  String password;
  String reEnterPassword;
  String email;
  String hospitalname;
  String role = 'موظف استقبال';
  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

//Functions
  // register new user
  Future<void> createUser() async {
    try {
      final authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult != null) {
        await authResult.user.sendEmailVerification();
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyPage(
            email: email,
            password: password,
            name: hospitalname,
            role: role,
          ),
        ),
      );
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
                ' البريد الإلكتروني المدخل قيد الاستخدام من قبل حساب آخر.',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _key,
          autovalidateMode: autovalidateMode,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0, bottom: 40),
                    child: Text(
                      'أنشئ حسابـا لمستشفى',
                      textAlign: TextAlign.center,
                      style: kRegisterUsersHeadlineStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                RoundTextFields(
                  validator: Validation().validateName,
                  isObscure: false,
                  color: kButtonColor,
                  hintMessage: 'اسم المستشفى',
                  onSaved: (value) {
                    hospitalname = value;
                  },
                  textInputType: TextInputType.name,
                ),
                SizedBox(
                  height: 20.0,
                ),
                RoundTextFields(
                  validator: Validation().validateEmail,
                  isObscure: false,
                  color: kButtonColor,
                  hintMessage: 'البريد الإلكتروني',
                  onSaved: (value) {
                    email = value;
                  },
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 20.0,
                ),
                RoundTextFields(
                    validator: Validation().validatePassword,
                    isObscure: true,
                    color: kButtonColor,
                    hintMessage: 'كلمة المرور',
                    onSaved: (value) {
                      password = value;
                    },
                    onChanged: (value) {
                      reEnterPassword = value;
                    }),
                SizedBox(
                  height: 20.0,
                ),
                RoundTextFields(
                  validator: (value) => value != reEnterPassword
                      ? '\u26A0 كلمة المرور غير متطابقة  '
                      : null,
                  isObscure: true,
                  color: kButtonColor,
                  hintMessage: 'أعد إدخال كلمة المرور',
                  // onSaved: (value) {
                  //   password = value;
                  // },
                  textInputType: TextInputType.text,
                  //hiddenPass: true,
                ),
                SizedBox(
                  height: 88.0,
                ),
                RoundRaisedButton(
                    text: 'سجل',
                    onPressed: () async {
                      if (_key.currentState.validate()) {
                        //there is no error
                        _key.currentState.save();
                        createUser();
                      } else {
                        // there is an error
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    }),
                Container(
                  // TODO write this code
                  padding: EdgeInsets.only(top: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'تسجيل الدخول',
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
