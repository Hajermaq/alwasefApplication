import 'package:alwasef_app/Screens/all_doctor_screens/doctor_main_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/patient_details_screen.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../all_admin_screen/admin_page.dart';

class UserManagement {
  UserManagement({this.currentPatient_uid});

  String currentPatient_uid;

  //FireStore
  FirebaseAuth auth = FirebaseAuth.instance;
  // String documentName = FirebaseAuth.instance.currentUser.uid;
  var db = FirebaseFirestore.instance;

  //Variables

  // get roles
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

  Future<String> getDoctorHID() async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(auth.currentUser.uid)
        .get()
        .then((doc) {
      return doc.data()['hospital-uid'].toString();
    });
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

  // setUps
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

        await collection.doc(uid).set({
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
    String hospitalUID,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Doctors');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          'uid': uid,
          'doctor-name': doctorName,
          'email': email,
          'password': password,
          'role': role,
          'hospital-uid': hospitalUID,
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
    String hospitalUID,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Pharmacist');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          'uid': uid,
          'Pharmacist-name': pharmacistName,
          'email': email,
          'password': password,
          'role': role,
          'hospital-uid': hospitalUID,
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
    String hospitalUID,
    String doctorUID,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          'uid': uid,
          'patient-name': patientName,
          'email': email,
          'password': password,
          'role': role,
          'hospital-uid': hospitalUID,
          'doctor-uid': doctorUID,
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

  Future<void> newPrescriptionSetUp(
    context,
    String id,
    String scientificName,
    String scientificNameArabic,
    String tradeName,
    String tradeNameArabic,
    String strengthUnit,
    String pharmaceuticalForm,
    String administrationRoute,
    String sizeUnit,
    String storageConditions,
    String strength,
    String publicPrice,
    int size,
    int dose,
    int quantity,
    int refill,
    int dosingExpire,
    var frequency,
    String instructionNote,
    String doctorNotes,
    String doctorUID,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;
      String uid = currentUser.uid.toString();

      if (currentUser != null) {
        await collection.doc(id).collection('/Prescriptions').doc().set({
          'scientificName': scientificName,
          'tradeName': tradeName,
          'strength': strength,
          'strength-unit': strengthUnit,
          'pharmaceutical-form': pharmaceuticalForm,
          'administration-route': administrationRoute,
          'size': size,
          'size-unit': sizeUnit,
          'storage-conditions': storageConditions,
          'price': publicPrice,
          'dose': dose,
          'quantity': quantity,
          'refill': refill,
          'dosing-expire': dosingExpire,
          'frequency': frequency,
          'instruction-note': instructionNote,
          'doctor-note': doctorNotes,
          'prescriber': doctorUID,
        }).then((_) {
          print('collection is created');
          Provider.of<PrescriptionData>(context, listen: false).addPrescription(
              scientificName,
              scientificNameArabic,
              tradeName,
              tradeNameArabic,
              strengthUnit,
              pharmaceuticalForm,
              administrationRoute,
              sizeUnit,
              storageConditions,
              strength,
              publicPrice,
              size,
              dose,
              quantity,
              refill,
              dosingExpire,
              frequency,
              instructionNote,
              doctorNotes,
              context);
          Navigator.of(context).pop();
        }).catchError((e) {
          print(e);
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }
} // end of class
