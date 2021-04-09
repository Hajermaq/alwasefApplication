import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bar_patients_details_screen.dart';

class SearchPatientPage extends StatefulWidget {
  @override
  _SearchPatientPageState createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
  String currentName;
  String currentEmail;
  String currentUID;
  String searchValue = '';
  //TODO: remove Uid
  String hUID = '';

  getHUID() async {
    await FirebaseFirestore.instance
        .collection('/Pharmacist')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      hUID = doc.data()['hospital-uid'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getHUID();
    super.initState();
  }

  @override
  void dispose() {
    getHUID();
    super.dispose();
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
            'البحث ',
            style: GoogleFonts.almarai(color: kGreyColor, fontSize: 28.0),
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
                    //TODO: change where equals to (.where('uid', isEqualTo: currentUser.id) )
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
                                                      PatientDetails2(
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
