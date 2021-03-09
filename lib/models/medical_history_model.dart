import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistory {
  String patient;
  String patientFullName,
      gender,
      maritalStatus,
      pregnancy,
      smoking,
      birthDate;
  int age;
  double weight,
      height;
  List<String> hospitalizations,
      surgery,
      currentMed,
      chronicDisease,
      allergies,
      medAllergies;


  void saveMedicalHistoryForm(String userID) async {

    try{
      CollectionReference collection =
      FirebaseFirestore.instance.collection('Medical History');
      await collection.doc(userID).set({
        'patient': patient,
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
        'current medications': currentMed,
        'chronic disease': chronicDisease,
        'medication allergies': medAllergies,
        'allergies': allergies,
      });
    }catch (e) {
      print(e);
    }
  }

}