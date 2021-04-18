import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class PatientsReports extends StatefulWidget {
  PatientsReports({this.role});
  final String role;

  @override
  _PatientsReportsState createState() => _PatientsReportsState();
}

class _PatientsReportsState extends State<PatientsReports> {
  String searchValue = '';

  // getMyPatients() async{
  //   if(widget.role == 'doctors'){
  //     await FirebaseFirestore.instance
  //         .collection('/Patient')
  //         .where('doctors', arrayContains: FirebaseAuth.instance.currentUser.uid)
  //         .get()
  //         .then((doc) {
  //       doc.docs.map((e) =>
  //         myPatientsIDs.add(e.id));
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     });
  //   } else {
  //     await FirebaseFirestore.instance
  //         .collection('/Patient')
  //         .where('pharmacist-id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
  //         .get()
  //         .then((doc) {
  //       doc.docs.map((e) =>
  //           myPatientsIDs.add(e.id));
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     });
  //   }
  // }
  //
  //
  // @override
  // void initState() {
  //   getMyPatients();
  // }

  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     resizeToAvoidBottomPadding: false,
  //     appBar: AppBar(
  //       iconTheme: IconThemeData(
  //         color: Colors.grey,
  //       ),
  //       centerTitle: true,
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           bottomRight: Radius.circular(6.0),
  //           bottomLeft: Radius.circular(6.0),
  //         ),
  //       ),
  //       title: Text('تقارير المرضى',
  //         style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
  //       ),
  //     ),
  //     body: Column(
  //       children: [
  //         FilledRoundTextFields(
  //             fillColor: kGreyColor,
  //             color: kScaffoldBackGroundColor,
  //             hintMessage: 'ابحث',
  //             onChanged: (value) {
  //               setState(() {
  //                 searchValue = value;
  //               });
  //             }),
  //         widget.role == 'doctor'
  //         // if current user role is doctor
  //             ? Container(
  //           child: StreamBuilder(
  //               stream: FirebaseFirestore.instance
  //                   .collection('/Patient')
  //                   .where('doctors', arrayContains: FirebaseAuth.instance.currentUser.uid)
  //                   .snapshots(),
  //               builder: (context, snapshot) {
  //                 print('i am doctor');
  //                 print(FirebaseAuth.instance.currentUser.uid);
  //                 if (!snapshot.hasData) {
  //                   return Center( child: CircularProgressIndicator());
  //                 } if (snapshot.data.docs.length == 0) {
  //                   return Center(
  //                     child: Text(
  //                       'ليس لديك أي مرضى حاليا.',
  //                       style: TextStyle(color: Colors.black54, fontSize: 17),
  //                     ),
  //                   );
  //                 } else {
  //                   print(myPatientsIDs);
  //                   // return SizedBox();
  //                   return ListView.builder(
  //                     itemCount: snapshot.data.docs.length,
  //                       itemBuilder: (context, index) {
  //                         DocumentSnapshot patientDoc = snapshot.data.docs[index];
  //                         String patientID = patientDoc.id;
  //                         //search by
  //                         String patientName = patientDoc.data()['patient-name'];
  //                       return StreamBuilder(
  //                         stream: FirebaseFirestore.instance
  //                             .collection('/Patient')
  //                             .doc(patientID)
  //                             .collection('Reports')
  //                             .snapshots(),
  //                         builder: (context, snapshot) {
  //                           if(!snapshot.hasData) {
  //                             return Center( child: CircularProgressIndicator());
  //                           } else {
  //                             return ListView.builder(
  //                                 itemCount: snapshot.data.docs.length,
  //                                 itemBuilder: (context, index) {
  //                                   DocumentSnapshot report = snapshot.data.docs[index];
  //                                   String completed = report.data()['completed'];
  //                                   String committed = report.data()['committed'];
  //                                   String sideEffects = report.data()['side effects'].join('\n');
  //                                   String notes = report.data()['notes'];
  //
  //                                   String pharmacistID = report.data()['pharmacist-id'];
  //
  //                                   //search by
  //                                   String tradeName = report.data()['tradeName'];
  //
  //                                   //search logic
  //                                   if (
  //                                   patientName
  //                                       .toLowerCase()
  //                                       .contains(searchValue.toLowerCase()) ||
  //                                       patientName
  //                                           .toUpperCase()
  //                                           .contains(searchValue.toUpperCase()) ||
  //                                       tradeName
  //                                           .toLowerCase()
  //                                           .contains(searchValue.toLowerCase()) ||
  //                                       tradeName
  //                                           .toUpperCase()
  //                                           .contains(searchValue.toUpperCase())) {
  //
  //                                     return Card(
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(15.0),
  //                                       ),
  //                                       color: kGreyColor,
  //                                       margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
  //                                       child: Column(
  //                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                           children: [
  //                                             ListTile(
  //                                               leading: Icon(Icons.assignment_rounded),
  //                                               title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
  //                                               subtitle: Text('اسم الدواء: $tradeName '),
  //                                             ),
  //                                             Divider(
  //                                               color: klighterColor,
  //                                               thickness: 0.9,
  //                                               endIndent: 20,
  //                                               indent: 20,
  //                                             ),
  //                                             Padding(
  //                                               padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
  //                                               child: Container(
  //                                                 //height: 100,
  //                                                 child: Column(
  //                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                                   children: [
  //                                                     Row(
  //                                                         children: [
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text(
  //                                                             'تم الانتهاء من الوصفة: ',
  //                                                             style: ksubBoldLabelTextStyle,
  //                                                           ),
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('$completed',
  //                                                               style: TextStyle(
  //                                                                 color: Colors.black45,
  //                                                                 fontSize: 15.0,
  //                                                                 fontWeight: FontWeight.bold,
  //                                                               )),
  //                                                         ]
  //                                                     ),
  //                                                     SizedBox(height: 15.0,),
  //                                                     Row(
  //                                                         children: [
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('تم الالتزام بالوصفة: ',
  //                                                               style: ksubBoldLabelTextStyle
  //                                                           ),
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('$committed',
  //                                                               style: TextStyle(
  //                                                                 color: Colors.black45,
  //                                                                 fontSize: 15.0,
  //                                                                 fontWeight: FontWeight.bold,
  //                                                               )),
  //                                                         ]
  //                                                     ),
  //                                                     SizedBox(height: 15.0,),
  //                                                     Row(
  //                                                         children: [
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('الأعراض الجانبية: ',
  //                                                               style: ksubBoldLabelTextStyle
  //                                                           ),
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('$sideEffects',
  //                                                               style: TextStyle(
  //                                                                 color: Colors.black45,
  //                                                                 fontSize: 15.0,
  //                                                                 fontWeight: FontWeight.bold,
  //                                                               )),
  //                                                         ]
  //                                                     ),
  //                                                     SizedBox(height: 15.0,),
  //                                                     Row(
  //                                                         children: [
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('ملاحظات: ',
  //                                                               style: ksubBoldLabelTextStyle
  //                                                           ),
  //                                                           SizedBox(width: 15.0,),
  //                                                           Text('$notes',
  //                                                               style: TextStyle(
  //                                                                 color: Colors.black45,
  //                                                                 fontSize: 15.0,
  //                                                                 fontWeight: FontWeight.bold,
  //                                                               )),
  //                                                         ]
  //                                                     ),
  //                                                     SizedBox(height: 15.0,),
  //                                                     Divider(
  //                                                       color: klighterColor,
  //                                                       thickness: 0.9,
  //                                                       endIndent: 20,
  //                                                       indent: 20,
  //                                                     ),
  //                                                     Padding(
  //                                                       padding: const EdgeInsets.all(8.0),
  //                                                       child: FutureBuilder(
  //                                                           future: FirebaseFirestore.instance
  //                                                               .collection('/Pharmacist')
  //                                                               .doc(pharmacistID)
  //                                                               .get(),
  //                                                           builder: (context, snapshot) {
  //                                                             var me = snapshot.data;
  //                                                             String pharmacistName = me.get('pharmacist-name');
  //                                                             return Row(
  //                                                                 children: [
  //                                                                   SizedBox(width: 15.0,),
  //                                                                   Text('الصيدلي: ',
  //                                                                       style: ksubBoldLabelTextStyle
  //                                                                   ),
  //                                                                   SizedBox(width: 15.0,),
  //                                                                   Text('$pharmacistName',
  //                                                                       style: TextStyle(
  //                                                                         color: Colors.black45,
  //                                                                         fontSize: 15.0,
  //                                                                         fontWeight: FontWeight.bold,
  //                                                                       )),
  //                                                                 ]
  //                                                             );
  //                                                           }
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ]
  //                                       ),
  //                                     );
  //                                   } else {
  //                                     return SizedBox();
  //                                   }
  //                                 }
  //                             );
  //                           }
  //                         }
  //                       );
  //                       }
  //                   );
  //
  //                 }
  //               }
  //           ),
  //         )
  //         // if current user role is pharmacist
  //             : StreamBuilder(
  //                 stream: FirebaseFirestore.instance
  //                     .collection('/Patient')
  //                     .where('pharmacist-uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
  //                     .snapshots(),
  //                 builder: (context, snapshot) {
  //                   print('i am pharmacist');
  //                   print(FirebaseAuth.instance.currentUser.uid);
  //                   if (!snapshot.hasData) {
  //                     return Center( child: CircularProgressIndicator()
  //                     );
  //                   } if (snapshot.data.docs.length == 0) {
  //                     return Center(
  //                       child: Text(
  //                         'ليس لديك أي مرضى حاليا.',
  //                         style: TextStyle(color: Colors.black54, fontSize: 17),
  //                       ),
  //                     );
  //                   } else {
  //                     print(myPatientsIDs);
  //                     // return SizedBox();
  //                     return Flexible(
  //                       child: Container(
  //                         child: ListView.builder(
  //                             itemCount: snapshot.data.docs.length,
  //                             itemBuilder: (context, index) {
  //                               DocumentSnapshot patientDoc = snapshot.data.docs[index];
  //                               String patientID = patientDoc.id;
  //                               //search by
  //                               String patientName = patientDoc.data()['patient-name'];
  //                               return StreamBuilder(
  //                                   stream: FirebaseFirestore.instance
  //                                       .collection('/Patient')
  //                                       .doc(patientID)
  //                                       .collection('Reports')
  //                                       .snapshots(),
  //                                   builder: (context, snapshot) {
  //                                     if(!snapshot.hasData) {
  //                                       return Center( child: CircularProgressIndicator(
  //                                         valueColor: AlwaysStoppedAnimation(Colors.transparent),)
  //                                       );
  //                                     } else {
  //                                       return Flexible(
  //                                         child: Container(
  //                                           child: ListView.builder(
  //                                               itemCount: snapshot.data.docs.length,
  //                                               itemBuilder: (context, index) {
  //                                                 DocumentSnapshot report = snapshot.data.docs[index];
  //                                                 String completed = report.data()['completed'];
  //                                                 String committed = report.data()['committed'];
  //                                                 String sideEffects = report.data()['side effects'].join('\n');
  //                                                 String notes = report.data()['notes'];
  //
  //                                                 String prescriberID = report.data()['prescriper-id'];
  //
  //                                                 //search by
  //                                                 String tradeName = report.data()['tradeName'];
  //
  //                                                 //search logic
  //                                                 if (
  //                                                 patientName
  //                                                     .toLowerCase()
  //                                                     .contains(searchValue.toLowerCase()) ||
  //                                                     patientName
  //                                                         .toUpperCase()
  //                                                         .contains(searchValue.toUpperCase()) ||
  //                                                     tradeName
  //                                                         .toLowerCase()
  //                                                         .contains(searchValue.toLowerCase()) ||
  //                                                     tradeName
  //                                                         .toUpperCase()
  //                                                         .contains(searchValue.toUpperCase())) {
  //
  //                                                   return Card(
  //                                                     shape: RoundedRectangleBorder(
  //                                                       borderRadius: BorderRadius.circular(15.0),
  //                                                     ),
  //                                                     color: kGreyColor,
  //                                                     margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
  //                                                     child: Column(
  //                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                                         children: [
  //                                                           ListTile(
  //                                                             leading: Icon(Icons.assignment_rounded),
  //                                                             title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
  //                                                             subtitle: Text('اسم الدواء: $tradeName '),
  //                                                           ),
  //                                                           Divider(
  //                                                             color: klighterColor,
  //                                                             thickness: 0.9,
  //                                                             endIndent: 20,
  //                                                             indent: 20,
  //                                                           ),
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
  //                                                             child: Container(
  //                                                               //height: 100,
  //                                                               child: Column(
  //                                                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                                                 children: [
  //                                                                   Row(
  //                                                                       children: [
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text(
  //                                                                           'تم الانتهاء من الوصفة: ',
  //                                                                           style: ksubBoldLabelTextStyle,
  //                                                                         ),
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('$completed',
  //                                                                             style: TextStyle(
  //                                                                               color: Colors.black45,
  //                                                                               fontSize: 15.0,
  //                                                                               fontWeight: FontWeight.bold,
  //                                                                             )),
  //                                                                       ]
  //                                                                   ),
  //                                                                   SizedBox(height: 15.0,),
  //                                                                   Row(
  //                                                                       children: [
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('تم الالتزام بالوصفة: ',
  //                                                                             style: ksubBoldLabelTextStyle
  //                                                                         ),
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('$committed',
  //                                                                             style: TextStyle(
  //                                                                               color: Colors.black45,
  //                                                                               fontSize: 15.0,
  //                                                                               fontWeight: FontWeight.bold,
  //                                                                             )),
  //                                                                       ]
  //                                                                   ),
  //                                                                   SizedBox(height: 15.0,),
  //                                                                   Row(
  //                                                                       children: [
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('الأعراض الجانبية: ',
  //                                                                             style: ksubBoldLabelTextStyle
  //                                                                         ),
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('$sideEffects',
  //                                                                             style: TextStyle(
  //                                                                               color: Colors.black45,
  //                                                                               fontSize: 15.0,
  //                                                                               fontWeight: FontWeight.bold,
  //                                                                             )),
  //                                                                       ]
  //                                                                   ),
  //                                                                   SizedBox(height: 15.0,),
  //                                                                   Row(
  //                                                                       children: [
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('ملاحظات: ',
  //                                                                             style: ksubBoldLabelTextStyle
  //                                                                         ),
  //                                                                         SizedBox(width: 15.0,),
  //                                                                         Text('$notes',
  //                                                                             style: TextStyle(
  //                                                                               color: Colors.black45,
  //                                                                               fontSize: 15.0,
  //                                                                               fontWeight: FontWeight.bold,
  //                                                                             )),
  //                                                                       ]
  //                                                                   ),
  //                                                                   SizedBox(height: 15.0,),
  //                                                                   Divider(
  //                                                                     color: klighterColor,
  //                                                                     thickness: 0.9,
  //                                                                     endIndent: 20,
  //                                                                     indent: 20,
  //                                                                   ),
  //                                                                   Padding(
  //                                                                     padding: const EdgeInsets.all(8.0),
  //                                                                     child: FutureBuilder(
  //                                                                         future: FirebaseFirestore.instance
  //                                                                             .collection('/Doctors')
  //                                                                             .doc(prescriberID)
  //                                                                             .get(),
  //                                                                         builder: (context, snapshot) {
  //                                                                           var me = snapshot.data;
  //                                                                           String precriberName = me.get('doctor-name');
  //                                                                           return Row(
  //                                                                               children: [
  //                                                                                 SizedBox(width: 15.0,),
  //                                                                                 Text('الواصف: ',
  //                                                                                     style: ksubBoldLabelTextStyle
  //                                                                                 ),
  //                                                                                 SizedBox(width: 15.0,),
  //                                                                                 Text('$precriberName',
  //                                                                                     style: TextStyle(
  //                                                                                       color: Colors.black45,
  //                                                                                       fontSize: 15.0,
  //                                                                                       fontWeight: FontWeight.bold,
  //                                                                                     )),
  //                                                                               ]
  //                                                                           );
  //                                                                         }
  //                                                                     ),
  //                                                                   )
  //
  //                                                                 ],
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         ]
  //                                                     ),
  //                                                   );
  //                                                 } else {
  //                                                   return SizedBox();
  //                                                 }
  //                                               }
  //                                           ),
  //                                         ),
  //                                       );
  //                                     }
  //                                   }
  //                               );
  //                             }
  //                         ),
  //                       ),
  //                     );
  //
  //                   }
  //                 }
  //             ),
  //
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context){

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
          ),
        ),
        title: Text('تقارير المرضى',
          style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
        ),
      ),
      body:
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/Patient')
                  .where('pharmacist-uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                print('i am pharmacist');
                if (!snapshot.hasData) {
                  return Center( child: CircularProgressIndicator(
                      backgroundColor: kGreyColor,
                      valueColor: AlwaysStoppedAnimation(kBlueColor))
                  );
                } if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text(
                      'ليس لديك أي مرضى حاليا.',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  );
                } else {
                  List myPatientsIDs = [];
                  snapshot.data.docs.forEach((patient){
                    myPatientsIDs.add([patient.id, patient.data()['patient-name']]);
                  });
                  print(myPatientsIDs);
                  // return Container();
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: myPatientsIDs.length,
                        itemBuilder: (context, index) {
                          String patientName = myPatientsIDs[index][1];
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('/Patient')
                                .doc(myPatientsIDs[index][0])
                                .collection('Reports')
                                .snapshots(),
                            builder: (context, snapshot) {
                              print('2nd stream');
                              if (!snapshot.hasData) {
                                return Center(child: LinearProgressIndicator(
                                    backgroundColor: kGreyColor,
                                    valueColor: AlwaysStoppedAnimation(kBlueColor))
                                );
                              }
                              if (snapshot.data.docs.length != 0) {
                                List<ExpansionPanel> myWidgets = [];
                                snapshot.data.docs.forEach((report){
                                  myWidgets.add(
                                    ExpansionPanel(
                                      body: Text('Expansion Panel', style: TextStyle(color: Colors.black))
                                    )
                                      //Text('GF', style: TextStyle(color: Colors.black))
                                  );
                                });
                                return ExpansionPanelList(
                                    children: myWidgets
                                );
                              } else {
                                return SizedBox();
                              }
                            }
                          );
                        }
                    ),
                  );
                  // return ListView.builder(
                  //     itemCount: snapshot.data.docs.length,
                  //     itemBuilder: (context, index) {
                  //       DocumentSnapshot patientDoc = snapshot.data.docs[index];
                  //       String patientID = patientDoc.id;
                  //       //search by
                  //       String patientName = patientDoc.data()['patient-name'];
                  //       return Container();
                  //       // return StreamBuilder(
                  //       //     stream: FirebaseFirestore.instance
                  //       //         .collection('/Patient')
                  //       //         .doc(patientID)
                  //       //         .collection('Reports')
                  //       //         .snapshots(),
                  //       //     builder: (context, snapshot) {
                  //       //       if(!snapshot.hasData) {
                  //       //         return Center( child: CircularProgressIndicator(
                  //       //           valueColor: AlwaysStoppedAnimation(Colors.transparent),)
                  //       //         );
                  //       //       } else {
                  //       //         return Flexible(
                  //       //           child: Container(
                  //       //             child: ListView.builder(
                  //       //                 itemCount: snapshot.data.docs.length,
                  //       //                 itemBuilder: (context, index) {
                  //       //                   DocumentSnapshot report = snapshot.data.docs[index];
                  //       //                   String completed = report.data()['completed'];
                  //       //                   String committed = report.data()['committed'];
                  //       //                   String sideEffects = report.data()['side effects'].join('\n');
                  //       //                   String notes = report.data()['notes'];
                  //       //
                  //       //                   String prescriberID = report.data()['prescriper-id'];
                  //       //
                  //       //                   //search by
                  //       //                   String tradeName = report.data()['tradeName'];
                  //       //
                  //       //                   //search logic
                  //       //                   if (
                  //       //                   patientName
                  //       //                       .toLowerCase()
                  //       //                       .contains(searchValue.toLowerCase()) ||
                  //       //                       patientName
                  //       //                           .toUpperCase()
                  //       //                           .contains(searchValue.toUpperCase()) ||
                  //       //                       tradeName
                  //       //                           .toLowerCase()
                  //       //                           .contains(searchValue.toLowerCase()) ||
                  //       //                       tradeName
                  //       //                           .toUpperCase()
                  //       //                           .contains(searchValue.toUpperCase())) {
                  //       //
                  //       //                     return Card(
                  //       //                       shape: RoundedRectangleBorder(
                  //       //                         borderRadius: BorderRadius.circular(15.0),
                  //       //                       ),
                  //       //                       color: kGreyColor,
                  //       //                       margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  //       //                       child: Column(
                  //       //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       //                           children: [
                  //       //                             ListTile(
                  //       //                               leading: Icon(Icons.assignment_rounded),
                  //       //                               title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
                  //       //                               subtitle: Text('اسم الدواء: $tradeName '),
                  //       //                             ),
                  //       //                             Divider(
                  //       //                               color: klighterColor,
                  //       //                               thickness: 0.9,
                  //       //                               endIndent: 20,
                  //       //                               indent: 20,
                  //       //                             ),
                  //       //                             Padding(
                  //       //                               padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
                  //       //                               child: Container(
                  //       //                                 //height: 100,
                  //       //                                 child: Column(
                  //       //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       //                                   children: [
                  //       //                                     Row(
                  //       //                                         children: [
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text(
                  //       //                                             'تم الانتهاء من الوصفة: ',
                  //       //                                             style: ksubBoldLabelTextStyle,
                  //       //                                           ),
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('$completed',
                  //       //                                               style: TextStyle(
                  //       //                                                 color: Colors.black45,
                  //       //                                                 fontSize: 15.0,
                  //       //                                                 fontWeight: FontWeight.bold,
                  //       //                                               )),
                  //       //                                         ]
                  //       //                                     ),
                  //       //                                     SizedBox(height: 15.0,),
                  //       //                                     Row(
                  //       //                                         children: [
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('تم الالتزام بالوصفة: ',
                  //       //                                               style: ksubBoldLabelTextStyle
                  //       //                                           ),
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('$committed',
                  //       //                                               style: TextStyle(
                  //       //                                                 color: Colors.black45,
                  //       //                                                 fontSize: 15.0,
                  //       //                                                 fontWeight: FontWeight.bold,
                  //       //                                               )),
                  //       //                                         ]
                  //       //                                     ),
                  //       //                                     SizedBox(height: 15.0,),
                  //       //                                     Row(
                  //       //                                         children: [
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('الأعراض الجانبية: ',
                  //       //                                               style: ksubBoldLabelTextStyle
                  //       //                                           ),
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('$sideEffects',
                  //       //                                               style: TextStyle(
                  //       //                                                 color: Colors.black45,
                  //       //                                                 fontSize: 15.0,
                  //       //                                                 fontWeight: FontWeight.bold,
                  //       //                                               )),
                  //       //                                         ]
                  //       //                                     ),
                  //       //                                     SizedBox(height: 15.0,),
                  //       //                                     Row(
                  //       //                                         children: [
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('ملاحظات: ',
                  //       //                                               style: ksubBoldLabelTextStyle
                  //       //                                           ),
                  //       //                                           SizedBox(width: 15.0,),
                  //       //                                           Text('$notes',
                  //       //                                               style: TextStyle(
                  //       //                                                 color: Colors.black45,
                  //       //                                                 fontSize: 15.0,
                  //       //                                                 fontWeight: FontWeight.bold,
                  //       //                                               )),
                  //       //                                         ]
                  //       //                                     ),
                  //       //                                     SizedBox(height: 15.0,),
                  //       //                                     Divider(
                  //       //                                       color: klighterColor,
                  //       //                                       thickness: 0.9,
                  //       //                                       endIndent: 20,
                  //       //                                       indent: 20,
                  //       //                                     ),
                  //       //                                     Padding(
                  //       //                                       padding: const EdgeInsets.all(8.0),
                  //       //                                       child: FutureBuilder(
                  //       //                                           future: FirebaseFirestore.instance
                  //       //                                               .collection('/Doctors')
                  //       //                                               .doc(prescriberID)
                  //       //                                               .get(),
                  //       //                                           builder: (context, snapshot) {
                  //       //                                             var me = snapshot.data;
                  //       //                                             String precriberName = me.get('doctor-name');
                  //       //                                             return Row(
                  //       //                                                 children: [
                  //       //                                                   SizedBox(width: 15.0,),
                  //       //                                                   Text('الواصف: ',
                  //       //                                                       style: ksubBoldLabelTextStyle
                  //       //                                                   ),
                  //       //                                                   SizedBox(width: 15.0,),
                  //       //                                                   Text('$precriberName',
                  //       //                                                       style: TextStyle(
                  //       //                                                         color: Colors.black45,
                  //       //                                                         fontSize: 15.0,
                  //       //                                                         fontWeight: FontWeight.bold,
                  //       //                                                       )),
                  //       //                                                 ]
                  //       //                                             );
                  //       //                                           }
                  //       //                                       ),
                  //       //                                     )
                  //       //
                  //       //                                   ],
                  //       //                                 ),
                  //       //                               ),
                  //       //                             ),
                  //       //                           ]
                  //       //                       ),
                  //       //                     );
                  //       //                   } else {
                  //       //                     return SizedBox();
                  //       //                   }
                  //       //                 }
                  //       //             ),
                  //       //           ),
                  //       //         );
                  //       //       }
                  //       //     }
                  //       // );
                  //     }
                  // );

                }
              }
          ),

          // widget.role == 'doctor'
          // // if current user role is doctor
          //     ? Expanded(
          //   child: StreamBuilder(
          //       stream: FirebaseFirestore.instance
          //           .collection('/Patient')
          //           .where('doctors', arrayContains: FirebaseAuth.instance.currentUser.uid)
          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         print('i am doctor');
          //         print(FirebaseAuth.instance.currentUser.uid);
          //         if (!snapshot.hasData) {
          //           return Center( child: CircularProgressIndicator());
          //         } if (snapshot.data.docs.length == 0) {
          //           return Center(
          //             child: Text(
          //               'ليس لديك أي مرضى حاليا.',
          //               style: TextStyle(color: Colors.black54, fontSize: 17),
          //             ),
          //           );
          //         } else {
          //           print(myPatientsIDs);
          //           // return SizedBox();
          //           return ListView.builder(
          //               itemCount: snapshot.data.docs.length,
          //               itemBuilder: (context, index) {
          //                 DocumentSnapshot patientDoc = snapshot.data.docs[index];
          //                 String patientID = patientDoc.id;
          //                 //search by
          //                 String patientName = patientDoc.data()['patient-name'];
          //                 return StreamBuilder(
          //                     stream: FirebaseFirestore.instance
          //                         .collection('/Patient')
          //                         .doc(patientID)
          //                         .collection('Reports')
          //                         .snapshots(),
          //                     builder: (context, snapshot) {
          //                       if(!snapshot.hasData) {
          //                         return Center( child: CircularProgressIndicator());
          //                       } else {
          //                         return ListView.builder(
          //                             itemCount: snapshot.data.docs.length,
          //                             itemBuilder: (context, index) {
          //                               DocumentSnapshot report = snapshot.data.docs[index];
          //                               String completed = report.data()['completed'];
          //                               String committed = report.data()['committed'];
          //                               String sideEffects = report.data()['side effects'].join('\n');
          //                               String notes = report.data()['notes'];
          //
          //                               String pharmacistID = report.data()['pharmacist-id'];
          //
          //                               //search by
          //                               String tradeName = report.data()['tradeName'];
          //
          //                               //search logic
          //                               if (
          //                               patientName
          //                                   .toLowerCase()
          //                                   .contains(searchValue.toLowerCase()) ||
          //                                   patientName
          //                                       .toUpperCase()
          //                                       .contains(searchValue.toUpperCase()) ||
          //                                   tradeName
          //                                       .toLowerCase()
          //                                       .contains(searchValue.toLowerCase()) ||
          //                                   tradeName
          //                                       .toUpperCase()
          //                                       .contains(searchValue.toUpperCase())) {
          //
          //                                 return Card(
          //                                   shape: RoundedRectangleBorder(
          //                                     borderRadius: BorderRadius.circular(15.0),
          //                                   ),
          //                                   color: kGreyColor,
          //                                   margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          //                                   child: SizedBox(),
          //                                   // Column(
          //                                   //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                                   //     children: [
          //                                   //       ListTile(
          //                                   //         leading: Icon(Icons.assignment_rounded),
          //                                   //         title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
          //                                   //         subtitle: Text('اسم الدواء: $tradeName '),
          //                                   //       ),
          //                                   //       Divider(
          //                                   //         color: klighterColor,
          //                                   //         thickness: 0.9,
          //                                   //         endIndent: 20,
          //                                   //         indent: 20,
          //                                   //       ),
          //                                   //       Padding(
          //                                   //         padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
          //                                   //         child: Container(
          //                                   //           //height: 100,
          //                                   //           child: Column(
          //                                   //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                                   //             children: [
          //                                   //               Row(
          //                                   //                   children: [
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text(
          //                                   //                       'تم الانتهاء من الوصفة: ',
          //                                   //                       style: ksubBoldLabelTextStyle,
          //                                   //                     ),
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('$completed',
          //                                   //                         style: TextStyle(
          //                                   //                           color: Colors.black45,
          //                                   //                           fontSize: 15.0,
          //                                   //                           fontWeight: FontWeight.bold,
          //                                   //                         )),
          //                                   //                   ]
          //                                   //               ),
          //                                   //               SizedBox(height: 15.0,),
          //                                   //               Row(
          //                                   //                   children: [
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('تم الالتزام بالوصفة: ',
          //                                   //                         style: ksubBoldLabelTextStyle
          //                                   //                     ),
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('$committed',
          //                                   //                         style: TextStyle(
          //                                   //                           color: Colors.black45,
          //                                   //                           fontSize: 15.0,
          //                                   //                           fontWeight: FontWeight.bold,
          //                                   //                         )),
          //                                   //                   ]
          //                                   //               ),
          //                                   //               SizedBox(height: 15.0,),
          //                                   //               Row(
          //                                   //                   children: [
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('الأعراض الجانبية: ',
          //                                   //                         style: ksubBoldLabelTextStyle
          //                                   //                     ),
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('$sideEffects',
          //                                   //                         style: TextStyle(
          //                                   //                           color: Colors.black45,
          //                                   //                           fontSize: 15.0,
          //                                   //                           fontWeight: FontWeight.bold,
          //                                   //                         )),
          //                                   //                   ]
          //                                   //               ),
          //                                   //               SizedBox(height: 15.0,),
          //                                   //               Row(
          //                                   //                   children: [
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('ملاحظات: ',
          //                                   //                         style: ksubBoldLabelTextStyle
          //                                   //                     ),
          //                                   //                     SizedBox(width: 15.0,),
          //                                   //                     Text('$notes',
          //                                   //                         style: TextStyle(
          //                                   //                           color: Colors.black45,
          //                                   //                           fontSize: 15.0,
          //                                   //                           fontWeight: FontWeight.bold,
          //                                   //                         )),
          //                                   //                   ]
          //                                   //               ),
          //                                   //               SizedBox(height: 15.0,),
          //                                   //               Divider(
          //                                   //                 color: klighterColor,
          //                                   //                 thickness: 0.9,
          //                                   //                 endIndent: 20,
          //                                   //                 indent: 20,
          //                                   //               ),
          //                                   //               Padding(
          //                                   //                 padding: const EdgeInsets.all(8.0),
          //                                   //                 child: FutureBuilder(
          //                                   //                     future: FirebaseFirestore.instance
          //                                   //                         .collection('/Pharmacist')
          //                                   //                         .doc(pharmacistID)
          //                                   //                         .get(),
          //                                   //                     builder: (context, snapshot) {
          //                                   //                       var me = snapshot.data;
          //                                   //                       String pharmacistName = me.get('pharmacist-name');
          //                                   //                       return Row(
          //                                   //                           children: [
          //                                   //                             SizedBox(width: 15.0,),
          //                                   //                             Text('الصيدلي: ',
          //                                   //                                 style: ksubBoldLabelTextStyle
          //                                   //                             ),
          //                                   //                             SizedBox(width: 15.0,),
          //                                   //                             Text('$pharmacistName',
          //                                   //                                 style: TextStyle(
          //                                   //                                   color: Colors.black45,
          //                                   //                                   fontSize: 15.0,
          //                                   //                                   fontWeight: FontWeight.bold,
          //                                   //                                 )),
          //                                   //                           ]
          //                                   //                       );
          //                                   //                     }
          //                                   //                 ),
          //                                   //               ),
          //                                   //             ],
          //                                   //           ),
          //                                   //         ),
          //                                   //       ),
          //                                   //     ]
          //                                   // ),
          //                                 );
          //                               } else {
          //                                 return SizedBox();
          //                               }
          //                             }
          //                         );
          //                       }
          //                     }
          //                 );
          //               }
          //           );
          //
          //         }
          //       }
          //   ),
          // )
          // // if current user role is pharmacist
          //     : Expanded(
          //       child: StreamBuilder(
          //       stream: FirebaseFirestore.instance
          //           .collection('/Patient')
          //           .where('pharmacist-uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         print('i am pharmacist');
          //         print(FirebaseAuth.instance.currentUser.uid);
          //         if (!snapshot.hasData) {
          //           return Center( child: CircularProgressIndicator()
          //           );
          //         } if (snapshot.data.docs.length == 0) {
          //           return Center(
          //             child: Text(
          //               'ليس لديك أي مرضى حاليا.',
          //               style: TextStyle(color: Colors.black54, fontSize: 17),
          //             ),
          //           );
          //         } else {
          //           print(myPatientsIDs);
          //           // return SizedBox();
          //           return Flexible(
          //             child: Container(
          //               child: ListView.builder(
          //                   itemCount: snapshot.data.docs.length,
          //                   itemBuilder: (context, index) {
          //                     DocumentSnapshot patientDoc = snapshot.data.docs[index];
          //                     String patientID = patientDoc.id;
          //                     //search by
          //                     String patientName = patientDoc.data()['patient-name'];
          //                     return StreamBuilder(
          //                         stream: FirebaseFirestore.instance
          //                             .collection('/Patient')
          //                             .doc(patientID)
          //                             .collection('Reports')
          //                             .snapshots(),
          //                         builder: (context, snapshot) {
          //                           if(!snapshot.hasData) {
          //                             return Center( child: CircularProgressIndicator(
          //                               valueColor: AlwaysStoppedAnimation(Colors.transparent),)
          //                             );
          //                           } else {
          //                             return Flexible(
          //                               child: Container(
          //                                 child: ListView.builder(
          //                                     itemCount: snapshot.data.docs.length,
          //                                     itemBuilder: (context, index) {
          //                                       DocumentSnapshot report = snapshot.data.docs[index];
          //                                       String completed = report.data()['completed'];
          //                                       String committed = report.data()['committed'];
          //                                       String sideEffects = report.data()['side effects'].join('\n');
          //                                       String notes = report.data()['notes'];
          //
          //                                       String prescriberID = report.data()['prescriper-id'];
          //
          //                                       //search by
          //                                       String tradeName = report.data()['tradeName'];
          //
          //                                       //search logic
          //                                       if (
          //                                       patientName
          //                                           .toLowerCase()
          //                                           .contains(searchValue.toLowerCase()) ||
          //                                           patientName
          //                                               .toUpperCase()
          //                                               .contains(searchValue.toUpperCase()) ||
          //                                           tradeName
          //                                               .toLowerCase()
          //                                               .contains(searchValue.toLowerCase()) ||
          //                                           tradeName
          //                                               .toUpperCase()
          //                                               .contains(searchValue.toUpperCase())) {
          //
          //                                         return Card(
          //                                           shape: RoundedRectangleBorder(
          //                                             borderRadius: BorderRadius.circular(15.0),
          //                                           ),
          //                                           color: kGreyColor,
          //                                           margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          //                                           child: Column(
          //                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                                               children: [
          //                                                 ListTile(
          //                                                   leading: Icon(Icons.assignment_rounded),
          //                                                   title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
          //                                                   subtitle: Text('اسم الدواء: $tradeName '),
          //                                                 ),
          //                                                 Divider(
          //                                                   color: klighterColor,
          //                                                   thickness: 0.9,
          //                                                   endIndent: 20,
          //                                                   indent: 20,
          //                                                 ),
          //                                                 Padding(
          //                                                   padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
          //                                                   child: Container(
          //                                                     //height: 100,
          //                                                     child: Column(
          //                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                                                       children: [
          //                                                         Row(
          //                                                             children: [
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text(
          //                                                                 'تم الانتهاء من الوصفة: ',
          //                                                                 style: ksubBoldLabelTextStyle,
          //                                                               ),
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('$completed',
          //                                                                   style: TextStyle(
          //                                                                     color: Colors.black45,
          //                                                                     fontSize: 15.0,
          //                                                                     fontWeight: FontWeight.bold,
          //                                                                   )),
          //                                                             ]
          //                                                         ),
          //                                                         SizedBox(height: 15.0,),
          //                                                         Row(
          //                                                             children: [
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('تم الالتزام بالوصفة: ',
          //                                                                   style: ksubBoldLabelTextStyle
          //                                                               ),
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('$committed',
          //                                                                   style: TextStyle(
          //                                                                     color: Colors.black45,
          //                                                                     fontSize: 15.0,
          //                                                                     fontWeight: FontWeight.bold,
          //                                                                   )),
          //                                                             ]
          //                                                         ),
          //                                                         SizedBox(height: 15.0,),
          //                                                         Row(
          //                                                             children: [
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('الأعراض الجانبية: ',
          //                                                                   style: ksubBoldLabelTextStyle
          //                                                               ),
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('$sideEffects',
          //                                                                   style: TextStyle(
          //                                                                     color: Colors.black45,
          //                                                                     fontSize: 15.0,
          //                                                                     fontWeight: FontWeight.bold,
          //                                                                   )),
          //                                                             ]
          //                                                         ),
          //                                                         SizedBox(height: 15.0,),
          //                                                         Row(
          //                                                             children: [
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('ملاحظات: ',
          //                                                                   style: ksubBoldLabelTextStyle
          //                                                               ),
          //                                                               SizedBox(width: 15.0,),
          //                                                               Text('$notes',
          //                                                                   style: TextStyle(
          //                                                                     color: Colors.black45,
          //                                                                     fontSize: 15.0,
          //                                                                     fontWeight: FontWeight.bold,
          //                                                                   )),
          //                                                             ]
          //                                                         ),
          //                                                         SizedBox(height: 15.0,),
          //                                                         Divider(
          //                                                           color: klighterColor,
          //                                                           thickness: 0.9,
          //                                                           endIndent: 20,
          //                                                           indent: 20,
          //                                                         ),
          //                                                         Padding(
          //                                                           padding: const EdgeInsets.all(8.0),
          //                                                           child: FutureBuilder(
          //                                                               future: FirebaseFirestore.instance
          //                                                                   .collection('/Doctors')
          //                                                                   .doc(prescriberID)
          //                                                                   .get(),
          //                                                               builder: (context, snapshot) {
          //                                                                 var me = snapshot.data;
          //                                                                 String precriberName = me.get('doctor-name');
          //                                                                 return Row(
          //                                                                     children: [
          //                                                                       SizedBox(width: 15.0,),
          //                                                                       Text('الواصف: ',
          //                                                                           style: ksubBoldLabelTextStyle
          //                                                                       ),
          //                                                                       SizedBox(width: 15.0,),
          //                                                                       Text('$precriberName',
          //                                                                           style: TextStyle(
          //                                                                             color: Colors.black45,
          //                                                                             fontSize: 15.0,
          //                                                                             fontWeight: FontWeight.bold,
          //                                                                           )),
          //                                                                     ]
          //                                                                 );
          //                                                               }
          //                                                           ),
          //                                                         )
          //
          //                                                       ],
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                               ]
          //                                           ),
          //                                         );
          //                                       } else {
          //                                         return SizedBox();
          //                                       }
          //                                     }
          //                                 ),
          //                               ),
          //                             );
          //                           }
          //                         }
          //                     );
          //                   }
          //               ),
          //             ),
          //           );
          //
          //         }
          //       }
          // ),
          //     ),


      );

  }

}
