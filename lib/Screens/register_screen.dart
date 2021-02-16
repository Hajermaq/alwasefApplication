import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> _specialities = [
    'مريض',
    'طبيب',
    'صيدلي',
  ]; // Option 2
  String _selectedSpeciality;
  String hospital_UID;
  String name;
  String password;
  String email;
  String role;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
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
          // Container(
          //   padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          //   height: 200.0,
          //   width: 200.0,
          //   child: SvgPicture.asset(
          //     'assets/images/password.svg',
          //     color: Colors.white,
          //   ),
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              'انشئ حساب',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60.0,
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 50, left: 50),
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(0xffabd1c6),
                width: 3.0,
              ),
            ),
            child: TextField(
              onChanged: (selectedName) {
                name = selectedName;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'اسم المستخدم',
                hintStyle: kTextFieldHintStyle,
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 50, left: 50),
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(0xffabd1c6),
                width: 3.0,
              ),
            ),
            child: TextField(
              onChanged: (selectedEmail) {
                email = selectedEmail;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'البريد الإلكتروني',
                hintStyle: TextStyle(
                  color: kLightColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 50, left: 50),
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(0xffabd1c6),
                width: 3.0,
              ),
            ),
            child: TextField(
              onChanged: (selectedPasword) {
                password = selectedPasword;
              },
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                hintStyle: TextStyle(
                  color: kLightColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 50, left: 50),
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(0xffabd1c6),
                width: 3.0,
              ),
            ),
            child: DropdownButton(
              isExpanded: true,
              dropdownColor: kDarkGreenColor,
              style: kDropDownHintStyle,
              hint: Text(
                'فضلا اختر تخصص',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
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
                  margin: EdgeInsets.only(right: 50, left: 50),
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color(0xffabd1c6),
                      width: 3.0,
                    ),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    dropdownColor: kDarkGreenColor,
                    style: kDropDownHintStyle,
                    hint: Text(
                      'فضلا اختر مستشفى',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    items: hospitalsNames,
                    onChanged: (value) {
                      hospital_UID = value;
                    },
                  ),
                );
              }
            }, // end of builder
          ),
          SizedBox(
            height: 20.0,
          ),

          SizedBox(
            height: 50.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 120.0),
            child: RaisedButton(
              child: Text(
                'سجل',
                style: TextStyle(fontSize: 30.0),
              ),
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
              color: Color(0xffabd1c6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
