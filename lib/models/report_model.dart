import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String committed,
      completed,
      sideEffects,
      notes,
      //prescriptionRefID,
      prescriptionDocID;

  // void me(String ref){
  //   FirebaseFirestore.instance.collection('/Prescription').doc()
  // }

  void saveReport(String uid) async {
    try{
      CollectionReference collection =
      FirebaseFirestore.instance.collection('/Patient');
      await collection.doc(uid).collection('/Reports').add({
        'completed': completed,
        'committed': committed,
        'side effects': sideEffects,
        'notes': notes,
        'prescription-id': prescriptionDocID,
      });
    }catch (e) {
      print(e);
    }
  }


}