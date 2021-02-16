// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class HospitalDropDownMenue extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 50, left: 50),
//       height: 50.0,
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         border: Border.all(
//           color: Color(0xffabd1c6),
//           width: 3.0,
//         ),
//       ),
//       child: StreamBuilder<DocumentSnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('hanan')
//         .doc(auth.currentUser.uid)
//         .snapshots(),
//     builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//     if(!snapshot.hasData{
//     return Text('has error');
//     }else{
//     List<DropDownM>
//     }
//     }
//
//
//
//
//
//
//
//
//
//     );
//
//
//
//
// }
// }
// }
