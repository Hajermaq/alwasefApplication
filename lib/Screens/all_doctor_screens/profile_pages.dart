import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

//Variables
final currentUser = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
String initialVal = '';
String password;
String updatedEmail;
String phoneNumber;
String updatedPhoneNumber;
//Form requirements
GlobalKey<FormState> _key1 = GlobalKey();
GlobalKey<FormState> _key2 = GlobalKey();
GlobalKey<FormState> _key3 = GlobalKey();
GlobalKey<FormState> _key4 = GlobalKey();

AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
//functions

Future resetEmail(
    String newEmail, String password, String collectionName) async {
  print('collection name $collectionName');
  var authResult = await auth.signInWithEmailAndPassword(
      email: currentUser.email, password: password);
  await authResult.user.updateEmail(newEmail);
  print(authResult.user.uid);
  await FirebaseFirestore.instance
      .collection('/$collectionName')
      .doc(authResult.user.uid)
      .set({'email': newEmail}, SetOptions(merge: true));
}

Future<void> resetPassword(
    String email, String collectionName, BuildContext context) async {
  if (email == currentUser.email) {
    await auth.sendPasswordResetEmail(email: email);
  } else {
    print('no');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('البريد الإلكتروني المدخل لا يطابق بريدك الإلكتروني.',
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

class ChangeEmail extends StatefulWidget {
  ChangeEmail({this.collectionName});
  final String collectionName;
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kLightColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
          ),
        ),
        title: Text(
          'تغيير البريد الإلكتروني  ',
          style: GoogleFonts.almarai(
            color: kGreyColor,
            fontSize: 28.0,
          ),
        ),
      ),
      backgroundColor: kLightColor,
      body: SingleChildScrollView(
        child: Form(
          key: _key1,
          autovalidateMode: autovalidateMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.0,
              ),
              Text(
                'أعد إدخال كلمة المرور الخاصة بك للمتابعة',
                style: TextStyle(color: kBlueColor, fontSize: 16.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: TextFormField(
                  validator: Validation().validatePasswordLogin,
                  onSaved: (value) {
                    password = value;
                    print(password);
                  },
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور',
                    fillColor: kGreyColor,
                    filled: true,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: kRedColor,
                        width: 3.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'البريد الإلكتروني الجديد',
                style: TextStyle(color: kBlueColor, fontSize: 16.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: TextFormField(
                  validator: Validation().validateEmailReset,
                  onSaved: (value) {
                    updatedEmail = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'البريد الإلكتروني',
                    fillColor: kGreyColor,
                    filled: true,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 3.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_key1.currentState.validate()) {
                        //there is no error
                        _key1.currentState.save();
                        resetEmail(
                                updatedEmail, password, widget.collectionName)
                            .then((value) => Navigator.pop(context));
                        _key1.currentState.save();
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    child: Text(
                      'تحديث',
                      style: TextStyle(
                        color: Colors.white,
                        // fontFamily: 'Montserrat',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    color: kBlueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  ChangePassword({this.collectionName});
  final String collectionName;
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kLightColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
          ),
        ),
        title: Text(
          'تغيير كلمة المرور',
          style: GoogleFonts.almarai(
            color: kGreyColor,
            fontSize: 28.0,
          ),
        ),
      ),
      backgroundColor: kLightColor,
      body: SingleChildScrollView(
        child: Builder(builder: (BuildContext context) {
          return Form(
            key: _key2,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                ),
                Text(
                  'أعد إدخال البريد الإلكتروني الخاصة بك للمتابعة',
                  style: TextStyle(color: kBlueColor, fontSize: 16.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 50.0,
                    right: 50.0,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: Validation().validateEmailReset,
                    onSaved: (value) {
                      updatedEmail = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'البريد الإلكتروني',
                      fillColor: kGreyColor,
                      filled: true,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kRedColor,
                          width: 3.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (_key2.currentState.validate()) {
                          //there is no error
                          _key2.currentState.save();
                          resetPassword(
                                  updatedEmail, widget.collectionName, context)
                              .then((value) => Navigator.pop(context));
                          _key2.currentState.save();
                        } else {
                          setState(() {
                            autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      },
                      color: kBlueColor,
                      child: Text(
                        'تحديث',
                        style: TextStyle(
                          color: Colors.white,
                          // fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CreatePhoneNumber extends StatefulWidget {
  CreatePhoneNumber({this.collectionName});
  final String collectionName;
  @override
  _CreatePhoneNumberState createState() => _CreatePhoneNumberState();
}

class _CreatePhoneNumberState extends State<CreatePhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kLightColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
          ),
        ),
        title: Text(
          'تعيين رقم هاتف',
          style: GoogleFonts.almarai(
            color: kGreyColor,
            fontSize: 28.0,
          ),
        ),
      ),
      backgroundColor: kLightColor,
      body: SingleChildScrollView(
        child: Form(
          key: _key3,
          autovalidateMode: autovalidateMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                'أدخل رقم هاتفك',
                style: TextStyle(color: kBlueColor, fontSize: 16.0),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: Validation().validateMobile,
                  onSaved: (value) {
                    phoneNumber = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'رقم الهاتف',
                    fillColor: kGreyColor,
                    filled: true,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: kRedColor,
                        width: 3.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_key3.currentState.validate()) {
                        //there is no error
                        _key3.currentState.save();

                        await FirebaseFirestore.instance
                            .collection('/${widget.collectionName}')
                            .doc(currentUser.uid)
                            .set({
                          'phone-number': phoneNumber
                        }, SetOptions(merge: true)).then(
                                (value) => Navigator.pop(context));
                        _key3.currentState.save();
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    color: kBlueColor,
                    child: Text(
                      'حفظ',
                      style: TextStyle(
                        color: Colors.white,
                        // fontFamily: 'Montserrat',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePhoneNumber extends StatefulWidget {
  ChangePhoneNumber({this.collectionName, this.currentphonenumber});
  final String collectionName;
  final String currentphonenumber;
  @override
  _ChangePhoneNumberState createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kLightColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
          ),
        ),
        title: Text(
          'تعديل رقم الهاتف',
          style: GoogleFonts.almarai(
            color: kGreyColor,
            fontSize: 28.0,
          ),
        ),
      ),
      backgroundColor: kLightColor,
      body: SingleChildScrollView(
        child: Form(
          key: _key4,
          autovalidateMode: autovalidateMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                'عدل رقم هاتفك',
                style: TextStyle(color: kBlueColor, fontSize: 16.0),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: TextFormField(
                  initialValue: widget.currentphonenumber,
                  validator: Validation().validateMobile,
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    updatedPhoneNumber = value;
                  },
                  decoration: InputDecoration(
                    fillColor: kGreyColor,
                    filled: true,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: kRedColor,
                        width: 3.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_key4.currentState.validate()) {
                        //there is no error
                        _key4.currentState.save();

                        await FirebaseFirestore.instance
                            .collection('/${widget.collectionName}')
                            .doc(currentUser.uid)
                            .set({
                          'phone-number': updatedPhoneNumber
                        }, SetOptions(merge: true)).then(
                                (value) => Navigator.pop(context));
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    color: kBlueColor,
                    child: Text(
                      'حفظ',
                      style: TextStyle(
                        color: Colors.white,
                        // fontFamily: 'Montserrat',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
