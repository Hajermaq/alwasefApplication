import 'file:///C:/Users/hajer/AndroidStudioProjects/alwasef_app/lib/Screens/login_and_registration/Register_hospital_screen.dart';
import 'file:///C:/Users/hajer/AndroidStudioProjects/alwasef_app/lib/Screens/login_and_registration/login_screen.dart';
import 'file:///C:/Users/hajer/AndroidStudioProjects/alwasef_app/lib/Screens/login_and_registration/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/components/outlined_button.dart';

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
              color: kSVGcolor,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا  ',
              textAlign: TextAlign.center,
              style: kMainHeadLinesStyle,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          OutinedButton(
            text: 'تسجيل دخول',
            onPressed: () {
              Navigator.pushNamed(context, LogInScreen.id);
            },
          ),
          SizedBox(
            height: 33.0,
          ),
          OutinedButton(
            text: 'تسجيل مستخدم',
            onPressed: () {
              Navigator.pushNamed(context, RegisterScreen.id);
            },
          ),
          SizedBox(
            height: 33.0,
          ),
          OutinedButton(
            text: 'تسجيل مستشفى',
            onPressed: () {
              Navigator.pushNamed(context, RegisterHospitalScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
