import 'dart:async';

import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/round-button.dart';
import 'package:alwasef_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifiyPage extends StatefulWidget {
  static const String id = 'verify_screen';
  VerifiyPage(
      {this.name, this.email, this.password, this.role, this.hospital_UID});
  String email;
  String password;
  String name;
  String role;
  String hospital_UID;
  @override
  _VerifiyPageState createState() => _VerifiyPageState();
}

class _VerifiyPageState extends State<VerifiyPage> {
  //Variables
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  bool isVerified;
  bool isLoading = false;

  // Functions
  @override
  void initState() {
    user = auth.currentUser;
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

// check email is verified or not
  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    User user2 = auth.currentUser;
    if (user2.emailVerified) {
      setState(() {
        isLoading = true;
      });
      timer.cancel();
      isVerified = user2.emailVerified;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19),
                child: Column(
                  children: [
                    Text(
                      'شكرا على التسجيل!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 25.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' انتقل إلى البريد وتحقق من حسابك',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              isLoading
                  ? Column(
                      children: [
                        CircleAvatar(
                            backgroundColor: kGreyColor,
                            child: Icon(Icons.check)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('تم التحقق من بريدك الإلكتروني'),
                      ],
                    )
                  : CircularProgressIndicator(
                      backgroundColor: Colors.white54,
                      valueColor: AlwaysStoppedAnimation(Colors.red)),
              SizedBox(
                height: 100.0,
              ),
              RoundRaisedButton(
                text: 'تسجيل الدخول',
                onPressed: () async {
                  setState(() {
                    if (isVerified) {
                      // register a doctor
                      if ('طبيب' == widget.role) {
                        UserManagement().newDoctorSetUp(
                          context: context,
                          hospitalUID: widget.hospital_UID,
                          speciality: null,
                          doctorName: widget.name,
                          role: widget.role,
                          phoneNumber: '',
                          experienceYears: null,
                        );
                        // register a pharmacist
                      } else if ('صيدلي' == widget.role) {
                        UserManagement().newPharmacistSetUp(
                          context: context,
                          hospitalUID: widget.hospital_UID,
                          pharmacistName: widget.name,
                          role: widget.role,
                          speciality: null,
                        );
                        // register a patient
                      } else if ('مريض' == widget.role) {
                        String pharmacistUID;
                        UserManagement().newPatientSetUp(
                          context: context,
                          hospitalUID: widget.hospital_UID,
                          pharmacistUID: pharmacistUID,
                          role: widget.role,
                          patientName: widget.name,
                          phoneNumber: '',
                          doctorsMap: {
                            '1': null,
                            '2': null,
                            '3': null,
                            '4': null,
                          },
                        );
                        // register a hospital
                      } else {
                        UserManagement().newHospitalSetUp(
                          context: context,
                          hospitalName: widget.name,
                          role: widget.role,
                        );
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
