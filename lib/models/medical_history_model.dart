import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistory {
  String patientUID;
  String patientFullName,
      gender,
      birthDate,
      maritalStatus,
      pregnancy,
      smoking;
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
      FirebaseFirestore.instance.collection('/Patient');
      await collection.doc(userID).collection('/Medical History').add({
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
<<<<<<< HEAD
        // 'hospitalization': checkListNull(hospitalizations),
        // 'surgery': checkListNull(surgery),
        // 'chronic disease': checkListNull(chronicDisease),
        // 'current medications': checkListNull(currentMed),
        // 'allergies': checkListNull(allergies),
        // 'medication allergies': checkListNull(medAllergies),
=======
>>>>>>> db912c9c372681ed64221f13ea906859fbf9dbe3
      });
    }catch (e) {
      print(e);
    }
  }


}