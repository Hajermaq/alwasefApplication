import 'package:alwasef_app/components/medical_history_listTiles.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

// moath.y.m@hotmail.com  Moady@123
class PharmacistHomePage extends StatefulWidget {
  @override
  _PharmacistHomePageState createState() => _PharmacistHomePageState();
}

class _PharmacistHomePageState extends State<PharmacistHomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String name = ' ';

  getName() async {
    await FirebaseFirestore.instance
        .collection('/Pharmacist')
        .doc(currentUser.uid)
        .get()
        .then((doc) {
      name = doc.data()['pharmacist-name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getName();
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
                .where('pharmacist-uid', isEqualTo: currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              List myPatientsIDs = [];
              List myPatientsNames = [];
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(
                    backgroundColor: kGreyColor,
                    valueColor: AlwaysStoppedAnimation(kBlueColor))
                );
              }
              if (snapshot.data.docs.length == 0) {
                return Column(
                    children: [
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
                              'مرحبا بك ص. $name',
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
                                    'الوصفات المضافة حديثا: ',
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
                                    'طلبات إعادة التعبئة:',
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
                            ),
                          ]),
                    ),
                  ),
                ]);
              } else {
                var documents = snapshot.data.docs;
                for (var doc in documents) {
                  myPatientsIDs.add(doc.id);
                  myPatientsNames.add(doc.data()['patient-name']);
                }
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
                                'مرحبا بك ص. $name',
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
                                        'الوصفات المضافة حديثا: ',
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
                                        itemCount: myPatientsIDs.length,
                                        itemBuilder: (context, index) {
                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('/Patient')
                                                .doc(myPatientsIDs[index])
                                                .collection('/Prescriptions')
                                            // can not use this method because do not give docs length
                                                // .where('status',
                                                //     isEqualTo: 'pending')
                                                // .where('status',
                                                //     isEqualTo: 'updated')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child:
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: LinearProgressIndicator(
                                                              backgroundColor: kGreyColor,
                                                              valueColor: AlwaysStoppedAnimation(kBlueColor)),
                                                        ));
                                              }
                                              int patientNewPrescriptionsNo = 0;
                                              snapshot.data.docs.forEach((prescription){
                                                if(
                                                prescription.data()['status'] == 'pending' ||
                                                    prescription.data()['status'] == 'updated' ) {
                                                  patientNewPrescriptionsNo++;
                                                }
                                              });
                                              // only display patients names who has one or more new prescription
                                              if (patientNewPrescriptionsNo != 0) {
                                                 return MedicalHistoyListTile(
                                                  titleText:
                                                  myPatientsNames[index],
                                                  dataText:
                                                  'لديه/لديها $patientNewPrescriptionsNo وصفات جديدة',
                                                );
                                              } else {
                                                return SizedBox();
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
                                        'طلبات إعادة التعبئة:',
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
                                        itemCount: myPatientsIDs.length,
                                        itemBuilder: (context, index) {
                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('/Patient')
                                                .doc(myPatientsIDs[index])
                                                .collection('/Prescriptions')
                                                .where('status',
                                                    isEqualTo:
                                                        'requested refill')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child:
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: LinearProgressIndicator(
                                                              backgroundColor: kGreyColor,
                                                              valueColor: AlwaysStoppedAnimation(kBlueColor)),
                                                        ));
                                              } else {
                                                int patientNewPrescriptionsNo =
                                                    snapshot.data.docs.length;
                                                // only display patients names who requested refill
                                                if (patientNewPrescriptionsNo !=
                                                    0) {
                                                  return MedicalHistoyListTile(
                                                    titleText:
                                                    myPatientsNames[index],
                                                    dataText:
                                                    'طلب إعادة تعبئة لـ $patientNewPrescriptionsNo وصفات',
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
                  ],
                );
              }
            }),
      ),
    );
  }



}
