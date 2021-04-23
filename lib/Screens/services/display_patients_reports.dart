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
  Widget build(BuildContext context) {
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
          title: Text(
            'تقاريرjjjjjj المرضى',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              print('ggg');
              return Container(color: Colors.green);
            },
            child: Container(
              color: Colors.black,
            ),
          ),
        ));

    // return Scaffold(
    //   resizeToAvoidBottomPadding: false,
    //   appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     iconTheme: IconThemeData(
    //       color: Colors.grey,
    //     ),
    //     centerTitle: true,
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         bottomRight: Radius.circular(6.0),
    //         bottomLeft: Radius.circular(6.0),
    //       ),
    //     ),
    //     title: Text('تقارير المرضى',
    //       style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
    //     ),
    //   ),
    //   body:
    //       StreamBuilder(
    //           stream: FirebaseFirestore.instance
    //               .collection('/Patient')
    //               .where('pharmacist-uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
    //               .snapshots(),
    //           builder: (context, snapshot) {
    //             if (!snapshot.hasData) {
    //               return Center( child: CircularProgressIndicator(
    //                   backgroundColor: kGreyColor,
    //                   valueColor: AlwaysStoppedAnimation(kBlueColor))
    //               );
    //             } if (snapshot.data.docs.length == 0) {
    //               return Center(
    //                 child: Text(
    //                   'ليس لديك أي مرضى حاليا.',
    //                   style: TextStyle(color: Colors.black54, fontSize: 17),
    //                 ),
    //               );
    //             } else {
    //               List myPatientsIDs = [];
    //               snapshot.data.docs.forEach((patient){
    //                 myPatientsIDs.add(patient.id);
    //                 // myPatientsIDs.add([patient.id, patient.data()['patient-name']]);
    //               });
    //
    //               List reportsDocs = [];
    //               List myPatientsReports = [];
    //               myPatientsIDs.forEach((patientID) async {
    //                 var patientQuery = await FirebaseFirestore.instance
    //                     .collection('/Patient')
    //                     .doc(patientID)
    //                     .get();
    //                 var patientName = patientQuery.get('patient-name');
    //
    //
    //                 var reportQuery = await FirebaseFirestore.instance
    //                     .collection('/Patient')
    //                     .doc(patientID)
    //                     .collection('Reports')
    //                     .get();
    //                 reportsDocs = reportQuery.docs;
    //
    //                 //myPatientsReports1st = myPatientsReports;
    //
    //                 //print(myPatientsReports);
    //               });
    //               reportsDocs.forEach((report) async {
    //                 myPatientsReports.add(
    //                     [
    //                       //patientName, //0
    //                       2,46,6,7,9
    //                     ]
    //                 );
    //               });
    //               reportsDocs.forEach((report) async {
    //                 myPatientsReports.add(
    //                     [
    //                       //patientName, //0
    //                       report.data()['tradeName'], //1
    //
    //                       report.data()['completed'], //2
    //                       report.data()['committed'], //3
    //                       [report.data()['side effects'].join('\n')], //4
    //                       report.data()['notes'], //5
    //
    //                       report.data()['prescriper-id'], //6
    //                       report.data()['pharmacist-id'], //7
    //                     ]
    //                 );
    //               });
    //
    //
    //               //print(test);
    //               print(myPatientsReports);
    //               print('nooooo');
    //
    //               return ListView.builder(
    //                   itemCount: myPatientsReports.length,
    //                   itemBuilder: (context, index) {
    //                     print('yess');
    //                     String patientName = myPatientsReports[index][0];
    //                     String tradeName = myPatientsReports[index][01];
    //
    //                     String completed = myPatientsReports[index][2];
    //                     String committed = myPatientsReports[index][3];
    //                     String sideEffects = myPatientsReports[index][4];
    //                     String notes = myPatientsReports[index][5];
    //
    //                     String prescriberID = myPatientsReports[index][6];
    //                     //String pharmacistID = myPatientsReports1st[index][7];
    //
    //
    //                     return Card(
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                       ),
    //                       color: kGreyColor,
    //                       margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
    //                       child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                           children: [
    //                             ListTile(
    //                               leading: Icon(Icons.assignment_rounded),
    //                               title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
    //                               subtitle: Text('اسم الدواء: $tradeName '),
    //                             ),
    //                             Divider(
    //                               color: klighterColor,
    //                               thickness: 0.9,
    //                               endIndent: 20,
    //                               indent: 20,
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
    //                               child: Container(
    //                                 //height: 100,
    //                                 child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                                   children: [
    //                                     Row(
    //                                         children: [
    //                                           SizedBox(width: 15.0,),
    //                                           Text(
    //                                             'تم الانتهاء من الوصفة: ',
    //                                             style: ksubBoldLabelTextStyle,
    //                                           ),
    //                                           SizedBox(width: 15.0,),
    //                                           Text('$completed',
    //                                               style: TextStyle(
    //                                                 color: Colors.black45,
    //                                                 fontSize: 15.0,
    //                                                 fontWeight: FontWeight.bold,
    //                                               )),
    //                                         ]
    //                                     ),
    //                                     SizedBox(height: 15.0,),
    //                                     Row(
    //                                         children: [
    //                                           SizedBox(width: 15.0,),
    //                                           Text('تم الالتزام بالوصفة: ',
    //                                               style: ksubBoldLabelTextStyle
    //                                           ),
    //                                           SizedBox(width: 15.0,),
    //                                           Text('$committed',
    //                                               style: TextStyle(
    //                                                 color: Colors.black45,
    //                                                 fontSize: 15.0,
    //                                                 fontWeight: FontWeight.bold,
    //                                               )),
    //                                         ]
    //                                     ),
    //                                     SizedBox(height: 15.0,),
    //                                     Row(
    //                                         children: [
    //                                           SizedBox(width: 15.0,),
    //                                           Text('الأعراض الجانبية: ',
    //                                               style: ksubBoldLabelTextStyle
    //                                           ),
    //                                           SizedBox(width: 15.0,),
    //                                           Text('$sideEffects',
    //                                               style: TextStyle(
    //                                                 color: Colors.black45,
    //                                                 fontSize: 15.0,
    //                                                 fontWeight: FontWeight.bold,
    //                                               )),
    //                                         ]
    //                                     ),
    //                                     SizedBox(height: 15.0,),
    //                                     Row(
    //                                         children: [
    //                                           SizedBox(width: 15.0,),
    //                                           Text('ملاحظات: ',
    //                                               style: ksubBoldLabelTextStyle
    //                                           ),
    //                                           SizedBox(width: 15.0,),
    //                                           Text('$notes',
    //                                               style: TextStyle(
    //                                                 color: Colors.black45,
    //                                                 fontSize: 15.0,
    //                                                 fontWeight: FontWeight.bold,
    //                                               )),
    //                                         ]
    //                                     ),
    //                                     SizedBox(height: 15.0,),
    //                                     Divider(
    //                                       color: klighterColor,
    //                                       thickness: 0.9,
    //                                       endIndent: 20,
    //                                       indent: 20,
    //                                     ),
    //                                     // Padding(
    //                                     //   padding: const EdgeInsets.all(8.0),
    //                                     //   child: FutureBuilder(
    //                                     //       future: FirebaseFirestore.instance
    //                                     //           .collection('/Doctors')
    //                                     //           .doc(prescriberID)
    //                                     //           .get(),
    //                                     //       builder: (context, snapshot) {
    //                                     //         var me = snapshot.data;
    //                                     //         String precriberName = me.get('doctor-name');
    //                                     //         return Row(
    //                                     //             children: [
    //                                     //               SizedBox(width: 15.0,),
    //                                     //               Text('الواصف: ',
    //                                     //                   style: ksubBoldLabelTextStyle
    //                                     //               ),
    //                                     //               SizedBox(width: 15.0,),
    //                                     //               Text('$precriberName',
    //                                     //                   style: TextStyle(
    //                                     //                     color: Colors.black45,
    //                                     //                     fontSize: 15.0,
    //                                     //                     fontWeight: FontWeight.bold,
    //                                     //                   )),
    //                                     //             ]
    //                                     //         );
    //                                     //       }
    //                                     //   ),
    //                                     // )
    //                                     FutureBuilder(
    //                                         future: FirebaseFirestore.instance
    //                                             .collection('/Doctors')
    //                                             .doc(prescriberID)
    //                                             .get(),
    //                                         builder: (context, snapshot) {
    //                                           if (!snapshot.hasData) {
    //                                             return Center(
    //                                                 child: CircularProgressIndicator(
    //                                                     backgroundColor:
    //                                                     Colors.transparent,
    //                                                     valueColor:
    //                                                     AlwaysStoppedAnimation(
    //                                                         Colors
    //                                                             .transparent)));
    //                                           }
    //                                           DocumentSnapshot doc =
    //                                               snapshot.data;
    //                                           String doctorName =
    //                                           doc.data()['doctor-name'];
    //                                           String tempDoctorSpeciality =
    //                                           doc.data()['speciality'];
    //                                           String doctorSpeciality;
    //                                           String experienceYears = doc
    //                                               .data()['experience-years'];
    //                                           String doctorPhoneNumber =
    //                                           doc.data()['phone-number'];
    //
    //                                           if (tempDoctorSpeciality ==
    //                                               'طبيب قلب') {
    //                                             doctorSpeciality =
    //                                             'cardiologist';
    //                                           } else if (tempDoctorSpeciality ==
    //                                               'طبيب باطنية') {
    //                                             doctorSpeciality =
    //                                             'Internal medicine physicians';
    //                                           } else if (tempDoctorSpeciality ==
    //                                               'طبيب أسرة') {
    //                                             doctorSpeciality =
    //                                             'family physician';
    //                                           } else {
    //                                             doctorSpeciality =
    //                                             'Psychologist';
    //                                           }
    //
    //                                           return Row(
    //                                             mainAxisAlignment:
    //                                             MainAxisAlignment
    //                                                 .spaceBetween,
    //                                             children: [
    //                                               Row(
    //                                                 children: [
    //                                                   Text(
    //                                                     'الواصف',
    //                                                     style:
    //                                                     ksubBoldLabelTextStyle,
    //                                                   ),
    //                                                   SizedBox(
    //                                                     width: 15.0,
    //                                                   ),
    //                                                   Text(
    //                                                     'د.  $doctorName',
    //                                                     style: TextStyle(
    //                                                       color: Colors.black45,
    //                                                       fontSize: 15.0,
    //                                                       fontWeight:
    //                                                       FontWeight.bold,
    //                                                     ),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                               Padding(
    //                                                 padding:
    //                                                 const EdgeInsets.only(
    //                                                     left: 20),
    //                                                 child: IconButton(
    //                                                   icon: Icon(
    //                                                       Icons.info_outline),
    //                                                   onPressed: () {
    //                                                     showModalBottomSheet(
    //                                                         context: context,
    //                                                         builder: (context) {
    //                                                           return Container(
    //                                                             height: 200,
    //                                                             child: Card(
    //                                                               shape:
    //                                                               RoundedRectangleBorder(
    //                                                                 borderRadius:
    //                                                                 BorderRadius.circular(
    //                                                                     15.0),
    //                                                               ),
    //                                                               color:
    //                                                               kGreyColor,
    //                                                               child: Column(
    //                                                                 children: [
    //                                                                   ListTile(
    //                                                                     title:
    //                                                                     Text(
    //                                                                       'معلومات عن الطبيب',
    //                                                                       textAlign:
    //                                                                       TextAlign.center,
    //                                                                       style:
    //                                                                       kBoldLabelTextStyle,
    //                                                                     ),
    //                                                                   ),
    //                                                                   Divider(
    //                                                                     color:
    //                                                                     klighterColor,
    //                                                                     thickness:
    //                                                                     0.9,
    //                                                                     endIndent:
    //                                                                     20,
    //                                                                     indent:
    //                                                                     20,
    //                                                                   ),
    //                                                                   Padding(
    //                                                                     padding:
    //                                                                     const EdgeInsets.all(15.0),
    //                                                                     child:
    //                                                                     Container(
    //                                                                       child:
    //                                                                       Column(
    //                                                                         children: [
    //                                                                           Row(
    //                                                                             children: [
    //                                                                               Text(
    //                                                                                 'اسم الطبيب:',
    //                                                                                 style: ksubBoldLabelTextStyle,
    //                                                                               ),
    //                                                                               SizedBox(
    //                                                                                 width: 47.0,
    //                                                                               ),
    //                                                                               Text(
    //                                                                                 'د.  $doctorName',
    //                                                                                 style: TextStyle(
    //                                                                                   color: Colors.black45,
    //                                                                                   fontSize: 15.0,
    //                                                                                   fontWeight: FontWeight.bold,
    //                                                                                 ),
    //                                                                               ),
    //                                                                             ],
    //                                                                           ),
    //                                                                           Row(
    //                                                                             children: [
    //                                                                               Text(
    //                                                                                 'عدد سنين الخبرة:',
    //                                                                                 style: ksubBoldLabelTextStyle,
    //                                                                               ),
    //                                                                               SizedBox(
    //                                                                                 width: 15.0,
    //                                                                               ),
    //                                                                               Text(
    //                                                                                 '$experienceYears',
    //                                                                                 style: TextStyle(
    //                                                                                   color: Colors.black45,
    //                                                                                   fontSize: 15.0,
    //                                                                                   fontWeight: FontWeight.bold,
    //                                                                                 ),
    //                                                                               ),
    //                                                                             ],
    //                                                                           ),
    //                                                                           Row(
    //                                                                             children: [
    //                                                                               Text(
    //                                                                                 'مجال الإختصاص:',
    //                                                                                 style: ksubBoldLabelTextStyle,
    //                                                                               ),
    //                                                                               SizedBox(
    //                                                                                 width: 15.0,
    //                                                                               ),
    //                                                                               Text(
    //                                                                                 '$doctorSpeciality',
    //                                                                                 style: TextStyle(
    //                                                                                   color: Colors.black45,
    //                                                                                   fontSize: 15.0,
    //                                                                                   fontWeight: FontWeight.bold,
    //                                                                                 ),
    //                                                                               ),
    //                                                                             ],
    //                                                                           ),
    //                                                                           Row(
    //                                                                             children: [
    //                                                                               Text(
    //                                                                                 'رقم الهاتف:',
    //                                                                                 style: ksubBoldLabelTextStyle,
    //                                                                               ),
    //                                                                               SizedBox(
    //                                                                                 width: 54.0,
    //                                                                               ),
    //                                                                               Text(
    //                                                                                 '$doctorPhoneNumber',
    //                                                                                 style: TextStyle(
    //                                                                                   color: Colors.black45,
    //                                                                                   fontSize: 15.0,
    //                                                                                   fontWeight: FontWeight.bold,
    //                                                                                 ),
    //                                                                               ),
    //                                                                             ],
    //                                                                           ),
    //                                                                         ],
    //                                                                       ),
    //                                                                     ),
    //                                                                   ),
    //                                                                 ],
    //                                                               ),
    //                                                             ),
    //                                                           );
    //                                                         });
    //                                                   },
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           );
    //                                         }),
    //                                     SizedBox(
    //                                       height: 10,
    //                                     ),
    //
    //
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ]
    //                       ),
    //                     );
    //                   }
    //               );
    //               // return ListView.builder(
    //               //     itemCount: snapshot.data.docs.length,
    //               //     itemBuilder: (context, index) {
    //               //       DocumentSnapshot patientDoc = snapshot.data.docs[index];
    //               //       String patientID = patientDoc.id;
    //               //       //search by
    //               //       String patientName = patientDoc.data()['patient-name'];
    //               //       return Container();
    //               //       // return StreamBuilder(
    //               //       //     stream: FirebaseFirestore.instance
    //               //       //         .collection('/Patient')
    //               //       //         .doc(patientID)
    //               //       //         .collection('Reports')
    //               //       //         .snapshots(),
    //               //       //     builder: (context, snapshot) {
    //               //       //       if(!snapshot.hasData) {
    //               //       //         return Center( child: CircularProgressIndicator(
    //               //       //           valueColor: AlwaysStoppedAnimation(Colors.transparent),)
    //               //       //         );
    //               //       //       } else {
    //               //       //         return Flexible(
    //               //       //           child: Container(
    //               //       //             child: ListView.builder(
    //               //       //                 itemCount: snapshot.data.docs.length,
    //               //       //                 itemBuilder: (context, index) {
    //               //       //                   DocumentSnapshot report = snapshot.data.docs[index];
    //               //       //                   String completed = report.data()['completed'];
    //               //       //                   String committed = report.data()['committed'];
    //               //       //                   String sideEffects = report.data()['side effects'].join('\n');
    //               //       //                   String notes = report.data()['notes'];
    //               //       //
    //               //       //                   String prescriberID = report.data()['prescriper-id'];
    //               //       //
    //               //       //                   //search by
    //               //       //                   String tradeName = report.data()['tradeName'];
    //               //       //
    //               //       //                   //search logic
    //               //       //                   if (
    //               //       //                   patientName
    //               //       //                       .toLowerCase()
    //               //       //                       .contains(searchValue.toLowerCase()) ||
    //               //       //                       patientName
    //               //       //                           .toUpperCase()
    //               //       //                           .contains(searchValue.toUpperCase()) ||
    //               //       //                       tradeName
    //               //       //                           .toLowerCase()
    //               //       //                           .contains(searchValue.toLowerCase()) ||
    //               //       //                       tradeName
    //               //       //                           .toUpperCase()
    //               //       //                           .contains(searchValue.toUpperCase())) {
    //               //       //
    //               //       //                     return Card(
    //               //       //                       shape: RoundedRectangleBorder(
    //               //       //                         borderRadius: BorderRadius.circular(15.0),
    //               //       //                       ),
    //               //       //                       color: kGreyColor,
    //               //       //                       margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
    //               //       //                       child: Column(
    //               //       //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               //       //                           children: [
    //               //       //                             ListTile(
    //               //       //                               leading: Icon(Icons.assignment_rounded),
    //               //       //                               title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
    //               //       //                               subtitle: Text('اسم الدواء: $tradeName '),
    //               //       //                             ),
    //               //       //                             Divider(
    //               //       //                               color: klighterColor,
    //               //       //                               thickness: 0.9,
    //               //       //                               endIndent: 20,
    //               //       //                               indent: 20,
    //               //       //                             ),
    //               //       //                             Padding(
    //               //       //                               padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
    //               //       //                               child: Container(
    //               //       //                                 //height: 100,
    //               //       //                                 child: Column(
    //               //       //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               //       //                                   children: [
    //               //       //                                     Row(
    //               //       //                                         children: [
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text(
    //               //       //                                             'تم الانتهاء من الوصفة: ',
    //               //       //                                             style: ksubBoldLabelTextStyle,
    //               //       //                                           ),
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('$completed',
    //               //       //                                               style: TextStyle(
    //               //       //                                                 color: Colors.black45,
    //               //       //                                                 fontSize: 15.0,
    //               //       //                                                 fontWeight: FontWeight.bold,
    //               //       //                                               )),
    //               //       //                                         ]
    //               //       //                                     ),
    //               //       //                                     SizedBox(height: 15.0,),
    //               //       //                                     Row(
    //               //       //                                         children: [
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('تم الالتزام بالوصفة: ',
    //               //       //                                               style: ksubBoldLabelTextStyle
    //               //       //                                           ),
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('$committed',
    //               //       //                                               style: TextStyle(
    //               //       //                                                 color: Colors.black45,
    //               //       //                                                 fontSize: 15.0,
    //               //       //                                                 fontWeight: FontWeight.bold,
    //               //       //                                               )),
    //               //       //                                         ]
    //               //       //                                     ),
    //               //       //                                     SizedBox(height: 15.0,),
    //               //       //                                     Row(
    //               //       //                                         children: [
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('الأعراض الجانبية: ',
    //               //       //                                               style: ksubBoldLabelTextStyle
    //               //       //                                           ),
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('$sideEffects',
    //               //       //                                               style: TextStyle(
    //               //       //                                                 color: Colors.black45,
    //               //       //                                                 fontSize: 15.0,
    //               //       //                                                 fontWeight: FontWeight.bold,
    //               //       //                                               )),
    //               //       //                                         ]
    //               //       //                                     ),
    //               //       //                                     SizedBox(height: 15.0,),
    //               //       //                                     Row(
    //               //       //                                         children: [
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('ملاحظات: ',
    //               //       //                                               style: ksubBoldLabelTextStyle
    //               //       //                                           ),
    //               //       //                                           SizedBox(width: 15.0,),
    //               //       //                                           Text('$notes',
    //               //       //                                               style: TextStyle(
    //               //       //                                                 color: Colors.black45,
    //               //       //                                                 fontSize: 15.0,
    //               //       //                                                 fontWeight: FontWeight.bold,
    //               //       //                                               )),
    //               //       //                                         ]
    //               //       //                                     ),
    //               //       //                                     SizedBox(height: 15.0,),
    //               //       //                                     Divider(
    //               //       //                                       color: klighterColor,
    //               //       //                                       thickness: 0.9,
    //               //       //                                       endIndent: 20,
    //               //       //                                       indent: 20,
    //               //       //                                     ),
    //               //       //                                     Padding(
    //               //       //                                       padding: const EdgeInsets.all(8.0),
    //               //       //                                       child: FutureBuilder(
    //               //       //                                           future: FirebaseFirestore.instance
    //               //       //                                               .collection('/Doctors')
    //               //       //                                               .doc(prescriberID)
    //               //       //                                               .get(),
    //               //       //                                           builder: (context, snapshot) {
    //               //       //                                             var me = snapshot.data;
    //               //       //                                             String precriberName = me.get('doctor-name');
    //               //       //                                             return Row(
    //               //       //                                                 children: [
    //               //       //                                                   SizedBox(width: 15.0,),
    //               //       //                                                   Text('الواصف: ',
    //               //       //                                                       style: ksubBoldLabelTextStyle
    //               //       //                                                   ),
    //               //       //                                                   SizedBox(width: 15.0,),
    //               //       //                                                   Text('$precriberName',
    //               //       //                                                       style: TextStyle(
    //               //       //                                                         color: Colors.black45,
    //               //       //                                                         fontSize: 15.0,
    //               //       //                                                         fontWeight: FontWeight.bold,
    //               //       //                                                       )),
    //               //       //                                                 ]
    //               //       //                                             );
    //               //       //                                           }
    //               //       //                                       ),
    //               //       //                                     )
    //               //       //
    //               //       //                                   ],
    //               //       //                                 ),
    //               //       //                               ),
    //               //       //                             ),
    //               //       //                           ]
    //               //       //                       ),
    //               //       //                     );
    //               //       //                   } else {
    //               //       //                     return SizedBox();
    //               //       //                   }
    //               //       //                 }
    //               //       //             ),
    //               //       //           ),
    //               //       //         );
    //               //       //       }
    //               //       //     }
    //               //       // );
    //               //     }
    //               // );
    //
    //             }
    //           }
    //       ),
    //
    //       // widget.role == 'doctor'
    //       // // if current user role is doctor
    //       //     ? Expanded(
    //       //   child: StreamBuilder(
    //       //       stream: FirebaseFirestore.instance
    //       //           .collection('/Patient')
    //       //           .where('doctors', arrayContains: FirebaseAuth.instance.currentUser.uid)
    //       //           .snapshots(),
    //       //       builder: (context, snapshot) {
    //       //         print('i am doctor');
    //       //         print(FirebaseAuth.instance.currentUser.uid);
    //       //         if (!snapshot.hasData) {
    //       //           return Center( child: CircularProgressIndicator());
    //       //         } if (snapshot.data.docs.length == 0) {
    //       //           return Center(
    //       //             child: Text(
    //       //               'ليس لديك أي مرضى حاليا.',
    //       //               style: TextStyle(color: Colors.black54, fontSize: 17),
    //       //             ),
    //       //           );
    //       //         } else {
    //       //           print(myPatientsIDs);
    //       //           // return SizedBox();
    //       //           return ListView.builder(
    //       //               itemCount: snapshot.data.docs.length,
    //       //               itemBuilder: (context, index) {
    //       //                 DocumentSnapshot patientDoc = snapshot.data.docs[index];
    //       //                 String patientID = patientDoc.id;
    //       //                 //search by
    //       //                 String patientName = patientDoc.data()['patient-name'];
    //       //                 return StreamBuilder(
    //       //                     stream: FirebaseFirestore.instance
    //       //                         .collection('/Patient')
    //       //                         .doc(patientID)
    //       //                         .collection('Reports')
    //       //                         .snapshots(),
    //       //                     builder: (context, snapshot) {
    //       //                       if(!snapshot.hasData) {
    //       //                         return Center( child: CircularProgressIndicator());
    //       //                       } else {
    //       //                         return ListView.builder(
    //       //                             itemCount: snapshot.data.docs.length,
    //       //                             itemBuilder: (context, index) {
    //       //                               DocumentSnapshot report = snapshot.data.docs[index];
    //       //                               String completed = report.data()['completed'];
    //       //                               String committed = report.data()['committed'];
    //       //                               String sideEffects = report.data()['side effects'].join('\n');
    //       //                               String notes = report.data()['notes'];
    //       //
    //       //                               String pharmacistID = report.data()['pharmacist-id'];
    //       //
    //       //                               //search by
    //       //                               String tradeName = report.data()['tradeName'];
    //       //
    //       //                               //search logic
    //       //                               if (
    //       //                               patientName
    //       //                                   .toLowerCase()
    //       //                                   .contains(searchValue.toLowerCase()) ||
    //       //                                   patientName
    //       //                                       .toUpperCase()
    //       //                                       .contains(searchValue.toUpperCase()) ||
    //       //                                   tradeName
    //       //                                       .toLowerCase()
    //       //                                       .contains(searchValue.toLowerCase()) ||
    //       //                                   tradeName
    //       //                                       .toUpperCase()
    //       //                                       .contains(searchValue.toUpperCase())) {
    //       //
    //       //                                 return Card(
    //       //                                   shape: RoundedRectangleBorder(
    //       //                                     borderRadius: BorderRadius.circular(15.0),
    //       //                                   ),
    //       //                                   color: kGreyColor,
    //       //                                   margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
    //       //                                   child: SizedBox(),
    //       //                                   // Column(
    //       //                                   //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       //                                   //     children: [
    //       //                                   //       ListTile(
    //       //                                   //         leading: Icon(Icons.assignment_rounded),
    //       //                                   //         title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
    //       //                                   //         subtitle: Text('اسم الدواء: $tradeName '),
    //       //                                   //       ),
    //       //                                   //       Divider(
    //       //                                   //         color: klighterColor,
    //       //                                   //         thickness: 0.9,
    //       //                                   //         endIndent: 20,
    //       //                                   //         indent: 20,
    //       //                                   //       ),
    //       //                                   //       Padding(
    //       //                                   //         padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
    //       //                                   //         child: Container(
    //       //                                   //           //height: 100,
    //       //                                   //           child: Column(
    //       //                                   //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       //                                   //             children: [
    //       //                                   //               Row(
    //       //                                   //                   children: [
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text(
    //       //                                   //                       'تم الانتهاء من الوصفة: ',
    //       //                                   //                       style: ksubBoldLabelTextStyle,
    //       //                                   //                     ),
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('$completed',
    //       //                                   //                         style: TextStyle(
    //       //                                   //                           color: Colors.black45,
    //       //                                   //                           fontSize: 15.0,
    //       //                                   //                           fontWeight: FontWeight.bold,
    //       //                                   //                         )),
    //       //                                   //                   ]
    //       //                                   //               ),
    //       //                                   //               SizedBox(height: 15.0,),
    //       //                                   //               Row(
    //       //                                   //                   children: [
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('تم الالتزام بالوصفة: ',
    //       //                                   //                         style: ksubBoldLabelTextStyle
    //       //                                   //                     ),
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('$committed',
    //       //                                   //                         style: TextStyle(
    //       //                                   //                           color: Colors.black45,
    //       //                                   //                           fontSize: 15.0,
    //       //                                   //                           fontWeight: FontWeight.bold,
    //       //                                   //                         )),
    //       //                                   //                   ]
    //       //                                   //               ),
    //       //                                   //               SizedBox(height: 15.0,),
    //       //                                   //               Row(
    //       //                                   //                   children: [
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('الأعراض الجانبية: ',
    //       //                                   //                         style: ksubBoldLabelTextStyle
    //       //                                   //                     ),
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('$sideEffects',
    //       //                                   //                         style: TextStyle(
    //       //                                   //                           color: Colors.black45,
    //       //                                   //                           fontSize: 15.0,
    //       //                                   //                           fontWeight: FontWeight.bold,
    //       //                                   //                         )),
    //       //                                   //                   ]
    //       //                                   //               ),
    //       //                                   //               SizedBox(height: 15.0,),
    //       //                                   //               Row(
    //       //                                   //                   children: [
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('ملاحظات: ',
    //       //                                   //                         style: ksubBoldLabelTextStyle
    //       //                                   //                     ),
    //       //                                   //                     SizedBox(width: 15.0,),
    //       //                                   //                     Text('$notes',
    //       //                                   //                         style: TextStyle(
    //       //                                   //                           color: Colors.black45,
    //       //                                   //                           fontSize: 15.0,
    //       //                                   //                           fontWeight: FontWeight.bold,
    //       //                                   //                         )),
    //       //                                   //                   ]
    //       //                                   //               ),
    //       //                                   //               SizedBox(height: 15.0,),
    //       //                                   //               Divider(
    //       //                                   //                 color: klighterColor,
    //       //                                   //                 thickness: 0.9,
    //       //                                   //                 endIndent: 20,
    //       //                                   //                 indent: 20,
    //       //                                   //               ),
    //       //                                   //               Padding(
    //       //                                   //                 padding: const EdgeInsets.all(8.0),
    //       //                                   //                 child: FutureBuilder(
    //       //                                   //                     future: FirebaseFirestore.instance
    //       //                                   //                         .collection('/Pharmacist')
    //       //                                   //                         .doc(pharmacistID)
    //       //                                   //                         .get(),
    //       //                                   //                     builder: (context, snapshot) {
    //       //                                   //                       var me = snapshot.data;
    //       //                                   //                       String pharmacistName = me.get('pharmacist-name');
    //       //                                   //                       return Row(
    //       //                                   //                           children: [
    //       //                                   //                             SizedBox(width: 15.0,),
    //       //                                   //                             Text('الصيدلي: ',
    //       //                                   //                                 style: ksubBoldLabelTextStyle
    //       //                                   //                             ),
    //       //                                   //                             SizedBox(width: 15.0,),
    //       //                                   //                             Text('$pharmacistName',
    //       //                                   //                                 style: TextStyle(
    //       //                                   //                                   color: Colors.black45,
    //       //                                   //                                   fontSize: 15.0,
    //       //                                   //                                   fontWeight: FontWeight.bold,
    //       //                                   //                                 )),
    //       //                                   //                           ]
    //       //                                   //                       );
    //       //                                   //                     }
    //       //                                   //                 ),
    //       //                                   //               ),
    //       //                                   //             ],
    //       //                                   //           ),
    //       //                                   //         ),
    //       //                                   //       ),
    //       //                                   //     ]
    //       //                                   // ),
    //       //                                 );
    //       //                               } else {
    //       //                                 return SizedBox();
    //       //                               }
    //       //                             }
    //       //                         );
    //       //                       }
    //       //                     }
    //       //                 );
    //       //               }
    //       //           );
    //       //
    //       //         }
    //       //       }
    //       //   ),
    //       // )
    //       // // if current user role is pharmacist
    //       //     : Expanded(
    //       //       child: StreamBuilder(
    //       //       stream: FirebaseFirestore.instance
    //       //           .collection('/Patient')
    //       //           .where('pharmacist-uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
    //       //           .snapshots(),
    //       //       builder: (context, snapshot) {
    //       //         print('i am pharmacist');
    //       //         print(FirebaseAuth.instance.currentUser.uid);
    //       //         if (!snapshot.hasData) {
    //       //           return Center( child: CircularProgressIndicator()
    //       //           );
    //       //         } if (snapshot.data.docs.length == 0) {
    //       //           return Center(
    //       //             child: Text(
    //       //               'ليس لديك أي مرضى حاليا.',
    //       //               style: TextStyle(color: Colors.black54, fontSize: 17),
    //       //             ),
    //       //           );
    //       //         } else {
    //       //           print(myPatientsIDs);
    //       //           // return SizedBox();
    //       //           return Flexible(
    //       //             child: Container(
    //       //               child: ListView.builder(
    //       //                   itemCount: snapshot.data.docs.length,
    //       //                   itemBuilder: (context, index) {
    //       //                     DocumentSnapshot patientDoc = snapshot.data.docs[index];
    //       //                     String patientID = patientDoc.id;
    //       //                     //search by
    //       //                     String patientName = patientDoc.data()['patient-name'];
    //       //                     return StreamBuilder(
    //       //                         stream: FirebaseFirestore.instance
    //       //                             .collection('/Patient')
    //       //                             .doc(patientID)
    //       //                             .collection('Reports')
    //       //                             .snapshots(),
    //       //                         builder: (context, snapshot) {
    //       //                           if(!snapshot.hasData) {
    //       //                             return Center( child: CircularProgressIndicator(
    //       //                               valueColor: AlwaysStoppedAnimation(Colors.transparent),)
    //       //                             );
    //       //                           } else {
    //       //                             return Flexible(
    //       //                               child: Container(
    //       //                                 child: ListView.builder(
    //       //                                     itemCount: snapshot.data.docs.length,
    //       //                                     itemBuilder: (context, index) {
    //       //                                       DocumentSnapshot report = snapshot.data.docs[index];
    //       //                                       String completed = report.data()['completed'];
    //       //                                       String committed = report.data()['committed'];
    //       //                                       String sideEffects = report.data()['side effects'].join('\n');
    //       //                                       String notes = report.data()['notes'];
    //       //
    //       //                                       String prescriberID = report.data()['prescriper-id'];
    //       //
    //       //                                       //search by
    //       //                                       String tradeName = report.data()['tradeName'];
    //       //
    //       //                                       //search logic
    //       //                                       if (
    //       //                                       patientName
    //       //                                           .toLowerCase()
    //       //                                           .contains(searchValue.toLowerCase()) ||
    //       //                                           patientName
    //       //                                               .toUpperCase()
    //       //                                               .contains(searchValue.toUpperCase()) ||
    //       //                                           tradeName
    //       //                                               .toLowerCase()
    //       //                                               .contains(searchValue.toLowerCase()) ||
    //       //                                           tradeName
    //       //                                               .toUpperCase()
    //       //                                               .contains(searchValue.toUpperCase())) {
    //       //
    //       //                                         return Card(
    //       //                                           shape: RoundedRectangleBorder(
    //       //                                             borderRadius: BorderRadius.circular(15.0),
    //       //                                           ),
    //       //                                           color: kGreyColor,
    //       //                                           margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
    //       //                                           child: Column(
    //       //                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       //                                               children: [
    //       //                                                 ListTile(
    //       //                                                   leading: Icon(Icons.assignment_rounded),
    //       //                                                   title: Text('تقرير المريض: $patientName', style: ksubBoldLabelTextStyle),
    //       //                                                   subtitle: Text('اسم الدواء: $tradeName '),
    //       //                                                 ),
    //       //                                                 Divider(
    //       //                                                   color: klighterColor,
    //       //                                                   thickness: 0.9,
    //       //                                                   endIndent: 20,
    //       //                                                   indent: 20,
    //       //                                                 ),
    //       //                                                 Padding(
    //       //                                                   padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
    //       //                                                   child: Container(
    //       //                                                     //height: 100,
    //       //                                                     child: Column(
    //       //                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       //                                                       children: [
    //       //                                                         Row(
    //       //                                                             children: [
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text(
    //       //                                                                 'تم الانتهاء من الوصفة: ',
    //       //                                                                 style: ksubBoldLabelTextStyle,
    //       //                                                               ),
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('$completed',
    //       //                                                                   style: TextStyle(
    //       //                                                                     color: Colors.black45,
    //       //                                                                     fontSize: 15.0,
    //       //                                                                     fontWeight: FontWeight.bold,
    //       //                                                                   )),
    //       //                                                             ]
    //       //                                                         ),
    //       //                                                         SizedBox(height: 15.0,),
    //       //                                                         Row(
    //       //                                                             children: [
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('تم الالتزام بالوصفة: ',
    //       //                                                                   style: ksubBoldLabelTextStyle
    //       //                                                               ),
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('$committed',
    //       //                                                                   style: TextStyle(
    //       //                                                                     color: Colors.black45,
    //       //                                                                     fontSize: 15.0,
    //       //                                                                     fontWeight: FontWeight.bold,
    //       //                                                                   )),
    //       //                                                             ]
    //       //                                                         ),
    //       //                                                         SizedBox(height: 15.0,),
    //       //                                                         Row(
    //       //                                                             children: [
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('الأعراض الجانبية: ',
    //       //                                                                   style: ksubBoldLabelTextStyle
    //       //                                                               ),
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('$sideEffects',
    //       //                                                                   style: TextStyle(
    //       //                                                                     color: Colors.black45,
    //       //                                                                     fontSize: 15.0,
    //       //                                                                     fontWeight: FontWeight.bold,
    //       //                                                                   )),
    //       //                                                             ]
    //       //                                                         ),
    //       //                                                         SizedBox(height: 15.0,),
    //       //                                                         Row(
    //       //                                                             children: [
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('ملاحظات: ',
    //       //                                                                   style: ksubBoldLabelTextStyle
    //       //                                                               ),
    //       //                                                               SizedBox(width: 15.0,),
    //       //                                                               Text('$notes',
    //       //                                                                   style: TextStyle(
    //       //                                                                     color: Colors.black45,
    //       //                                                                     fontSize: 15.0,
    //       //                                                                     fontWeight: FontWeight.bold,
    //       //                                                                   )),
    //       //                                                             ]
    //       //                                                         ),
    //       //                                                         SizedBox(height: 15.0,),
    //       //                                                         Divider(
    //       //                                                           color: klighterColor,
    //       //                                                           thickness: 0.9,
    //       //                                                           endIndent: 20,
    //       //                                                           indent: 20,
    //       //                                                         ),
    //       //                                                         Padding(
    //       //                                                           padding: const EdgeInsets.all(8.0),
    //       //                                                           child: FutureBuilder(
    //       //                                                               future: FirebaseFirestore.instance
    //       //                                                                   .collection('/Doctors')
    //       //                                                                   .doc(prescriberID)
    //       //                                                                   .get(),
    //       //                                                               builder: (context, snapshot) {
    //       //                                                                 var me = snapshot.data;
    //       //                                                                 String precriberName = me.get('doctor-name');
    //       //                                                                 return Row(
    //       //                                                                     children: [
    //       //                                                                       SizedBox(width: 15.0,),
    //       //                                                                       Text('الواصف: ',
    //       //                                                                           style: ksubBoldLabelTextStyle
    //       //                                                                       ),
    //       //                                                                       SizedBox(width: 15.0,),
    //       //                                                                       Text('$precriberName',
    //       //                                                                           style: TextStyle(
    //       //                                                                             color: Colors.black45,
    //       //                                                                             fontSize: 15.0,
    //       //                                                                             fontWeight: FontWeight.bold,
    //       //                                                                           )),
    //       //                                                                     ]
    //       //                                                                 );
    //       //                                                               }
    //       //                                                           ),
    //       //                                                         )
    //       //
    //       //                                                       ],
    //       //                                                     ),
    //       //                                                   ),
    //       //                                                 ),
    //       //                                               ]
    //       //                                           ),
    //       //                                         );
    //       //                                       } else {
    //       //                                         return SizedBox();
    //       //                                       }
    //       //                                     }
    //       //                                 ),
    //       //                               ),
    //       //                             );
    //       //                           }
    //       //                         }
    //       //                     );
    //       //                   }
    //       //               ),
    //       //             ),
    //       //           );
    //       //
    //       //         }
    //       //       }
    //       // ),
    //       //     ),
    //
    //
    //   );
  }
}
