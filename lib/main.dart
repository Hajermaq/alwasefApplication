import 'package:alwasef_app/Screens/doctors_mainpage.dart';
import 'package:alwasef_app/Screens/login_or_signin_screen.dart';
import 'package:flutter/material.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'Screens/reset_password_screen.dart';
import 'Screens/welcome_screen.dart';
import 'Screens/login_or_signin_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff004643),
        accentColor: Color(0xffabd1c6),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LogInORSignIn.id: (context) => LogInORSignIn(),
        LogInScreen.id: (context) => LogInScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        DoctorMainPage.id: (context) => DoctorMainPage(),
      },
    );
  }
}
