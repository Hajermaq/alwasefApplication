import 'package:alwasef_app/Screens/login_and_registration/welcome_screen.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:alwasef_app/components/round-button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class DoctorProfileInfo extends StatefulWidget {
  @override
  _DoctorProfileInfoState createState() => _DoctorProfileInfoState();
}

class _DoctorProfileInfoState extends State<DoctorProfileInfo> {
  //Variables
  final currentUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  String initialVal = '';
  String password;
  String updatedEmail;
  String phoneNumber;
  //functions

  Future resetEmail(String newEmail, String password) async {
    var authResult = await auth.signInWithEmailAndPassword(
        email: currentUser.email, password: password);
    await authResult.user.updateEmail(newEmail);
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(authResult.user.uid)
        .update({'email': newEmail});
  }

  Future<void> resetPassword(String email) async {
    if (email == currentUser.email) {
      await auth.sendPasswordResetEmail(email: email);
      FirebaseFirestore.instance
          .collection('/Doctors')
          .doc(currentUser.uid)
          .update({});
    } else {
      print('no such a user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey,
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
            'الحساب الشخصي ',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/Doctors')
                      .doc(currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              margin: EdgeInsets.all(8.0),
                              color: kGreyColor,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20.0,
                                    ),
                                    title: Text(
                                      'د.${snapshot.data.get('doctor-name')} ',
                                      style: TextStyle(
                                        fontSize: 29.0,
                                      ),
                                    ),
                                    trailing: Icon(Icons.edit_outlined),
                                  )
                                ],
                              ),
                            ),
                            Card(
                              elevation: 8.0,
                              margin:
                                  EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  ProfileListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        // isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            height: 600,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'تغيير البريد الإلكتروني الخاصة بك',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 30.0),
                                                ),
                                                Text(
                                                  'أعد إدخال كلمة المرور الخاصة بك للمتابعة',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 50.0,
                                                    right: 50.0,
                                                  ),
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      password = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      fillColor: kGreyColor,
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            BorderSide(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'البريد الإلكتروني الجديد',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 50.0,
                                                    right: 50.0,
                                                  ),
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      updatedEmail = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      fillColor: kGreyColor,
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            BorderSide(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 100.0,
                                                      vertical: 20.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        resetEmail(updatedEmail,
                                                                password)
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                      },
                                                      color: kBlueColor,
                                                      child: Text(
                                                        'تحديث',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          // fontFamily: 'Montserrat',
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    title: 'البريد الإلكتروني',
                                    subtitle: currentUser.email,
                                    icon_1: Icon(Icons.email_outlined),
                                  ),
                                  ListTileDivider(),
                                  ProfileListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        // isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            height: 600,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'تغيير كلمة المرور الخاصة بك',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 30.0),
                                                ),
                                                Text(
                                                  'أعد إدخال البريد الإلكتروني الخاصة بك للمتابعة',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 50.0,
                                                    right: 50.0,
                                                  ),
                                                  child: TextFormField(
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    onChanged: (value) {
                                                      updatedEmail = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      fillColor: kGreyColor,
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            BorderSide(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 100.0,
                                                      vertical: 20.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        resetPassword(
                                                                updatedEmail)
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                      },
                                                      color: kBlueColor,
                                                      child: Text(
                                                        'تحديث',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          // fontFamily: 'Montserrat',
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    title: 'كلمة المرور',
                                    subtitle: '',
                                    icon_1: Icon(Icons.lock_outline),
                                  ),
                                  ListTileDivider(),
                                  ProfileListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        // isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            height: 600,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'تعيين رقم هاتف',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 30.0),
                                                ),
                                                Text(
                                                  'أدخل رقم هاتفك',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 50.0,
                                                    right: 50.0,
                                                  ),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    onChanged: (value) {
                                                      phoneNumber = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      fillColor: kGreyColor,
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            BorderSide(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 100.0,
                                                      vertical: 20.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    child: RaisedButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                '/Doctors')
                                                            .doc(
                                                                currentUser.uid)
                                                            .set(
                                                                {
                                                              'phoneNumber':
                                                                  phoneNumber
                                                            },
                                                                SetOptions(
                                                                    merge:
                                                                        true)).then(
                                                                (value) =>
                                                                    Navigator.pop(
                                                                        context));
                                                      },
                                                      color: kBlueColor,
                                                      child: Text(
                                                        'حفظ',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          // fontFamily: 'Montserrat',
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    title: 'رقم الهاتف',
                                    subtitle: '',
                                    icon_1: Icon(Icons.phone),
                                  ),
                                  ListTileDivider(),
                                  ProfileListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        // isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            height: 600,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'تسجيل الخروج ',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 30.0),
                                                ),
                                                Text(
                                                  'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 100.0,
                                                      vertical: 20.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    child: RaisedButton(
                                                      onPressed: () async {
                                                        await auth.signOut().then(
                                                            (value) => Navigator
                                                                .pushNamed(
                                                                    context,
                                                                    WelcomeScreen
                                                                        .id));
                                                      },
                                                      color: kBlueColor,
                                                      child: Text(
                                                        'نعم',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          // fontFamily: 'Montserrat',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'إلغاء الامر',
                                                    style: TextStyle(
                                                        color: kGreyColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    title: 'تسجيل خروج',
                                    subtitle: '',
                                    icon_1: Icon(Icons.logout),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
