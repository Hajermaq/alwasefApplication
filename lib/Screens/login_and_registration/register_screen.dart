import 'dart:async';

import 'package:alwasef_app/Screens/login_and_registration/login_screen.dart';
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
            title: new Text(
                ' البريد الإلكتروني المدخل قيد الاستخدام من قبل حساب آخر.',
                style: TextStyle(color: kBlueColor)),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  "حسنا",
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
    return SafeArea(
      child: Scaffold(
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0, bottom: 40),
                        child: Text(
                          'انشئ حساب',
                          textAlign: TextAlign.center,
                          style: kRegisterUsersHeadlineStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
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
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                    //   margin: EdgeInsets.only(right: 50, left: 40),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton(
                    //       value: _selectedSpeciality,
                    //       dropdownColor: kBlueColor,
                    //       isDense: true,
                    //       style: kDropDownHintStyle,
                    //       hint: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           Icon(
                    //             Icons.shopping_bag_outlined,
                    //             color: kPinkColor,
                    //           ),
                    //           Text(
                    //             'فضلا اختر مسمى وظيفي',
                    //             style: GoogleFonts.almarai(
                    //               color: Colors.white54,
                    //               fontSize: 17.0,
                    //             ),
                    //           ),
                    //         ],
                    //       ), // Not necessary for Option 1
                    //       onChanged: (newValue) {
                    //         setState(() {
                    //           _selectedSpeciality = newValue;
                    //         });
                    //       },
                    //       items: _specialities.map((speciality) {
                    //         return DropdownMenuItem(
                    //           child: new Text(speciality),
                    //           value: speciality,
                    //           onTap: () {
                    //             role = speciality;
                    //           },
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: DropdownButtonFormField(
                        dropdownColor: kBlueColor,
                        isDense: true,
                        style: kDropDownHintStyle,
                        decoration: InputDecoration(
                          labelText: 'فضلا اختر مسمى وظيفي',
                          labelStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 13.0,
                          ),
                          //border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.shopping_bag_outlined,
                            color: kPinkColor,
                          ),
                          errorStyle: TextStyle(
                            color: kRedColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0,
                          ),
                        ),
                        icon: Icon(Icons.arrow_drop_down),
                        value: _selectedSpeciality,
                        items: _specialities.map((speciality) {
                          return DropdownMenuItem(
                            child: new Text(speciality, style: GoogleFonts.almarai()),
                            value: speciality,
                            onTap: () {
                              role = speciality;
                            },
                          );
                        }).toList(),

                        validator: (value) =>
                        value == null
                            ? 'هذا الحقل مطلوب'
                            : null,
                        onSaved: (newValue) {
                          setState(() {
                            _selectedSpeciality = newValue;
                          });
                        },
                        onChanged: (selectedValue) {},
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
                                  document.get('hospital-name')
                                ),
                                value: '${document.id}',
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: DropdownButtonFormField(
                              dropdownColor: kBlueColor,
                              isExpanded: true,
                              style: kDropDownHintStyle,
                              decoration: InputDecoration(
                                labelText: 'فضلا اختر اسم مستشفى',
                                labelStyle: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13.0,
                                ),
                                prefixIcon: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: kPinkColor,
                                ),
                                errorStyle: TextStyle(
                                  color: kRedColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              items: hospitalsNames,
                              value: hospital_UID,
                              validator: (value) =>
                              value == null
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                              onSaved: (newValue) {
                                setState(() {
                                  hospital_UID = newValue;
                                });
                              },
                              onChanged: (newValue) {},
                            ),
                          );
                        }
                      }, // end of builder
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
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
                    Container(
                      // TODO write this code
                      padding: EdgeInsets.only(top: 20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'تسجيل الدخول',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
