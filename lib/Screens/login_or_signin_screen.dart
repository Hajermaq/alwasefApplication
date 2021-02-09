import 'package:alwasef_app/Screens/login_screen.dart';
import 'package:alwasef_app/Screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogInORSignIn extends StatefulWidget {
  static const String id = 'signin_or_login_screen';
  @override
  _LogInORSignInState createState() => _LogInORSignInState();
}

class _LogInORSignInState extends State<LogInORSignIn> {
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
            padding: EdgeInsets.symmetric(horizontal: 100.0),
            child: RaisedButton(
              child: Text(
                'تسجيل دخول',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, LogInScreen.id);
              },
              color: Color(0xffabd1c6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          SizedBox(
            height: 33.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 100.0),
            child: RaisedButton(
              child: Text(
                'تسجيل جديد',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
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
