import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String committed,
      completed,
      notes,
      prescriptionRefID;
<<<<<<< HEAD
=======
  List<dynamic> sideEffects;
>>>>>>> db912c9c372681ed64221f13ea906859fbf9dbe3


  void saveReport(String uid) async {
    try{
      CollectionReference collection =
      FirebaseFirestore.instance.collection('/Patient');
      await collection.doc(uid).collection('/Reports').add({
        'completed': completed,
        'committed': committed,
        'side effects': sideEffects,
        'notes': notes,
        'prescription-id': prescriptionRefID,
      });
    } catch (e) {
      print(e);
    }
  }


}