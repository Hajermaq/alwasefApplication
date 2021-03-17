import 'dart:async';

import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/Screens/login_and_registration/verify_email.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:alwasef_app/components/round-button.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Firebase
  FirebaseAuth auth = FirebaseAuth.instance;

  //Lists
  List<String> _specialities = [
    'مريض',
    'طبيب',
    'صيدلي',
    'موظف استقبال',
  ];

  // Variables
  User user;
  Timer timer;
  bool isVarified = false;
  String _selectedSpeciality;
  String hospital_UID;
  String name;
  String password;
  String email;
  String role;

  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

//functions

  Future<void> createUser() async {
    try {
      final authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult != null) {
        await authResult.user.sendEmailVerification();
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifiyPage(
            email: email,
            password: password,
            name: name,
            role: role,
            hospital_UID: hospital_UID,
          ),
        ),
      );
      // print("Done");
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(e.message, style: TextStyle(color: kBlueColor)),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  "OK",
                  style: TextStyle(color: kBlueColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _key,
        autovalidateMode: autovalidateMode,
        child: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: Text(
                      'انشئ حساب',
                      textAlign: TextAlign.center,
                      style: kRegisterUsersHeadlineStyle,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  RoundTextFields(
                    validator: Validation().validateName,
                    textInputType: TextInputType.name,
                    isObscure: false,
                    color: kButtonColor,
                    hintMessage: 'اسم المستخدم',
                    onSaved: (value) {
                      name = value;
                    },
                    onChanged: (value) {
                      _key.currentState.validate();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundTextFields(
                    validator: Validation().validateEmail,
                    textInputType: TextInputType.emailAddress,
                    isObscure: false,
                    color: kButtonColor,
                    hintMessage: 'البريد الإلكتروني',
                    onSaved: (value) {
                      email = value;
                    },
                    onChanged: (value) {
                      _key.currentState.validate();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundTextFields(
                    validator: Validation().validatePassword,
                    textInputType: TextInputType.text,
                    isObscure: true,
                    color: kButtonColor,
                    hintMessage: 'كلمة المرور',
                    onSaved: (value) {
                      password = value;
                    },
                    onChanged: (value) {
                      _key.currentState.validate();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                    margin: EdgeInsets.only(right: 50, left: 50),
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kButtonColor,
                        style: BorderStyle.solid,
                        width: 4.0,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: kBlueColor,
                        style: kDropDownHintStyle,
                        hint: Text(
                          'فضلا اختر تخصص',
                          style: GoogleFonts.almarai(
                            color: Colors.white54,
                          ),
                        ), // Not necessary for Option 1
                        value: _selectedSpeciality,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSpeciality = newValue;
                          });
                        },
                        items: _specialities.map((speciality) {
                          return DropdownMenuItem(
                            child: new Text(speciality),
                            value: speciality,
                            onTap: () {
                              role = speciality;
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('/Hospital')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('has no data');
                      } else {
                        List<DropdownMenuItem> hospitalsNames = [];
                        final documents = snapshot.data.docs;
                        for (var document in documents) {
                          hospitalsNames.add(
                            DropdownMenuItem(
                              child: Text(
                                document.get('hospital-name'),
                              ),
                              value: '${document.id}',
                            ),
                          );
                        }
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                          margin: EdgeInsets.only(right: 50, left: 50),
                          height: 50.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kButtonColor,
                              style: BorderStyle.solid,
                              width: 4.0,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: kBlueColor,
                              style: kDropDownHintStyle,
                              hint: Text(
                                'فضلا اختر مستشفى',
                                style: GoogleFonts.almarai(
                                  color: Colors.white54,
                                ),
                              ),
                              items: hospitalsNames,
                              onChanged: (value) {
                                hospital_UID = value;
                              },
                            ),
                          ),
                        );
                      }
                    }, // end of builder
                  ),

                  //here
                  RoundRaisedButton(
                    text: 'سجل',
                    onPressed: () async {
                      if (_key.currentState.validate()) {
                        //there is no error
                        _key.currentState.save();
                        createUser();
                      } else {
                        // there is an error
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
