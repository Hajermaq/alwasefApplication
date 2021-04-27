import 'package:alwasef_app/Screens/login_and_registration/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  getHospital(String role) {
    return FirebaseFirestore.instance
        .collection('/Hospital')
        .where(
          'role',
          isEqualTo: role,
        )
        .get();
  }

  // setUps

  //===============================================================================

  Future<void> newDoctorSetUp({
    context,
    String doctorName,
    String role,
    String hospitalUID,
    String speciality,
    String phoneNumber,
    String experienceYears,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Doctors');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          //ids
          'uid': uid,
          'hospital-uid': hospitalUID,
          //names
          'doctor-name': doctorName,
          //email
          'email': email,
          //random
          'doctor-speciality': speciality,
          'role': role,
          'phone-number': phoneNumber,
          'experience-years': experienceYears,
        }).then((_) {
          print('collection is created');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LogInScreen(),
            ),
          );
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  } //end of method
  //===============================================================================

  Future<void> newPharmacistSetUp({
    context,
    String pharmacistName,
    String role,
    String hospitalUID,
    String phoneNumber,
    String speciality,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Pharmacist');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          //ids
          'uid': uid,
          'hospital-uid': hospitalUID,
          //names
          'pharmacist-name': pharmacistName,
          //email
          'email': email,
          //random
          'role': role,
          'phone-number': phoneNumber,
          'speciality': speciality,
        }).then((_) {
          print('collection is created');
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LogInScreen(),
            ),
          );
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  //===============================================================================

  Future<void> newPatientSetUp({
    context,
    String patientName,
    String role,
    String hospitalUID,
    String pharmacistUID,
    String phoneNumber,
    Map doctorsMap,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          //ids
          'uid': uid,
          'hospital-uid': hospitalUID,
          'pharmacist-uid': pharmacistUID,
          //names
          'patient-name': patientName,
          //email
          'email': email,
          //random
          'role': role,
          'phone-number': phoneNumber,
          'doctors_map': doctorsMap,
        }).then((_) {
          print('collection is created');
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LogInScreen(),
            ),
          );
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  //===============================================================================
  Future<void> newHospitalSetUp({
    context,
    String role,
    String hospitalName,
    String phoneNumer,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Hospital');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid.toString();
        String email = currentUser.email.toString();

        await collection.doc(uid).set({
          //ids
          'hospital-id': uid,
          //name
          'hospital-name': hospitalName,
          //email
          'email': email,
          //random
          'role': role,
          'phone-number': phoneNumer,
        }).then((_) {
          print('collection is created');
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LogInScreen(),
            ),
          );
        }).catchError((_) {
          print(" an error occured");
        });
      } // end of if
    } catch (e) {
      print(e);
    }
  }

  //===============================================================================
  Future<void> newPrescriptionSetUp({
    context,
    //id's
    String patientId,
    String prescriberId,
    String prepharmacistId,
    String presciptionId,
    //dates
    String creationDate,
    String startDate,
    String endDate,
    //names
    String scientificName,
    String tradeName,
    String tradeNameArabic,
    //units
    String strength,
    String strengthUnit,
    // random
    String frequency,
    String note1,
    String note2,
    String pharmaceuticalForm,
    String administrationRoute,
    String storageConditions,
    String publicPrice,
    //Textfiels data
    // integers
    int refill,
    // strings
    String instructionNote,
    String doctorNotes,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        await collection.doc(patientId).collection('/Prescriptions').add(
          {
            // status
            'status': 'pending',
            //id's
            'prescriber-id': prescriberId,
            'pharmacist-id': prepharmacistId,
            'prescription-id': presciptionId,
            //dates
            'prescription-creation-date': creationDate,
            'start-date': startDate,
            'end-date': endDate,
            //names
            'scientificName': scientificName,
            'tradeName': tradeName,
            'tradeNameArabic': tradeNameArabic,
            //units
            'strength': strength,
            'strength-unit': strengthUnit,
            // random
            'note_1': note1,
            'note_2': note2,
            'pharmaceutical-form': pharmaceuticalForm,
            'administration-route': administrationRoute,
            'storage-conditions': storageConditions,
            'price': publicPrice,
            // textfiles data
            //integers
            'refill': refill,
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

  //===============================================================================
  Future<void> prescriptionUpdate({
    context,
    //id's
    String patientId,
    String prescriberId,
    String presciptionId,
    //dates
    String creationDate,
    String startDate,
    String endDate,
    //names
    String scientificName,
    String tradeName,
    String tradeNameArabic,
    //units
    String strength,
    String strengthUnit,
    // random
    String frequency,
    String note1,
    String note2,
    String pharmaceuticalForm,
    String administrationRoute,
    String storageConditions,
    String publicPrice,
    //Textfiels data
    // integers
    int refill,
    // strings
    String instructionNote,
    String doctorNotes,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        await collection
            .doc(currentPatient_uid)
            .collection('/Prescriptions')
            .doc(documentId)
            .set(
          {
            // status
            'status': 'updated',
            //id's
            'prescriber-id': prescriberId,
            //dates
            'prescription-creation-date': creationDate,
            'start-date': startDate,
            'end-date': endDate,
            //names
            'tradeName': tradeName,
            'scientificName': scientificName,
            'tradeNameArabic': tradeNameArabic,
            //units
            'strength': strength,
            'strength-unit': strengthUnit,
            // random
            'pharmaceutical-form': pharmaceuticalForm,
            'administration-route': administrationRoute,
            'storage-conditions': storageConditions,
            'price': publicPrice,
            // textfiles data
            //integers
            'refill': refill,
            // strings
            'frequency': frequency,
            'instruction-note': instructionNote,
            'doctor-note': doctorNotes,
            'note_1': note1,
            'note_2': note2,
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

  //===============================================================================
  Future<void> diagnosisUpdate({
    context,
    //id's
    String patientId,
    String prescriberId,
    //dates
    String creationDate,
    String medicalDiagnosis,
    String diagnosisDescription,
    String medicalAdvice,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = auth.currentUser;

      if (currentUser != null) {
        await collection
            .doc(currentPatient_uid)
            .collection('/Diagnoses')
            .doc(documentId)
            .set(
          {
            //status
            'status': 'updated',
            //id's
            'prescriber-id': prescriberId,
            'pharmacist-id': '',
            //dates
            'diagnosis-creation-date': creationDate,
            // textfiles data
            // strings
            'medical-diagnosis': medicalDiagnosis,
            'diagnosis-description': diagnosisDescription,
            'medical-advice': medicalAdvice,
          },
          SetOptions(merge: true),
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

  //===============================================================================
  Future<void> PastPrescriptionsSetUp(
    context,
    //id's
    String patientId,
    String prescriberId,
    String pharmacistId,
    //status
    String status,
    //dates
    String creationDate,
    String startDate,
    String endDate,
    //names
    String scientificName,
    String tradeName,
    String tradeNameArabic,
    //units
    String strength,
    String strengthUnit,
    // random
    String pharmaceuticalForm,
    String administrationRoute,
    String storageConditions,
    String publicPrice,
    //Textfiels data
    // integers
    int refill,
    // strings
    var frequency,
    String instructionNote,
    String doctorNotes,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = FirebaseAuth.instance.currentUser;

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
                'pharmacist-id': pharmacistId,
                //dates
                'prescription-creation-date': creationDate,
                'start-date': startDate,
                'end-date': endDate,
                //names
                'scientificName': scientificName,
                'tradeName': tradeName,
                'tradeNameArabic': tradeNameArabic,
                //units
                'strength': strength,
                'strength-unit': strengthUnit,
                // random
                'pharmaceutical-form': pharmaceuticalForm,
                'administration-route': administrationRoute,
                'storage-conditions': storageConditions,
                'price': publicPrice,
                // textfiles data
                //integers
                'refill': refill,
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

  //===============================================================================
  Future<void> PastDiagnosisSetUp(
    context,
    //id's
    String patientId,
    String prescriberId,
    //dates
    String creationDate,
    String medicalDiagnosis,
    String diagnosisDescription,
    String medicalAdvice,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await collection
            .doc(patientId)
            .collection('/PastDiagnoses')
            .add(
              {
                //status
                'status': 'deleted',
                //id's
                'prescriber-id': prescriberId,
                'pharmacist-id': '',
                //dates
                'diagnosis-creation-date': creationDate,
                // textfiles data
                // strings
                'medical-diagnosis': medicalDiagnosis,
                'diagnosis-description': diagnosisDescription,
                'medical-advice': medicalAdvice,
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

  //===============================================================================
  Future<void> newDiagnosisSetUp(
    context,
    //id's
    String patientId,
    String prescriberId,
    //dates
    String creationDate,
    String medicalDiagnosis,
    String diagnosisDescription,
    String medicalAdvice,
  ) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await collection.doc(patientId).collection('/Diagnoses').add(
          {
            //status
            'status': 'ongoing',
            //id's
            'prescriber-id': prescriberId,
            'pharmacist-id': '',
            //dates
            'diagnosis-creation-date': creationDate,
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
