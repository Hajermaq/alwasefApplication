import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:alwasef_app/components/round-button.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Firebase
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  //Lists
  List<String> _specialities = [
    'مريض',
    'طبيب',
    'صيدلي',
  ];

  // Variables
  GlobalKey<FormState> _key = GlobalKey();
  String _selectedSpeciality;
  String hospital_UID;
  String name;
  String password;
  String email;
  String role;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
//functions
  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 اسم المستخدم مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0 اسم المستخدم غير صالح';
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 البريد الإلكتروني مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0 البريد الإلكتروني غير صالح';
    }
    return null;
  }

  String validatePassword(String value) {
    //At least one upper case
    String pattern1 = r'^(?=.*?[A-Z])';
    String pattern2 = r'^(?=.*?[a-z])';
    String pattern3 = r'^(?=.*?[0-9])';
    String pattern4 = r'^(?=.*?[#?!@$%^&*-])';
    String pattern5 = r'^.{8,}$';

    RegExp regExp1 = RegExp(pattern1);
    RegExp regExp2 = RegExp(pattern2);
    RegExp regExp3 = RegExp(pattern3);
    RegExp regExp4 = RegExp(pattern4);
    RegExp regExp5 = RegExp(pattern5);

    if (value.length == 0) {
      return ' \u26A0 كلمة المرور  مطلوب';
    } else if (!regExp1.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان تحتوي على حرف كبير ';
    } else if (!regExp2.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان تحتوي على حرف صغير ';
    } else if (!regExp3.hasMatch(value)) {
      return ' \u26A0   كلمة السر يجب ان تحتوي على رقم واحد على الأقل';
    } else if (!regExp4.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان تحتوي على أحرف خاصة ';
    } else if (!regExp5.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان لا تقل على 8 أحرف ';
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        autovalidateMode: autovalidateMode,
        child: SingleChildScrollView(
          child: Column(
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
                validator: validateName,
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
                validator: validateEmail,
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
                validator: validatePassword,
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
                          dropdownColor: kPinkColor,
                          style: kDropDownHintStyle,
                          hint: Text(
                            'فضلا اختر مستشفى',
                            style: GoogleFonts.almarai(
                              color: kButtonTextColor,
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

                    if ('طبيب' == role) {
                      await auth
                          .createUserWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        // upon success, send email verification
                        user.sendEmailVerification();
                        UserManagement().newDoctorSetUp(
                            context, password, name, role, hospital_UID);
                      }).catchError((e) {
                        print(e);
                      });
                    } //pharmacist
                    else if ('صيدلي' == role) {
                      await auth
                          .createUserWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        // upon success, send email verification
                        user.sendEmailVerification();
                        UserManagement().newPharmacistSetUp(
                            context, password, name, role, hospital_UID);
                      }).catchError((e) {
                        print(e);
                      });
                    } else {
                      await auth
                          .createUserWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        // upon success, send email verification
                        user.sendEmailVerification();
                        UserManagement().newPatientSetUp(
                            context, password, name, role, hospital_UID, '');
                      }).catchError((e) {
                        print(e);
                      });
                    }
                  } else {
                    // there is an error
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
