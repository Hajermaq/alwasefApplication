import 'package:alwasef_app/components/medical_history_listTiles.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

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
  Widget build(BuildContext context) {
    setState(() {
      getName();
    });
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
        // Card(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(15.0),
        //   ),
        //   color: kLightColor,
        //   margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         ListTile(
        //           title: Text(
        //             'مرحبا بك ص. $name',
        //             style: TextStyle(
        //                 fontSize: 20.0,
        //                 color: Colors.black,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        backgroundColor: kGreyColor,
        body: Column(
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
            SizedBox(
              height: 13,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: kLightColor,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الوصفات الجديدة: ',
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
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('/Patient')
                                .where('pharmacist-uid', isEqualTo: currentUser.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List myPatientsIDs = [];
                              List myPatientsNames = [];
                              if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                              }
                              var documents = snapshot.data.docs;
                              for (var doc in documents) {
                                myPatientsIDs.add(doc.id);
                                myPatientsNames.add(doc.data()['patient-name']);
                              }
                              return ListView.builder(
                                // shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                  itemCount: myPatientsIDs.length,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('/Patient')
                                          .doc(myPatientsIDs[index])
                                          .collection('/Prescriptions')
                                          .where('status', isNotEqualTo: 'inconsistent')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(child: LinearProgressIndicator());
                                        }
                                        int patientNewPrescriptionsNo = snapshot.data.docs.length;
                                        if (patientNewPrescriptionsNo != 0) {

                                          // return ListTile(
                                          //     title: Text(myPatientsNames[index],
                                          //         style: TextStyle(color: Colors.black)),
                                          //     subtitle: Text('عدد الوصفات الجديد $patientNewPrescriptionsNo',
                                          //         style: TextStyle(color: Colors.black))
                                          // );
                                          return MedicalHistoyListTile(
                                            titleText: myPatientsNames[index],
                                            dataText: 'عدد الوصفات الجديدة $patientNewPrescriptionsNo',
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    );
                                  }
                              );

                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
