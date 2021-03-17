import 'dart:async';

import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
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
              Text('شكرا على التسجيل! انتقل إلى البريد وتحقق من حسابك'),
              lodaing ? Icon(Icons.check) : CircularProgressIndicator(),
              RaisedButton(
                onPressed: () async {
                  setState(() {
                    if (isVerified) {
                      if ('طبيب' == widget.role) {
                        UserManagement().newDoctorSetUp(
                            context,
                            widget.password,
                            widget.name,
                            widget.role,
                            widget.hospital_UID);
                      } else if ('صيدلي' == widget.role) {
                        UserManagement().newPharmacistSetUp(
                            context,
                            widget.password,
                            widget.name,
                            widget.role,
                            widget.hospital_UID);
                      } else if ('موظف استقبال' == widget.role) {
                        UserManagement().newPatientSetUp(
                            context,
                            widget.password,
                            widget.name,
                            widget.role,
                            widget.hospital_UID,
                            '');
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
                child: Text('تم'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
