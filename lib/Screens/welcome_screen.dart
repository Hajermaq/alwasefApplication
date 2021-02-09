import 'package:alwasef_app/Screens/login_or_signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              'assets/images/vitamin.svg',
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا  ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Segoe UI',
              ),
            ),
          ),
          SizedBox(
            height: 140.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 100.0),
            child: RaisedButton(
              child: Text(
                'إنضموا إلينا',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, LogInORSignIn.id);
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
