import 'package:cloud_firestore/cloud_firestore.dart';

// class Report {
//   String committed,
//       completed,
//       notes,
//       patientID,
//       patientName,
//       prescriberName,
//       pharmacistName,
//       tradeName;
//   List<dynamic> sideEffects;
//
//
//   void saveReport(String uid) async {
//     try{
//       CollectionReference collection =
//       FirebaseFirestore.instance.collection('/Report');
//       await collection.add({
//         'completed': completed,
//         'committed': committed,
//         'side effects': sideEffects,
//         'notes': notes,
//         'patient-id': patientID,
//         'patient-name': patientName,
//         'prescriper-name': prescriberName,
//         'pharmacist-name' : pharmacistName,
//         'tradeName' : tradeName,
//       }).then((_) {
//         print('document is created');
//       }).catchError((_) {
//         print(" an error occured");
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
// }

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
        'prescriper-id': prescriberID,
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