import 'package:alwasef_app/components/medical_history_listTiles.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:alwasef_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icon.dart';

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  List messages = ['hey', 'bye'];

  List<Widget> getArraytinfo(List list, String label) {
    List<Widget> listofWidgets = [];
    for (var i in list) {
      listofWidgets.add(
        Column(
          children: [
            ListTileDivider(
              color: Colors.black26,
            ),
            MedicalHistoyListTile(
              titleText: label,
              dataText: '$i',
            ),
          ],
        ),
      );
    }
    return listofWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            'الصفحة الرئيسة ',
            style: GoogleFonts.almarai(
              color: kLightColor,
              fontSize: 28.0,
            ),
          ),
        ),
        backgroundColor: kGreyColor,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Doctors')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              var doctor = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kLightColor,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: Text(
                                'مرحبا بك د. ${doctor['doctor-name']}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kLightColor,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'طلبات إعادة التعبئة',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            ListTileDivider(
                              color: Colors.black26,
                            ),
                            Column(
                              children: getArraytinfo(messages, 'الرسالة'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kLightColor,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'طلبات تعديل الوصفات من الصيدلي',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            ListTileDivider(
                              color: Colors.black26,
                            ),
                            Column(
                              children: getArraytinfo(messages, 'الرسالة'),
                            ),
                          ],
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
