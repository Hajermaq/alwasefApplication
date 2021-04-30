import 'package:alwasef_app/Screens/all_doctor_screens/action_add_diagnosis.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/action_add_prescriptions.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/patient_medical_information.dart';
import 'package:alwasef_app/Screens/login_and_registration/verify_email.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/all_patient_screen/bar_patient_medical_info.dart';
import 'Screens/all_admin_screen/admin_main_page.dart';
import 'Screens/all_doctor_screens/doctor_main_page.dart';
import 'Screens/all_patient_screen/edit_medical_history_page.dart';
import 'Screens/all_patient_screen/fill_medical_history_page.dart';
import 'Screens/all_patient_screen/patients_mainpage.dart';
import 'Screens/all_pharmacist_screens/pharamacists_mainpage.dart';
import 'Screens/login_and_registration/Register_hospital_screen.dart';
import 'Screens/login_and_registration/login_or_signup_screen.dart';
import 'Screens/login_and_registration/login_screen.dart';
import 'Screens/login_and_registration/register_screen.dart';
import 'Screens/login_and_registration/reset_password_screen.dart';
import 'Screens/login_and_registration/welcome_screen.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale:
            Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales,

        title: 'Al-Wasef Application',
        theme: ThemeData(
          scaffoldBackgroundColor: kScaffoldBackGroundColor,
          // scaffoldBackgroundColor: Color(0xffC2B4AF),
          // fontFamily: GoogleFonts.almarai(fontSize: 12.0),
          accentColor: kRedColor,
          textTheme: GoogleFonts.almaraiTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Color(0xffE4E8F4),
                ),
          ),
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          //login & registration
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LogInORSignIn.id: (context) => LogInORSignIn(),
          LogInScreen.id: (context) => LogInScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          RegisterHospitalScreen.id: (context) => RegisterHospitalScreen(),
          ResetPassword.id: (context) => ResetPassword(),
          VerifyPage.id: (context) => VerifyPage(),
          //Admin Screens
          AdminScreen.id: (context) => AdminScreen(),
          //Doctor Screens
          DoctorMainPage.id: (context) => DoctorMainPage(),
          PatientDetails.id: (context) => PatientDetails(),
          AddPrescriptions.id: (context) => AddPrescriptions(),
          AddDiagnosis.id: (context) => AddDiagnosis(),
          //Pharmacist Screens
          PharmacistMainPage.id: (context) => PharmacistMainPage(),
          //Patient Screens
          PatientMainPage.id: (context) => PatientMainPage(),
          FillMedicalHistoryPage.id: (context) => FillMedicalHistoryPage(),
          EditMedicalHistoryPage.id: (context) => EditMedicalHistoryPage(),
          PatientMedicalInfo.id: (context) => PatientMedicalInfo(),
        },
      ),
    );
  }
}
