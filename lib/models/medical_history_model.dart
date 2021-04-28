import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistory {
  String patientUID,
      patientFullName,
      gender,
      birthDate,
      maritalStatus,
      pregnancy,
      smoking,
      lastUpdated;
  double weight, height;
  List<String> hospitalizations,
      surgery,
      chronicDisease,
      currentMed,
      allergies,
      medAllergies;

  void saveMedicalHistoryForm(String userID) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('/Patient');
      await collection.doc(userID)
          .collection('/Medical History')
          .add({
        'uid': patientUID,
        'full name': patientFullName,
        'gender': gender,
        'birth date': birthDate,
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
        'last-update': lastUpdated,
          });
    } catch (e) {
      print(e);
    }
  }
}
