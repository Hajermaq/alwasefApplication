import 'package:alwasef_app/Screens/all_doctor_screens/add_prescriptions.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'Screens/all_doctor_screens/doctor_main_page.dart';
import 'Screens/all_patient_screen/fill_medical_history_screen.dart';
import 'Screens/services/provider_management.dart';
import 'constants.dart';
//import 'file:///C:/Users/hajer/AndroidStudioProjects/alwasef_app/lib/Screens/all_patient_screen/patints_info_screen.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/patient_details_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/login_and_registration/Register_hospital_screen.dart';
import 'Screens/all_admin_screen/admin_page.dart';
import 'Screens/login_and_registration/login_screen.dart';
import 'Screens/all_patient_screen/patients_mainpage.dart';
import 'Screens/all_pharmacist_screens/pharamacists_mainpage.dart';
import 'Screens/login_and_registration/register_screen.dart';
import 'Screens/login_and_registration/reset_password_screen.dart';
import 'Screens/login_and_registration/welcome_screen.dart';
import 'Screens/login_and_registration/login_or_signin_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/PrescriptionData.dart';

//أناااااااااااااااااا هناا

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
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider(
        create: (context) => PrescriptionData(),
        child: MaterialApp(
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
            //Admin Screens
            AdminScreen.id: (context) => AdminScreen(),
            //Doctor Screens
            DoctorMainPage.id: (context) => DoctorMainPage(),
            PatientDetails.id: (context) => PatientDetails(),
            AddPrescriptions.id: (context) => AddPrescriptions(),
            //Pharmacist Screens
            PharmacistMainPage.id: (context) => PharmacistMainPage(),
            //Patient Screens
            PatientMainPage.id: (context) => PatientMainPage(),
            FillMedicalHistoryPage.id: (context) => FillMedicalHistoryPage(),
            //PatientsInfoScreen.id: (context) => PatientsInfoScreen(),
          },
        ),
// <<<<<<< HEAD
// =======
//         initialRoute: WelcomeScreen.id,
//         routes: {
//           //login & registration
//           WelcomeScreen.id: (context) => WelcomeScreen(),
//           LogInORSignIn.id: (context) => LogInORSignIn(),
//           LogInScreen.id: (context) => LogInScreen(),
//           RegisterScreen.id: (context) => RegisterScreen(),
//           RegisterHospitalScreen.id: (context) => RegisterHospitalScreen(),
//           ResetPassword.id: (context) => ResetPassword(),
//           //Admin Screens
//           AdminScreen.id: (context) => AdminScreen(),
//           //Doctor Screens
//           DoctorMainPage.id: (context) => DoctorMainPage(),
//           PatientDetails.id: (context) => PatientDetails(),
//           AddPrescriptions.id: (context) => AddPrescriptions(),
//           //Pharmacist Screens
//           PharmacistMainPage.id: (context) => PharmacistMainPage(),
//           //Patient Screens
//           PatientMainPage.id: (context) => PatientMainPage(),
//           MedicalHistoryPage.id: (context) => MedicalHistoryPage(),
//         },
// >>>>>>> 50793c904c9ea87e33850f0c1d542a79068dbf28
      ),
    );
  }
}
