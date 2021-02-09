import 'package:alwasef_app/Screens/doctors_mainpage.dart';
import 'package:alwasef_app/Screens/reset_password_screen.dart';
import 'package:alwasef_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: 50.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 120.0),
            child: RaisedButton(
              child: Text(
                'إذهب',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, DoctorMainPage.id);
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
              onTap: () {
                Navigator.pushNamed(context, ResetPassword.id);
              },
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
