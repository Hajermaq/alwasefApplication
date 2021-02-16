import 'package:alwasef_app/Screens/doctors_mainpage.dart';
import 'package:alwasef_app/Screens/login_or_signin_screen.dart';
import 'package:alwasef_app/Screens/patints_info_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Register_hospital_screen.dart';
import 'Screens/admin_page.dart';
import 'Screens/login_screen.dart';
import 'Screens/patients_mainpage.dart';
import 'Screens/pharamacists_mainpage.dart';
import 'Screens/register_screen.dart';
import 'Screens/reset_password_screen.dart';
import 'Screens/welcome_screen.dart';
import 'Screens/login_or_signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        RegisterHospitalScreen.id: (context) => RegisterHospitalScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        AdminScreen.id: (context) => AdminScreen(),
        DoctorMainPage.id: (context) => DoctorMainPage(),
        PharmacistMainPage.id: (context) => PharmacistMainPage(),
        PatientMainPage.id: (context) => PatientMainPage(),
        PatientsInfoScreen.id: (context) => PatientsInfoScreen(),
      },
    );
  }
}
