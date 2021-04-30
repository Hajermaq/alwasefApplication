import 'package:alwasef_app/components/medical_history_listTiles.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  //Firestore variables
  final currentUser = FirebaseAuth.instance.currentUser;
  // variables
  String name = ' ';
  int mapKey;

// methods
  getDoctorInfo() async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      if (doc.data()['doctor-speciality'] == 'طبيب قلب') {
        mapKey = 1;
      } else if (doc.data()['doctor-speciality'] == 'طبيب باطنية') {
        mapKey = 2;
      } else if (doc.data()['doctor-speciality'] == 'طبيب نفسي') {
        mapKey = 3;
      } else {
        mapKey = 4;
      }
      name = doc.data()['doctor-name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  void initState() {
    super.initState();
    getDoctorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            color: kBlueColor,
            fontSize: 28.0,
          ),
        ),
      ),
      backgroundColor: kGreyColor,
      body: SafeArea(
        minimum: EdgeInsets.only(left: 6.0, right: 6.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Patient')
                .where('doctors_map.$mapKey', isEqualTo: currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: kGreyColor,
                        valueColor: AlwaysStoppedAnimation(kBlueColor)));
              }
              var docs = snapshot.data.docs;
              List myPatientsIDs = [];
              List myPatientsNames = [];
              docs.forEach((doc) {
                Map map = doc.data()['doctors_map'];
                if (map.containsValue(currentUser.uid)) {
                  myPatientsIDs.add(doc.get('uid'));
                  myPatientsNames.add(doc.data()['patient-name']);
                }
              });

              if (snapshot.data.docs.length == 0) {
                return Column(children: [
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
                              'مرحبا بك د. $name',
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
                                    'الوصفات المتعارضة: ',
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
                            MedicalHistoyListTile(
                              titleText: 'ليس لديك أي مرضى حتى الان',
                              dataText: '',
                            ),
                          ]),
                    ),
                  ),
                ]);
              } else {
                return Column(
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
                                'مرحبا بك د. $name',
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
                    Flexible(
                      child: Card(
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
                                        'الوصفات المتعارضة: ',
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
                                Flexible(
                                  child: Container(
                                    child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot patient =
                                              snapshot.data.docs[index];
                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('/Patient')
                                                .doc(patient.id)
                                                .collection('/Prescriptions')
                                                .where('prescriber-id',
                                                    isEqualTo: currentUser.uid)
                                                .where('status',
                                                    isEqualTo: 'inconsistent')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: LinearProgressIndicator(
                                                      backgroundColor:
                                                          kGreyColor,
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              kBlueColor)),
                                                ));
                                              } else {
                                                int patientInconsistentPrescriptionsNo =
                                                    0;
                                                snapshot.data.docs
                                                    .forEach((prescription) {
                                                  patientInconsistentPrescriptionsNo++;
                                                });
                                                // only display patients names who has one or more inconsistent prescription
                                                if (patientInconsistentPrescriptionsNo !=
                                                    0) {
                                                  return MedicalHistoyListTile(
                                                    titleText:
                                                        myPatientsNames[index],
                                                    dataText:
                                                        'لديه $patientInconsistentPrescriptionsNo وصفات متعارضة',
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              }
                                            },
                                          );
                                        }),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(height: 8, color: kGreyColor),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
