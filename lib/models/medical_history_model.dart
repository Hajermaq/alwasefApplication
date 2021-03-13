import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalHistory {
  String patientUID;
  String patientFullName,
      gender,
      maritalStatus,
      pregnancy,
      smoking;
  DateTime birthDate;
  int age;
  double weight,
      height;
  List<String> hospitalizations,
      surgery,
      chronicDisease,
      currentMed,
      allergies,
      medAllergies;


  void saveMedicalHistoryForm(String userID) async {

    try{
      CollectionReference collection =
      FirebaseFirestore.instance.collection('Medical History');
      await collection.doc(userID).set({
        'uid': patientUID,
        'full name': patientFullName,
        'gender': gender,
        'birth date': birthDate,
        'age': age,
        'weight': weight,
        'height': height,
        'marital status': maritalStatus,
        'pregnancy': pregnancy,
        'smoking': smoking,
        'hospitalization': hospitalizations,
        'surgery': surgery,
        'chronic disease': chronicDisease,
        'current medications': currentMed,
        'allergies': allergies,
        'medication allergies': medAllergies,
      });
    }catch (e) {
      print(e);
    }
  }

 // Future<String> getFullName(String userID) async{
 //   final snapshot = FirebaseFirestore.instance.collection('Medical History')
 //       .
 //    await FirebaseFirestore.instance.collection('Medical History')
 //       .doc(FirebaseAuth.instance.currentUser.uid).get()
 //       .then((value) {
 //         return value.get('full name');
 //   });
 // }

}