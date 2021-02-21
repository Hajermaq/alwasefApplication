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
  User user;

  //Lists
  List<String> _specialities = [
    'مريض',
    'طبيب',
    'صيدلي',
  ];

  // Variables
  String _selectedSpeciality;
  String hospital_UID;
  String name;
  String password;
  String email;
  String role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
            color: kButtonColor,
            hintMessage: 'اسم المستخدم',
            onChanged: (value) {
              name = value;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundTextFields(
            color: kButtonColor,
            hintMessage: 'البريد الإلكتروني',
            onChanged: (value) {
              email = value;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundTextFields(
            color: kButtonColor,
            hintMessage: 'كلمة المرور',
            onChanged: (value) {
              password = value;
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
                dropdownColor: kPinkColor,
                style: kDropDownHintStyle,
                hint: Text(
                  'فضلا اختر تخصص',
                  style: GoogleFonts.almarai(
                    color: kButtonTextColor,
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
            stream:
                FirebaseFirestore.instance.collection('/Hospital').snapshots(),
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
//doctor
              if ('طبيب' == role) {
                await auth
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) => UserManagement().newDoctorSetUp(
                        context, password, name, role, hospital_UID))
                    .catchError((e) {
                  print(e);
                });
              } //pharmacist
              else if ('صيدلي' == role) {
                await auth
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) => UserManagement().newPharmacistSetUp(
                        context, password, name, role, hospital_UID))
                    .catchError((e) {
                  print(e);
                });
              } else {
                await auth
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) => UserManagement().newPatientSetUp(
                        context, password, name, role, hospital_UID))
                    .catchError((e) {
                  print(e);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
