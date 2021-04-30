import 'package:alwasef_app/Screens/login_and_registration/welcome_screen.dart';
import 'package:alwasef_app/Screens/services/profile_changes.dart';
import 'package:alwasef_app/components/profile_components.dart';
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
  //Firestore variables
  final currentUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
// variables
  String initialVal = '';
  String password;
  String updatedEmail;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: kGreyColor,
                            valueColor: AlwaysStoppedAnimation(kBlueColor)),
                      );
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
                                    leading: Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                                    title: Text(
                                      'د.${snapshot.data.get('doctor-name')}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChangeEmail(
                                            collectionName: 'Doctors',
                                          ),
                                        ),
                                      );
                                    },
                                    title: 'البريد الإلكتروني',
                                    subtitle: "${snapshot.data.get('email')}",
                                    icon_1: Icon(Icons.email_outlined),
                                  ),
                                  ListTileDivider(),
                                  ProfileListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChangePassword(
                                            collectionName: 'Doctors',
                                          ),
                                        ),
                                      );
                                    },
                                    title: 'كلمة المرور',
                                    subtitle: '***********',
                                    icon_1: Icon(Icons.lock_outline),
                                  ),
                                  ListTileDivider(),
                                  ProfileListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreatePhoneNumber(
                                            collectionName: 'Doctors',
                                          ),
                                        ),
                                      );
                                    },
                                    title: 'تعيين رقم هاتف',
                                    subtitle: snapshot.data
                                                .get('phone-number') ==
                                            ''
                                        ? ''
                                        : '${snapshot.data.get('phone-number')}',
                                    icon_1: Icon(Icons.phone),
                                  ),
                                  ListTileDivider(),
                                  ProfileListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePhoneNumber(
                                            currentphonenumber: snapshot.data
                                                .get('phone-number'),
                                            collectionName: 'Doctors',
                                          ),
                                        ),
                                      );
                                    },
                                    title: 'تعديل رقم الهاتف',
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
                                                        await auth.signOut();
                                                        Navigator.of(context)
                                                            .popUntil(ModalRoute
                                                                .withName(
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
