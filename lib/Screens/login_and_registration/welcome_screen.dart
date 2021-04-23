import 'package:alwasef_app/components/outlined_button.dart';
import 'package:alwasef_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_or_signin_screen.dart';

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
            height: 150.0,
            width: 150.0,
            child: SvgPicture.asset(
              'assets/images/vitamin.svg',
              color: kSVGcolor,
            ),
          ),
          SizedBox(
            height: 70.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أهلا بك',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                'في تطبيق واصف للوصفات الطبية\n الإلكترونية الميسرة.',
                textAlign: TextAlign.center,
                style: kMainHeadLinesStyle,
              ),
            ],
          ),
          SizedBox(
            height: 200.0,
          ),
          OutinedButton(
            text: 'انضموا إلينا',
            onPressed: () {
              Navigator.pushNamed(context, LogInORSignIn.id);
            },
          )
        ],
      ),
    );
  }
}
