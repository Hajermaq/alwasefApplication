import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class PatientsReports extends StatefulWidget {
  PatientsReports({this.condition});
  final String condition;

  @override
  _PatientsReportsState createState() => _PatientsReportsState();
}

class _PatientsReportsState extends State<PatientsReports> {

  String searchValue = '';


  @override
  Widget build(BuildContext context){
    return SafeArea(
      minimum: EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
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
        body: Column(
          children: [
            FilledRoundTextFields(
                fillColor: kGreyColor,
                color: kScaffoldBackGroundColor,
                hintMessage: 'ابحث',
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                }),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/Report')
                      .where(widget.condition, isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center( child: CircularProgressIndicator());
                    } if (snapshot.data.docs.length == 0) {
                      return Center(child: Text('ليس هناك أي تقارير حاليا', style: TextStyle(color: Colors.black)));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot report =
                            snapshot.data.docs[index];
                            String prescriptionRefID = report.data()['prescription-id'];
                            String completed = report.data()['completed'];
                            String committed = report.data()['committed'];
                            String sideEffects = report.data()['side effects'].join('\n');
                            String notes = report.data()['notes'];

                            String name =
                              report.data()['patient-name'];
                            if (name
                                .toLowerCase()
                                .contains(searchValue.toLowerCase()) ||
                                name
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase())) {

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: kGreyColor,
                                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.assignment_rounded),
                                        title: Text('تقرير المريض: $name', style: TextStyle(fontSize: 26)),
                                        trailing: Theme(
                                          data: Theme.of(context).copyWith(
                                            cardColor: Colors.black,
                                          ),
                                          child: PopupMenuButton(
                                              itemBuilder: (BuildContext context){
                                                return ['عرض الوصفة الخاصة بهذا التقرير'].map((e) {
                                                  return PopupMenuItem<String>(
                                                    value: e,
                                                    child: Text(e),
                                                  );
                                                }).toList();
                                              },
                                              onSelected: (item){
                                                //TODO: display prescription
                                              }
                                          ),
                                        ), //weather delete or display prescription
                                      ),
                                      Divider(
                                        color: klighterColor,
                                        thickness: 0.9,
                                        endIndent: 20,
                                        indent: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
                                        child: Container(
                                          //height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                  children: [
                                                    Text(
                                                      'تم الانتهاء من الوصفة: ',
                                                      style: ksubBoldLabelTextStyle,
                                                    ),
                                                    SizedBox(width: 15.0,),
                                                    Text('$completed',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ]
                                              ),
                                              SizedBox(height: 15.0,),
                                              Row(
                                                  children: [
                                                    Text('تم الالتزام بالوصفة: ',
                                                        style: ksubBoldLabelTextStyle
                                                    ),
                                                    SizedBox(width: 15.0,),
                                                    Text('$committed',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ]
                                              ),
                                              SizedBox(height: 15.0,),
                                              Row(
                                                  children: [
                                                    Text('الأعراض الجانبية: ',
                                                        style: ksubBoldLabelTextStyle
                                                    ),
                                                    SizedBox(width: 15.0,),
                                                    Text('$sideEffects',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ]
                                              ),
                                              SizedBox(height: 15.0,),
                                              Row(
                                                  children: [
                                                    Text('ملاحظات: ',
                                                        style: ksubBoldLabelTextStyle
                                                    ),
                                                    SizedBox(width: 15.0,),
                                                    Text('$notes',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ]
                                              ),
                                              SizedBox(height: 15.0,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }
                      );

                      // return ListView.builder(
                      //     itemCount: snapshot.data.docs.length,
                      //     itemBuilder: (context, outerIndex) {
                      //
                      //       final indexedPatient = snapshot.data.docs[outerIndex];
                      //       final docID = indexedPatient.id;
                      //
                      //       // final reportCollectionSnapshot =
                      //       //     snapshot.data.docs(docID).collection('/Reports').snapshot;
                      //
                      //       final reportCollectionSnapshot =
                      //           indexedPatient.collection('/Reports').snapshot;
                      //
                      //
                      //       // var reportsList = [];
                      //       // final reportCollectionSnapshot = indexedPatient
                      //       //     .collection('/Reports')
                      //       //     .get()
                      //       //     .then((reportsSnapshot) {
                      //       //   reportsSnapshot.data.docs.forEach((doc) {
                      //       //     reportsList.add(doc);
                      //       //   });
                      //       // });
                      //       // {snapshot.data.docs[index].get('uid')}
                      //       return ListView.builder(
                      //           itemCount: reportCollectionSnapshot.data.docs.length,
                      //           itemBuilder: (context, innerIndex) {
                      //             DocumentSnapshot report =
                      //                 reportCollectionSnapshot.data.docs[innerIndex];
                      //
                      //             String prescriptionRefID = report.data()['prescription-id'];
                      //             String completed = report.data()['completed'];
                      //             String committed = report.data()['committed'];
                      //             String sideEffects = report.data()['side effects'].join('\n');
                      //             String notes = report.data()['notes'];
                      //
                      //             return Card(
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(15.0),
                      //               ),
                      //               color: kGreyColor,
                      //               margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      //               child: Column(
                      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //                   children: [
                      //                     ListTile(
                      //                       leading: Icon(Icons.assignment_rounded),
                      //                       title: Text('التقرير رقم ', style: TextStyle(fontSize: 26)),
                      //                       trailing: Theme(
                      //                         data: Theme.of(context).copyWith(
                      //                           cardColor: Colors.black,
                      //                         ),
                      //                         child: PopupMenuButton(
                      //                             itemBuilder: (BuildContext context){
                      //                               return ['عرض الوصفة الخاصة بهذا التقرير'].map((e) {
                      //                                 return PopupMenuItem<String>(
                      //                                   value: e,
                      //                                   child: Text(e),
                      //                                 );
                      //                               }).toList();
                      //                             },
                      //                             onSelected: (item){
                      //                                 //displayPrescription(prescriptionRefID); //TODO: test display prescription of this report
                      //                                 // Navigator.push( context,
                      //                                 //           //     MaterialPageRoute(
                      //                                 //           //         builder: (context) =>
                      //                                 //           //             EditMedicalHistoryPage(
                      //                                 //           //               uid: widget.uid,
                      //                                 //           //             )));
                      //
                      //                             }
                      //                         ),
                      //                       ), //weather delete or display prescription
                      //                     ),
                      //                     Divider(
                      //                       color: klighterColor,
                      //                       thickness: 0.9,
                      //                       endIndent: 20,
                      //                       indent: 20,
                      //                     ),
                      //                     Padding(
                      //                       padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
                      //                       child: Container(
                      //                         //height: 100,
                      //                         child: Column(
                      //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //                           children: [
                      //                             Row(
                      //                                 children: [
                      //                                   Text(
                      //                                     'تم الانتهاء من الوصفة: ',
                      //                                     style: ksubBoldLabelTextStyle,
                      //                                   ),
                      //                                   SizedBox(width: 15.0,),
                      //                                   Text('$completed',
                      //                                       style: TextStyle(
                      //                                         color: Colors.black45,
                      //                                         fontSize: 15.0,
                      //                                         fontWeight: FontWeight.bold,
                      //                                       )),
                      //                                 ]
                      //                             ),
                      //                             SizedBox(height: 15.0,),
                      //                             Row(
                      //                                 children: [
                      //                                   Text('تم الالتزام بالوصفة: '),
                      //                                   SizedBox(width: 15.0,),
                      //                                   Text('$committed',
                      //                                       style: TextStyle(
                      //                                         color: Colors.black45,
                      //                                         fontSize: 15.0,
                      //                                         fontWeight: FontWeight.bold,
                      //                                       )),
                      //                                 ]
                      //                             ),
                      //                             SizedBox(height: 15.0,),
                      //                             Row(
                      //                                 children: [
                      //                                   Text('الأعراض الجانبية: '),
                      //                                   SizedBox(width: 15.0,),
                      //                                   Text('$sideEffects',
                      //                                       style: TextStyle(
                      //                                         color: Colors.black45,
                      //                                         fontSize: 15.0,
                      //                                         fontWeight: FontWeight.bold,
                      //                                       )),
                      //                                 ]
                      //                             ),
                      //                             SizedBox(height: 15.0,),
                      //                             Row(
                      //                                 children: [
                      //                                   Text('ملاحظات: '),
                      //                                   SizedBox(width: 15.0,),
                      //                                   Text('$notes',
                      //                                       style: TextStyle(
                      //                                         color: Colors.black45,
                      //                                         fontSize: 15.0,
                      //                                         fontWeight: FontWeight.bold,
                      //                                       )),
                      //                                 ]
                      //                             ),
                      //                             SizedBox(height: 15.0,),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ]
                      //               ),
                      //             );
                      //
                      //           }
                      //       );
                      //     }
                      // );
                    }
                  }
              ),
            ),
            // Expanded(
            //   child: StreamBuilder(
            //       stream: FirebaseFirestore.instance
            //           .collection('/Report')
            //           .where('prescriber-id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            //           .snapshots(),
            //       builder: (context, snapshot) {
            //         if (!snapshot.hasData) {
            //           return Center( child: CircularProgressIndicator());
            //         } if (snapshot.data.docs.length == 0) {
            //           return Center(child: Text('ليس هناك أي تقارير حاليا', style: TextStyle(color: Colors.black)));
            //         } else {
            //           return ListView.builder(
            //               itemCount: snapshot.data.docs.length,
            //               itemBuilder: (context, index) {
            //                 DocumentSnapshot report =
            //                   snapshot.data.docs[index];
            //                 String prescriptionRefID = report.data()['prescription-id'];
            //                 String completed = report.data()['completed'];
            //                 String committed = report.data()['committed'];
            //                 String sideEffects = report.data()['side effects'].join('\n');
            //                 String notes = report.data()['notes'];
            //                 //get report creator name
            //                 // String patientID = report.data()['patient-id'];
            //                 // String patientName = '';
            //                 //  FirebaseFirestore.instance
            //                 //     .collection('/Report')
            //                 //     .doc(patientID)
            //                 //     .get()
            //                 //     .then((doc) {
            //                 //       setState(() {
            //                 //         patientName = doc.data()['patient-name'];
            //                 //       });
            //                 // });
            //
            //                 // String patientID = report.data()['patient-id'];
            //                 // var patientDoc = FirebaseFirestore.instance
            //                 //     .collection('/Report')
            //                 //     .doc(patientID)
            //                 //     .snapshots();
            //                 // var patientName = patientDoc.data.docs;
            //                 return Card(
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   color: kGreyColor,
            //                   margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            //                   child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //                         ListTile(
            //                           leading: Icon(Icons.assignment_rounded),
            //                           title: Text('التقرير رقم: $index', style: TextStyle(fontSize: 26)),
            //                           trailing: Theme(
            //                             data: Theme.of(context).copyWith(
            //                               cardColor: Colors.black,
            //                             ),
            //                             child: PopupMenuButton(
            //                                 itemBuilder: (BuildContext context){
            //                                   return ['عرض الوصفة الخاصة بهذا التقرير'].map((e) {
            //                                     return PopupMenuItem<String>(
            //                                       value: e,
            //                                       child: Text(e),
            //                                     );
            //                                   }).toList();
            //                                 },
            //                                 onSelected: (item){
            //                                 }
            //                             ),
            //                           ), //weather delete or display prescription
            //                         ),
            //                         Divider(
            //                           color: klighterColor,
            //                           thickness: 0.9,
            //                           endIndent: 20,
            //                           indent: 20,
            //                         ),
            //                         Padding(
            //                           padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
            //                           child: Container(
            //                             //height: 100,
            //                             child: Column(
            //                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                               children: [
            //                                 Row(
            //                                     children: [
            //                                       Text(
            //                                         'تم الانتهاء من الوصفة: ',
            //                                         style: ksubBoldLabelTextStyle,
            //                                       ),
            //                                       SizedBox(width: 15.0,),
            //                                       Text('$completed',
            //                                           style: TextStyle(
            //                                             color: Colors.black45,
            //                                             fontSize: 15.0,
            //                                             fontWeight: FontWeight.bold,
            //                                           )),
            //                                     ]
            //                                 ),
            //                                 SizedBox(height: 15.0,),
            //                                 Row(
            //                                     children: [
            //                                       Text('تم الالتزام بالوصفة: '),
            //                                       SizedBox(width: 15.0,),
            //                                       Text('$committed',
            //                                           style: TextStyle(
            //                                             color: Colors.black45,
            //                                             fontSize: 15.0,
            //                                             fontWeight: FontWeight.bold,
            //                                           )),
            //                                     ]
            //                                 ),
            //                                 SizedBox(height: 15.0,),
            //                                 Row(
            //                                     children: [
            //                                       Text('الأعراض الجانبية: '),
            //                                       SizedBox(width: 15.0,),
            //                                       Text('$sideEffects',
            //                                           style: TextStyle(
            //                                             color: Colors.black45,
            //                                             fontSize: 15.0,
            //                                             fontWeight: FontWeight.bold,
            //                                           )),
            //                                     ]
            //                                 ),
            //                                 SizedBox(height: 15.0,),
            //                                 Row(
            //                                     children: [
            //                                       Text('ملاحظات: '),
            //                                       SizedBox(width: 15.0,),
            //                                       Text('$notes',
            //                                           style: TextStyle(
            //                                             color: Colors.black45,
            //                                             fontSize: 15.0,
            //                                             fontWeight: FontWeight.bold,
            //                                           )),
            //                                     ]
            //                                 ),
            //                                 SizedBox(height: 15.0,),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                       ]
            //                   ),
            //                 );
            //               }
            //           );
            //
            //           // return ListView.builder(
            //           //     itemCount: snapshot.data.docs.length,
            //           //     itemBuilder: (context, outerIndex) {
            //           //
            //           //       final indexedPatient = snapshot.data.docs[outerIndex];
            //           //       final docID = indexedPatient.id;
            //           //
            //           //       // final reportCollectionSnapshot =
            //           //       //     snapshot.data.docs(docID).collection('/Reports').snapshot;
            //           //
            //           //       final reportCollectionSnapshot =
            //           //           indexedPatient.collection('/Reports').snapshot;
            //           //
            //           //
            //           //       // var reportsList = [];
            //           //       // final reportCollectionSnapshot = indexedPatient
            //           //       //     .collection('/Reports')
            //           //       //     .get()
            //           //       //     .then((reportsSnapshot) {
            //           //       //   reportsSnapshot.data.docs.forEach((doc) {
            //           //       //     reportsList.add(doc);
            //           //       //   });
            //           //       // });
            //           //
            //           //       return ListView.builder(
            //           //           itemCount: reportCollectionSnapshot.data.docs.length,
            //           //           itemBuilder: (context, innerIndex) {
            //           //             DocumentSnapshot report =
            //           //                 reportCollectionSnapshot.data.docs[innerIndex];
            //           //
            //           //             String prescriptionRefID = report.data()['prescription-id'];
            //           //             String completed = report.data()['completed'];
            //           //             String committed = report.data()['committed'];
            //           //             String sideEffects = report.data()['side effects'].join('\n');
            //           //             String notes = report.data()['notes'];
            //           //
            //           //             return Card(
            //           //               shape: RoundedRectangleBorder(
            //           //                 borderRadius: BorderRadius.circular(15.0),
            //           //               ),
            //           //               color: kGreyColor,
            //           //               margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            //           //               child: Column(
            //           //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           //                   children: [
            //           //                     ListTile(
            //           //                       leading: Icon(Icons.assignment_rounded),
            //           //                       title: Text('التقرير رقم ', style: TextStyle(fontSize: 26)),
            //           //                       trailing: Theme(
            //           //                         data: Theme.of(context).copyWith(
            //           //                           cardColor: Colors.black,
            //           //                         ),
            //           //                         child: PopupMenuButton(
            //           //                             itemBuilder: (BuildContext context){
            //           //                               return ['عرض الوصفة الخاصة بهذا التقرير'].map((e) {
            //           //                                 return PopupMenuItem<String>(
            //           //                                   value: e,
            //           //                                   child: Text(e),
            //           //                                 );
            //           //                               }).toList();
            //           //                             },
            //           //                             onSelected: (item){
            //           //                                 //displayPrescription(prescriptionRefID); //TODO: test display prescription of this report
            //           //                                 // Navigator.push( context,
            //           //                                 //           //     MaterialPageRoute(
            //           //                                 //           //         builder: (context) =>
            //           //                                 //           //             EditMedicalHistoryPage(
            //           //                                 //           //               uid: widget.uid,
            //           //                                 //           //             )));
            //           //
            //           //                             }
            //           //                         ),
            //           //                       ), //weather delete or display prescription
            //           //                     ),
            //           //                     Divider(
            //           //                       color: klighterColor,
            //           //                       thickness: 0.9,
            //           //                       endIndent: 20,
            //           //                       indent: 20,
            //           //                     ),
            //           //                     Padding(
            //           //                       padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 10),
            //           //                       child: Container(
            //           //                         //height: 100,
            //           //                         child: Column(
            //           //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           //                           children: [
            //           //                             Row(
            //           //                                 children: [
            //           //                                   Text(
            //           //                                     'تم الانتهاء من الوصفة: ',
            //           //                                     style: ksubBoldLabelTextStyle,
            //           //                                   ),
            //           //                                   SizedBox(width: 15.0,),
            //           //                                   Text('$completed',
            //           //                                       style: TextStyle(
            //           //                                         color: Colors.black45,
            //           //                                         fontSize: 15.0,
            //           //                                         fontWeight: FontWeight.bold,
            //           //                                       )),
            //           //                                 ]
            //           //                             ),
            //           //                             SizedBox(height: 15.0,),
            //           //                             Row(
            //           //                                 children: [
            //           //                                   Text('تم الالتزام بالوصفة: '),
            //           //                                   SizedBox(width: 15.0,),
            //           //                                   Text('$committed',
            //           //                                       style: TextStyle(
            //           //                                         color: Colors.black45,
            //           //                                         fontSize: 15.0,
            //           //                                         fontWeight: FontWeight.bold,
            //           //                                       )),
            //           //                                 ]
            //           //                             ),
            //           //                             SizedBox(height: 15.0,),
            //           //                             Row(
            //           //                                 children: [
            //           //                                   Text('الأعراض الجانبية: '),
            //           //                                   SizedBox(width: 15.0,),
            //           //                                   Text('$sideEffects',
            //           //                                       style: TextStyle(
            //           //                                         color: Colors.black45,
            //           //                                         fontSize: 15.0,
            //           //                                         fontWeight: FontWeight.bold,
            //           //                                       )),
            //           //                                 ]
            //           //                             ),
            //           //                             SizedBox(height: 15.0,),
            //           //                             Row(
            //           //                                 children: [
            //           //                                   Text('ملاحظات: '),
            //           //                                   SizedBox(width: 15.0,),
            //           //                                   Text('$notes',
            //           //                                       style: TextStyle(
            //           //                                         color: Colors.black45,
            //           //                                         fontSize: 15.0,
            //           //                                         fontWeight: FontWeight.bold,
            //           //                                       )),
            //           //                                 ]
            //           //                             ),
            //           //                             SizedBox(height: 15.0,),
            //           //                           ],
            //           //                         ),
            //           //                       ),
            //           //                     ),
            //           //                   ]
            //           //               ),
            //           //             );
            //           //
            //           //           }
            //           //       );
            //           //     }
            //           // );
            //         }
            //       }
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
