import 'package:alwasef_app/Screens/all_doctor_screens/patient_details_screen.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientData extends ChangeNotifier {
  String currentName;
  String currentEmail;

  // SameHospital(){
  //   var patient = FirebaseFirestore.instance.collection('/Patient').where('hospital-uid')
  //   if(){}
  // }
  //

  Widget streamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('/Patient').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            //TODO
            return Text('has no data');
          } else {
            return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          color: Color(0xfff0f2f7),
                          child: ListTile(
                            leading: Icon(Icons.arrow_back),
                            title: Text(
                              snapshot.data.docs[index].get('patient-name'),
                              style:
                                  TextStyle(color: kBlueColor, fontSize: 30.0),
                            ),
                            subtitle: Text(
                              snapshot.data.docs[index].get('email'),
                              style:
                                  TextStyle(color: kBlueColor, fontSize: 15.0),
                            ),
                            onTap: () async {
                              currentName =
                                  snapshot.data.docs[index].get('patient-name');
                              currentEmail =
                                  snapshot.data.docs[index].get('email');
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PatientDetails(
                                            name: currentName,
                                            email: currentEmail,
                                          )));
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     left: 15.0,
                        //     right: 15.0,
                        //   ),
                        // ),
                      ],
                    );
                  }),
            );
          }
        });
  }

  notifyListeners();
}
