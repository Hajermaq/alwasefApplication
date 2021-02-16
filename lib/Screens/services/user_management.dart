import 'package:alwasef_app/Screens/doctors_mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../admin_page.dart';

class UserManagement {
  FirebaseAuth auth = FirebaseAuth.instance;
  String documentName = FirebaseAuth.instance.currentUser.uid;
  String role;
  List<ListTile> patientNames = [];

  listPatients() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Patient').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text('has no data');
          } else {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      ListTile(
                        title:
                            Text(snapshot.data.docs[index].get('patient-name')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                    ],
                  );
                });
          }
        });
  } //end of method

  getDoctor(String role) {
    return FirebaseFirestore.instance
        .collection('/Doctors')
        .where(
          'role',
          isEqualTo: role,
        )
        .get();
  }

  getPatient(String role) {
    return FirebaseFirestore.instance
        .collection('/Patient')
        .where(
          'role',
          isEqualTo: role,
        )
        .get();
  }

  getPharmacist(String role) {
    return FirebaseFirestore.instance
        .collection('/Pharmacist')
        .where(
          'role',
          isEqualTo: role,
        )
        .get();
  }

  Future<void> newHospitalSetUp(
    context,
    String password,
    String hospitalName,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Hospital');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.add({
          'uid': uid,
          'hospital-name': hospitalName,
          'email': email,
          'password': password
        }).then((_) {
          print('collection is created');
          Navigator.of(context).pop();
          Navigator.pushNamed(context, AdminScreen.id);
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  } //end of method

  //===============================================================================

  Future<void> newDoctorSetUp(
    context,
    String password,
    String doctorName,
    String role,
    String hospital_uid,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Doctors');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.add({
          'uid': uid,
          'doctor-name': doctorName,
          'email': email,
          'password': password,
          'role': role,
          'hospital-uid': hospital_uid,
        }).then((_) {
          print('collection is created');
          Navigator.pushNamed(context, DoctorMainPage.id);
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  } //end of method
  //===============================================================================

  Future<void> newPharmacistSetUp(
    context,
    String password,
    String pharmacistName,
    String role,
    String hospital_uid,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Pharmacist');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.add({
          'uid': uid,
          'Pharmacist-name': pharmacistName,
          'email': email,
          'password': password,
          'role': role,
          'hospital-uid': hospital_uid,
        }).then((_) {
          print('collection is created');
          Navigator.of(context).pop();
          Navigator.pushNamed(context, AdminScreen.id);
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  //===============================================================================

  Future<void> newPatientSetUp(
    context,
    String password,
    String patientName,
    String role,
    String hospital_uid,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.add({
          'uid': uid,
          'patient-name': patientName,
          'email': email,
          'password': password,
          'role': role,
          'hospital-uid': hospital_uid,
        }).then((_) {
          print('collection is created');
          Navigator.of(context).pop();
          Navigator.pushNamed(context, AdminScreen.id);
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }
} // end of class
