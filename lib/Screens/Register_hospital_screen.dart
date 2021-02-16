import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'services/user_management.dart';

class RegisterHospitalScreen extends StatefulWidget {
  static const String id = 'register_hospital_screen';
  @override
  _RegisterHospitalScreenState createState() => _RegisterHospitalScreenState();
}

class _RegisterHospitalScreenState extends State<RegisterHospitalScreen> {
  String password;
  String email;
  String hospitalname;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Container(
          //   padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          //   height: 200.0,
          //   width: 200.0,
          //   child: SvgPicture.asset(
          //     'assets/images/password.svg',
          //     color: Colors.white,
          //   ),
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'سجل مستشفى جديدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.bold,
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
              onChanged: (selectedName) {
                hospitalname = selectedName;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'اسم المستشفى',
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
              onChanged: (selectedEmail) {
                email = selectedEmail;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'البريد الإلكتروني',
                hintStyle: TextStyle(
                  color: kLightColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
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
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 120.0),
            child: RaisedButton(
              child: Text(
                'سجل',
                style: TextStyle(fontSize: 30.0),
              ),
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
              },
              color: Color(0xffabd1c6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
