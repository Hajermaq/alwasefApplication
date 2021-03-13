import 'package:alwasef_app/Screens/all_doctor_screens/patient_details_screen.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientData extends StatefulWidget {
  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  String currentName;
  String currentEmail;
  String currentUID;
  String searchValue = '';
  String hUID = '';

  getHUID() async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      hUID = doc.data()['hospital-uid'];
    });
  }

  @override
  void initState() {
    getHUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
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
                        .where('hospital-uid', isEqualTo: hUID)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        //TODO
                        return CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot.data.docs[index];
                              String name =
                                  documentSnapshot.data()['patient-name'];
                              if (name
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase()) ||
                                  name
                                      .toUpperCase()
                                      .contains(searchValue.toUpperCase())) {
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
                                        leading: Icon(Icons.arrow_back),
                                        title: Text(
                                          documentSnapshot
                                              .data()['patient-name'],
                                          // snapshot.data.docs[index].get('patient-name'),
                                          style: TextStyle(
                                              color: kBlueColor,
                                              fontSize: 30.0),
                                        ),
                                        subtitle: Text(
                                          snapshot.data.docs[index]
                                              .get('email'),
                                          style: TextStyle(
                                              color: kBlueColor,
                                              fontSize: 15.0),
                                        ),
                                        onTap: () async {
                                          currentUID = snapshot.data.docs[index]
                                              .get('uid');
                                          print(
                                              " the id: ${snapshot.data.docs[index].get('uid')}");
                                          currentName = snapshot
                                              .data.docs[index]
                                              .get('patient-name');
                                          currentEmail = snapshot
                                              .data.docs[index]
                                              .get('email');
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PatientDetails(
                                                        name: currentName,
                                                        email: currentEmail,
                                                        uid: currentUID,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
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
}
