import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:alwasef_app/components/round-button.dart';

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
  String email;
  String hospitalname;
//Functions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'سجل مستشفى جديدة',
              textAlign: TextAlign.center,
              style: kRegisterHospitalHeadlineStyle,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          RoundTextFields(
            isObscure: false,
            color: kButtonColor,
            hintMessage: 'اسم المستشفى',
            onChanged: (value) {
              hospitalname = value;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundTextFields(
            isObscure: false,
            color: kButtonColor,
            hintMessage: 'البريد الإلكتروني',
            onChanged: (value) {
              email = value;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundTextFields(
            isObscure: true,
            color: kButtonColor,
            hintMessage: 'كلمة المرور',
            onChanged: (value) {
              password = value;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundRaisedButton(
              text: 'سجل',
              onPressed: () async {
//create new user
                await auth
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) {
                  UserManagement()
                      .newHospitalSetUp(context, password, hospitalname);
                }).catchError((e) {
                  print(e);
                });
              }),
        ],
      ),
    );
  }
}
