import 'package:alwasef_app/Screens/all_doctor_screens/patient_medical_information.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientData extends StatefulWidget {
  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  //variables
  String currentName;
  String currentEmail;
  String currentUID;
  String searchValue = '';
  int mapKey;
  String hUID = '';
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
      hUID = doc.data()['hospital-uid'];

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
            'البحث ',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            FilledRoundTextFields(
                fillColor: kGreyColor,
                color: kScaffoldBackGroundColor,
                hintMessage: 'ابحث',
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/Patient')
                        .where('doctors_map.$mapKey',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: kGreyColor,
                                valueColor:
                                    AlwaysStoppedAnimation(kBlueColor)));
                      }
                      if (snapshot.data.docs.length == 0) {
                        return Center(
                          child: Text(
                            'ليس لديك أي مرضى حاليا.',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 17),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot patient =
                                  snapshot.data.docs[index];

                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('/Patient')
                                      .doc(patient.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                              backgroundColor: kLightColor,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      kLightColor)));
                                    } else {
                                      String name =
                                          snapshot.data.get('patient-name');
                                      if (name.toLowerCase().contains(
                                              searchValue.toLowerCase()) ||
                                          name.toUpperCase().contains(
                                              searchValue.toUpperCase())) {
                                        return Column(
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  10.0, 10.0, 10.0, 0),
                                              color: Color(0xfff0f2f7),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.arrow_back,
                                                ),
                                                title: Text(
                                                  snapshot.data
                                                      .get('patient-name'),
                                                  // snapshot.data.docs[index].get('patient-name'),
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 25.0),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data.get('email'),
                                                  style: TextStyle(
                                                      color: kBlueColor,
                                                      fontSize: 15.0),
                                                ),
                                                onTap: () async {
                                                  currentUID =
                                                      snapshot.data.get('uid');
                                                  currentName = snapshot.data
                                                      .get('patient-name');
                                                  currentEmail = snapshot.data
                                                      .get('email');
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PatientDetails(
                                                                name:
                                                                    currentName,
                                                                email:
                                                                    currentEmail,
                                                                uid: currentUID,
                                                              )));
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }

                                    return SizedBox();
                                  });
                            });
                      }
                    }),
              ),
            ),
          ]),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       resizeToAvoidBottomPadding: false,
  //       appBar: AppBar(
  //         automaticallyImplyLeading: false,
  //         iconTheme: IconThemeData(
  //           color: Colors.grey,
  //         ),
  //         centerTitle: true,
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             bottomRight: Radius.circular(6.0),
  //             bottomLeft: Radius.circular(6.0),
  //           ),
  //         ),
  //         title: Text(
  //           'البحث ',
  //           style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
  //         ),
  //       ),
  //       body: Container(
  //         padding: EdgeInsets.all(10),
  //         child: Column(children: [
  //           FilledRoundTextFields(
  //               fillColor: kGreyColor,
  //               color: kScaffoldBackGroundColor,
  //               hintMessage: 'ابحث',
  //               onChanged: (value) {
  //                 setState(() {
  //                   searchValue = value;
  //                 });
  //               }),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: StreamBuilder(
  //                   stream: FirebaseFirestore.instance
  //                       .collection('/Patient')
  //                       .snapshots(),
  //                   builder: (BuildContext context, snapshot) {
  //                     if (!snapshot.hasData) {
  //                       return Center(
  //                           child: CircularProgressIndicator(
  //                               backgroundColor: kGreyColor,
  //                               valueColor:
  //                                   AlwaysStoppedAnimation(kBlueColor)));
  //                     }
  //                     var docs = snapshot.data.docs;
  //                     List listOfMyPatients = [];
  //                     docs.forEach((doc) {
  //                       Map map = doc.data()['doctors_map'];
  //                       if (map.containsValue(
  //                           FirebaseAuth.instance.currentUser.uid)) {
  //                         listOfMyPatients.add(doc.get('uid'));}
  //                     });
  //                     if (listOfMyPatients.length == 0) {
  //                       return Center(
  //                         child: Text('ليس لديك أي مرضى حاليا.',
  //                           style: TextStyle(color: Colors.black54, fontSize: 17),
  //                         ),);
  //                     } else {
  //                       return ListView.builder(
  //                           physics: ScrollPhysics(),
  //                           itemCount: listOfMyPatients.length,
  //                           itemBuilder: (context, index) {
  //                             return StreamBuilder(
  //                                 stream: FirebaseFirestore.instance
  //                                     .collection('/Patient')
  //                                     .doc(listOfMyPatients[index])
  //                                     .snapshots(),
  //                                 builder: (context, snapshot) {
  //                                   if (!snapshot.hasData) {
  //                                     return Center(
  //                                         child: CircularProgressIndicator(
  //                                             backgroundColor: kLightColor,
  //                                             valueColor:
  //                                                 AlwaysStoppedAnimation(
  //                                                     kLightColor)));
  //                                   } else {
  //                                     String name =
  //                                         snapshot.data.get('patient-name');
  //                                     if (name.toLowerCase().contains(
  //                                             searchValue.toLowerCase()) ||
  //                                         name.toUpperCase().contains(
  //                                             searchValue.toUpperCase())) {
  //                                       return Column(
  //                                         children: [
  //                                           Card(
  //                                             shape: RoundedRectangleBorder(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(15.0),
  //                                             ),
  //                                             margin: EdgeInsets.fromLTRB(
  //                                                 10.0, 10.0, 10.0, 0),
  //                                             color: Color(0xfff0f2f7),
  //                                             child: ListTile(
  //                                               leading: Icon(
  //                                                 Icons.arrow_back,
  //                                               ),
  //                                               title: Text(
  //                                                 snapshot.data
  //                                                     .get('patient-name'),
  //                                                 // snapshot.data.docs[index].get('patient-name'),
  //                                                 style: TextStyle(
  //                                                     color: kBlueColor,
  //                                                     fontSize: 25.0),
  //                                               ),
  //                                               subtitle: Text(
  //                                                 snapshot.data.get('email'),
  //                                                 style: TextStyle(
  //                                                     color: kBlueColor,
  //                                                     fontSize: 15.0),
  //                                               ),
  //                                               onTap: () async {
  //                                                 currentUID =
  //                                                     snapshot.data.get('uid');
  //                                                 currentName = snapshot.data
  //                                                     .get('patient-name');
  //                                                 currentEmail = snapshot.data
  //                                                     .get('email');
  //                                                 await Navigator.push(
  //                                                     context,
  //                                                     MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             PatientDetails(
  //                                                               name:
  //                                                                   currentName,
  //                                                               email:
  //                                                                   currentEmail,
  //                                                               uid: currentUID,
  //                                                             )));
  //                                               },
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       );
  //                                     }
  //                                   }
  //
  //                                   return SizedBox();
  //                                 });
  //                           });
  //                     }
  //                   }),
  //             ),
  //           ),
  //         ]),
  //       ),
  //     ),
  //   );
  // }
}
