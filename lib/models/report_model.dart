import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String committed, completed, notes, prescriptionRefID;
  List<dynamic> sideEffects;

  void saveReport(String uid) async {
    try {
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
