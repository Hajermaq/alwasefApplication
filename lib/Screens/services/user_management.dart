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
  UserManagement({this.currentPatient_uid, this.documentId});

  String currentPatient_uid;
  String documentId;
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

  Future<void> newPrescriptionSetUp({
    context,
    //id's
    String patientId,
    String prescriberId,
    String registerNumber,
    //dates
    String creationDate,
    String startDate,
    String endDate,
    //names
    String scientificName,
    String scientificNameArabic,
    String tradeName,
    String tradeNameArabic,
    //units
    String strength,
    String strengthUnit,
    String size,
    String sizeUnit,
    // random
    String pharmaceuticalForm,
    String administrationRoute,
    String storageConditions,
    String publicPrice,
    //Textfiels data
    // integers
    int dose,
    int quantity,
    int refill,
    int dosingExpire,
    // strings
    var frequency,
    String instructionNote,
    String doctorNotes,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;
      String uid = currentUser.uid.toString();

      if (currentUser != null) {
        await collection.doc(patientId).collection('/Prescriptions').add(
          {
            // status
            'status': 'pending',
            //id's
            'prescriber-id': prescriberId,
            'pharmacist-id': '',
            'registerNumber': registerNumber,
            //dates
            'prescription-creation-date': creationDate,
            'start-date': startDate,
            'end-date': endDate,
            //names
            'scientificName': scientificName,
            'tradeName': tradeName,
            'tradeNameArabic': tradeNameArabic,
            'scientificNameArabic': scientificNameArabic,
            //units
            'strength': strength,
            'strength-unit': strengthUnit,
            'size': size,
            'size-unit': sizeUnit,
            // random
            'pharmaceutical-form': pharmaceuticalForm,
            'administration-route': administrationRoute,
            'storage-conditions': storageConditions,
            'price': publicPrice,
            // textfiles data
            //integers
            'dose': dose,
            'quantity': quantity,
            'refill': refill,
            'dosing-expire': dosingExpire,
            // strings
            'frequency': frequency,
            'instruction-note': instructionNote,
            'doctor-note': doctorNotes,
          },
        ).then((value) {
          Navigator.of(context).pop();
        }).catchError((e) {
          print(e);
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  Future<void> prescriptionUpdate(
    context,
    String instructionNote,
    var frequency,
    int refill,
    // String documentID,
    // String registerNumber,
    // String creationDate,
    // String startDate,
    // String endDate,
    // String id,
    // String scientificName,
    // String scientificNameArabic,
    // String tradeName,
    // String tradeNameArabic,
    // String strengthUnit,
    // String pharmaceuticalForm,
    // String administrationRoute,
    // String sizeUnit,
    // String storageConditions,
    // String strength,
    // String publicPrice,
    // int size,
    // int dose,
    // int quantity,
    // int refill,
    // int dosingExpire,
    // var frequency,
    // String instructionNote,
    // String doctorNotes,
    // String doctorUID,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;
      String uid = currentUser.uid.toString();

      if (currentUser != null) {
        await collection
            .doc(currentPatient_uid)
            .collection('/Prescriptions')
            .doc(documentId)
            .set(
          {
            'frequency': frequency,
            'instruction-note': instructionNote,
            'refill': refill,
            // 'registerNumber': registerNumber,
            // 'id': currentPatient_uid,
            // 'start-date': startDate,
            // 'end-date': endDate,
            // 'scientificName': scientificName,
            // 'tradeName': tradeName,
            // 'tradeNameArabic': tradeNameArabic,
            // 'scientificNameArabic': scientificNameArabic,
            // 'strength': strength,
            // 'strength-unit': strengthUnit,
            // 'pharmaceutical-form': pharmaceuticalForm,
            // 'administration-route': administrationRoute,
            // 'size': size,
            // 'size-unit': sizeUnit,
            // 'storage-conditions': storageConditions,
            // 'price': publicPrice,
            // 'dose': dose,
            // 'quantity': quantity,
            // 'refill': refill,
            // 'dosing-expire': dosingExpire,
            // 'frequency': frequency,
            // 'instruction-note': instructionNote,
            // 'doctor-note': doctorNotes,
            // // 'prescriber': doctorUID,
            // 'prescription-creation-date': creationDate,
          },
          SetOptions(merge: true),
        ).then((_) {
          Navigator.of(context).pop();
        }).catchError((e) {
          print(e);
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  Future<void> PastPrescriptionsSetUp(
    context,
    // status
    String status,
    //id's
    String patientId,
    String prescriberId,
    String registerNumber,
    //dates
    String creationDate,
    String startDate,
    String endDate,
    //names
    String scientificName,
    String scientificNameArabic,
    String tradeName,
    String tradeNameArabic,
    //units
    String strength,
    String strengthUnit,
    String size,
    String sizeUnit,
    // random
    String pharmaceuticalForm,
    String administrationRoute,
    String storageConditions,
    String publicPrice,
    //Textfiels data
    // integers
    int dose,
    int quantity,
    int refill,
    int dosingExpire,
    // strings
    var frequency,
    String instructionNote,
    String doctorNotes,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;
      String uid = currentUser.uid.toString();

      if (currentUser != null) {
        await collection
            .doc(patientId)
            .collection('/PastPrescriptions')
            .add(
              {
                // status
                'status': status,
                //id's
                'prescriber-id': prescriberId,
                'pharmacist-id': '',
                'registerNumber': registerNumber,
                //dates
                'prescription-creation-date': creationDate,
                'start-date': startDate,
                'end-date': endDate,
                //names
                'scientificName': scientificName,
                'tradeName': tradeName,
                'tradeNameArabic': tradeNameArabic,
                'scientificNameArabic': scientificNameArabic,
                //units
                'strength': strength,
                'strength-unit': strengthUnit,
                'size': size,
                'size-unit': sizeUnit,
                // random
                'pharmaceutical-form': pharmaceuticalForm,
                'administration-route': administrationRoute,
                'storage-conditions': storageConditions,
                'price': publicPrice,
                // textfiles data
                //integers
                'dose': dose,
                'quantity': quantity,
                'refill': refill,
                'dosing-expire': dosingExpire,
                // strings
                'frequency': frequency,
                'instruction-note': instructionNote,
                'doctor-note': doctorNotes,
              },
            )
            .then((_) {})
            .catchError((e) {
              print(e);
            });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  Future<void> newDiagnosisSetUp(
    context,
    //id's
    String patientId,
    String prescriberId,
    //dates
    String creationDate,
    String startDate,
    String endDate,
    String medicalDiagnosis,
    String diagnosisDescription,
    String medicalAdvice,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;
      String uid = currentUser.uid.toString();

      if (currentUser != null) {
        await collection.doc(patientId).collection('/Diagnoses').add(
          {
            //id's
            'prescriber-id': prescriberId,
            'pharmacist-id': '',
            //dates
            'diagnosis-creation-date': creationDate,
            'start-date': startDate,
            'end-date': endDate,
            // textfiles data
            // strings
            'medical-diagnosis': medicalDiagnosis,
            'diagnosis-description': diagnosisDescription,
            'medical-advice': medicalAdvice,
          },
        ).then((_) {
          Navigator.pop(context);
        }).catchError((e) {
          print(e);
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }
} // end of class
