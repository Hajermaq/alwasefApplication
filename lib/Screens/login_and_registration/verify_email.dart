import 'dart:async';

import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/round-button.dart';
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
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  bool isVerified;
  bool lodaing = false;
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

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    User user2 = auth.currentUser;
    if (user2.emailVerified) {
      setState(() {
        lodaing = true;
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
              Text(
                'شكرا على التسجيل! انتقل إلى البريد وتحقق من حسابك',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 40.0,
              ),
              lodaing ? Icon(Icons.check) : CircularProgressIndicator(),
              SizedBox(
                height: 40.0,
              ),
              RoundRaisedButton(
                text: 'تم التحقق',
                onPressed: () async {
                  setState(() {
                    if (isVerified) {
                      if ('طبيب' == widget.role) {
                        UserManagement().newDoctorSetUp(
                          context: context,
                          hospitalUID: widget.hospital_UID,
                          password: widget.password,
                          speciality: '',
                          doctorName: widget.name,
                          role: widget.role,
                          phoneNumber: '',
                          experienceYears: '',
                        );
                      } else if ('صيدلي' == widget.role) {
                        UserManagement().newPharmacistSetUp(
                          context: context,
                          hospitalUID: widget.hospital_UID,
                          password: widget.password,
                          pharmacistName: widget.name,
                          role: widget.role,
                        );
                      } else if ('مريض' == widget.role) {
                        UserManagement().newPatientSetUp(
                          context: context,
                          hospitalUID: widget.hospital_UID,
                          pharmacistUID: '',
                          doctor1uid: '',
                          doctor2uid: '',
                          doctor3uid: '',
                          doctor4uid: '',
                          password: widget.password,
                          role: widget.role,
                          patientName: widget.name,
                        );
                        //Hospital
                      } else {
                        UserManagement().newHospitalSetUp(
                            context: context,
                            hospitalName: widget.name,
                            role: widget.role,
                            doctorUID: '',
                            pharmacistUID: '');
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
