import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String committed,
      completed,
      notes,
      prescriberID,
      pharmacistID,
      tradeName;
  List<dynamic> sideEffects;


  void saveReport(String uid) async {
    try{
      CollectionReference collection =
      FirebaseFirestore.instance.collection('/Patient');

      await collection
          .doc(uid)
          .collection('Reports')
          .add({
        'completed': completed,
        'committed': committed,
        'side effects': sideEffects,
        'notes': notes,
        'prescriber-id': prescriberID,
        'pharmacist-id' : pharmacistID,
        'tradeName' : tradeName,
      }).then((_) {
        print('document is created');
      }).catchError((_) {
        print(" an error occured");
      });
    } catch (e) {
      print(e);
    }
  }


}