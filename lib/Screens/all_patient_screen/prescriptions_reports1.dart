import 'package:alwasef_app/models/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';


class PrescriptionsReports1 extends StatefulWidget {
  final String uid;
  PrescriptionsReports1({this.uid});
  @override
  _PrescriptionsReports1State createState() => _PrescriptionsReports1State();
}

final GlobalKey<FormState>_formKey = new GlobalKey<FormState>();
Report report = Report();
List<String> yesNoAnswers = ['لا', 'نعم'];





class _PrescriptionsReports1State extends State<PrescriptionsReports1> {
  // @override
  // Widget build(BuildContext context) {
  //   //display prescriptions list with an add report icon button
  //   return Scaffold(
  //     backgroundColor: klighterColor,
  //     floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.note_add),
  //       backgroundColor: kBlueColor,
  //       onPressed: () {
  //         showModalBottomSheet();
  //       },
  //     ),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
  //       body: SafeArea(
  //         child: StreamBuilder(
  //           stream: FirebaseFirestore.instance
  //               .collection('/Patient')
  //               .doc(widget.uid)
  //               .collection('/Reports ')
  //               .snapshots(),
  //           builder: (context, snapshot) {
  //             if (!snapshot.hasData) {
  //               return Center( child: CircularProgressIndicator());
  //             } if (snapshot.data.docs.length == 0) {
  //               return Text('لم تقم بكاتبة أي تقرير حتى الان');
  //             } else {
  //               return ListView.builder(
  //                   //padding: ,
  //                   itemCount: snapshot.data.docs.length,
  //                   itemBuilder: (context, index) {
  //                     DocumentSnapshot report =
  //                     snapshot.data.docs[index];
  //                     String completed = report.data()['completed'];
  //                     String committed = report.data()['comitted'];
  //                     String sideEffects = report.data()['side effects'];
  //                     String notes = report.data()['notes'];
  //                     return Container(
  //                       child: Row(
  //                         children: [
  //                           Text('التقرير رقم$index',
  //                           style: TextStyle(fontSize: 15)),
  //                           Column(
  //                             children: [
  //                               Text('تم الانتهاء من الوصفة: $completed '),
  //                               Text('تم الالتزام بالوصفة:  $committed'),
  //                               Text('أعراض جانبية:'),
  //                               Text('$sideEffects'),
  //                               Text('ملاحظات:'),
  //                               Text('$notes'),
  //                             ]
  //                           ),
  //                           PopupMenuButton(
  //                               itemBuilder: (BuildContext context){
  //                                return ['عرض الوصفة الخاصة بهذا التقرير', 'حذف التقرير'].map((e) {
  //                                  return PopupMenuItem<String>(
  //                                    value: e,
  //                                    child: Text(e),
  //                                  );
  //                                }).toList();
  //                               },
  //                               onSelected: (item){
  //                                 if (item == 'حذف التقرير'){
  //                                   report.reference.delete();
  //                                 } else {
  //                                   //show prescription
  //                                 }
  //                               }
  //                           ), //weather delete or display prescription
  //                         ]
  //                       ),
  //                     );
  //                       ListTile(
  //                       leading: Icon(Icons.receipt_rounded),
  //                       title: Text('التقرير رقم$index'),
  //                       //subtitle: Text(''),
  //                       trailing: Row(
  //                         children: [
  //                           IconButton(
  //                               icon: Icon(Icons.assignment_rounded),
  //                               onPressed: (){
  //
  //                               }
  //                           ),
  //                           IconButton(
  //                               icon: Icon(Icons.edit_outlined),
  //                               onPressed: (){
  //                                 Navigator.push( context,
  //                                     MaterialPageRoute(
  //                                         builder: (context) =>
  //                                             EditMedicalHistoryPage(
  //                                               uid: widget.uid,
  //                                             )
  //                                     )
  //                                 );
  //                               }
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }
  //               );
  //             }
  //           }
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    //display prescriptions list with an add report icon button
    return Scaffold(
      backgroundColor: klighterColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        backgroundColor: kBlueColor,
        onPressed: () {
          return Navigator.of(context).push(new MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('/Patient')
                          .doc(widget.uid)
                          .collection('/Prescriptions')
                          .snapshots(), //TODO: where status equals dispened --- and date is after now
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } if (snapshot.data.docs.length == 0) {
                          return Text('ليس لديك أي وصفات حاليا'); //TODO: test this
                        } else {
                          return Scaffold(
                            body: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot prescription =
                                  snapshot.data.docs[index];
                                  return Material(
                                    child: InkWell(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        color: kGreyColor,
                                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: Icon(
                                                Icons.build_circle_outlined,
                                                size: 50,
                                              ),
                                              title: Text(
                                                // TODO: change it to different names maybe?
                                                prescription.data()['tradeName'],
                                                style: kBoldLabelTextStyle,
                                              ),
                                              // subtitle: Text(
                                              //   '  ${prescription.data()['administration-route']}  -   ${prescription.data()['tradeName']} ${prescription.data()['tradeName']} ',
                                              //   style: TextStyle(
                                              //       color: Colors.black45,
                                              //       fontSize: 14.0,
                                              //       fontWeight: FontWeight.w500),
                                              // ),

                                              trailing: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    prescription.data()[
                                                    'prescription-creation-date'],
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 13.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: klighterColor,
                                              thickness: 0.9,
                                              endIndent: 20,
                                              indent: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    // Row(
                                                    //   children: [
                                                    //     Text(
                                                    //       '',
                                                    //       style: ksubBoldLabelTextStyle,
                                                    //     ),
                                                    //     SizedBox(
                                                    //       width: 15.0,
                                                    //     ),
                                                    //     Text(
                                                    //       '${prescription.data()['start-date']}',
                                                    //       style: kValuesTextStyle,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // VerticalDivider(
                                                    //   indent: 20,
                                                    //   endIndent: 20.0,
                                                    //   color: kLightColor,
                                                    //   thickness: 1.5,
                                                    // ),
                                                    // Row(
                                                    //   children: [
                                                    //     Text(
                                                    //       ' نهاية الوصفة',
                                                    //       style: ksubBoldLabelTextStyle,
                                                    //     ),
                                                    //     SizedBox(
                                                    //       width: 15.0,
                                                    //     ),
                                                    //     Text(
                                                    //       '${prescription.data()['end-date']}',
                                                    //       style: kValuesTextStyle,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // VerticalDivider(
                                                    //   indent: 20,
                                                    //   endIndent: 20.0,
                                                    //   color: kLightColor,
                                                    //   thickness: 1.5,
                                                    // ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          ' التكرار',
                                                          style: ksubBoldLabelTextStyle,
                                                        ),
                                                        SizedBox(
                                                          width: 15.0,
                                                        ),
                                                        Text(
                                                          '${'${prescription.data()['frequency']}'}',
                                                          style: TextStyle(
                                                            color: Colors.black45,
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // VerticalDivider(
                                                    //   indent: 20,
                                                    //   endIndent: 20.0,
                                                    //   color: kLightColor,
                                                    //   thickness: 1.5,
                                                    // ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'التعليمات',
                                                          style: ksubBoldLabelTextStyle,
                                                        ),
                                                        SizedBox(
                                                          width: 15.0,
                                                        ),
                                                        Text(
                                                          '${prescription.data()['instruction-note']}',
                                                          style: TextStyle(
                                                            color: Colors.black45,
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'عدد مرات إعادة العبئة',
                                                              style: ksubBoldLabelTextStyle,
                                                            ),
                                                            SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            Text(
                                                              '${prescription.data()['refill']}',
                                                              style: kValuesTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        //report.prescriptionID = prescription.data()['prescription-id'];
                                        report.prescriptionRefID = prescription.reference.id;
                                        Navigator.of(context).push(new MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) {
                                              return Scaffold(
                                                body: Form(
                                                  key: _formKey,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: DropdownButtonFormField(
                                                            dropdownColor: Colors.black,
                                                            decoration: InputDecoration(
                                                              labelText: 'هل انتهيت من الوصفة الطبية؟',
                                                            ),
                                                            icon: Icon(Icons.arrow_drop_down),
                                                            value: report.completed,
                                                            items: yesNoAnswers.map((item) {
                                                              //to convert list items into dropdown menu items
                                                              return DropdownMenuItem(
                                                                child: Center(child: Text(item)),
                                                                value: item,
                                                              );
                                                            }).toList(),
                                                            validator: (value) =>
                                                            value == null
                                                                ? 'هذا الحقل مطلوب'
                                                                : null,
                                                            onSaved: (selectedValue) {
                                                              setState(() {
                                                                report.completed  = selectedValue;
                                                              });
                                                            },
                                                            onChanged: (selectedValue) {},
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: DropdownButtonFormField(
                                                            dropdownColor: Colors.black,
                                                            decoration: InputDecoration(
                                                              labelText: 'هل التزمت بالوصفة الطبية؟',
                                                            ),
                                                            icon: Icon(Icons.arrow_drop_down),
                                                            value: report.committed,
                                                            items: yesNoAnswers.map((item) {
                                                              //to convert list items into dropdown menu items
                                                              return DropdownMenuItem(
                                                                child: Center(child: Text(item)),
                                                                value: item,
                                                              );
                                                            }).toList(),
                                                            validator: (value) =>
                                                            value == null
                                                                ? 'هذا الحقل مطلوب'
                                                                : null,
                                                            onSaved: (selectedValue) {
                                                              setState(() {
                                                                report.committed = selectedValue;
                                                              });
                                                            },
                                                            onChanged: (selectedValue) {},
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              labelText: 'هل ظهرت عليك أي أعراض جانبية :',
                                                              hintText: 'اذكرها',
                                                            ),
                                                            validator: (value) =>
                                                            value == null
                                                                ? 'هذا الحقل مطلوب'
                                                                : null,
                                                            onSaved: (value) {
                                                              report.sideEffects = value;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              labelText: 'ملاحظات :',
                                                              hintText: 'اذكرها',
                                                            ),
                                                            validator: (value) =>
                                                            value == null
                                                                ? 'هذا الحقل مطلوب'
                                                                : null,
                                                            onSaved: (value) {
                                                              report.notes = value;
                                                            },
                                                          ),
                                                        ),
                                                        RaisedButton(
                                                            child: Text('حفظ'),
                                                            onPressed: (){
                                                              setState((){
                                                                if (_formKey.currentState.validate()) {
                                                                  _formKey.currentState.save();
                                                                  report.saveReport(widget.uid);
                                                                  //Scaffold.of(context).showSnackBar(snackBar);
                                                                  //Navigator.pop(context);
                                                                }
                                                              });
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                        ));
                                      },
                                    ),
                                  );
                                }
                            ),
                          );
                        }
                      }),
                );
              }));
          // return Navigator.of(context).push(new MaterialPageRoute(
          //   fullscreenDialog: true,
          //     builder: (context) {
          //       return Form(
          //         key: _formKey,
          //         child: SingleChildScrollView(
          //           child: Column(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: DropdownButtonFormField(
          //                   dropdownColor: Colors.black,
          //                   decoration: InputDecoration(
          //                     labelText: 'هل انتهيت من الوصفة الطبية؟',
          //                   ),
          //                   icon: Icon(Icons.arrow_drop_down),
          //                   value: completed,
          //                   items: yesNoAnswers.map((item) {
          //                     //to convert list items into dropdown menu items
          //                     return DropdownMenuItem(
          //                       child: Center(child: Text(item)),
          //                       value: item,
          //                     );
          //                   }).toList(),
          //                   validator: (value) =>
          //                   value == null
          //                       ? 'هذا الحقل مطلوب'
          //                       : null,
          //                   onSaved: (selectedValue) {
          //                     setState(() {
          //                       completed  = selectedValue;
          //                     });
          //                   },
          //                   onChanged: (selectedValue) {},
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: DropdownButtonFormField(
          //                   dropdownColor: Colors.black,
          //                   decoration: InputDecoration(
          //                     labelText: 'هل التزمت بالوصفة الطبية؟',
          //                   ),
          //                   icon: Icon(Icons.arrow_drop_down),
          //                   value: committed,
          //                   items: yesNoAnswers.map((item) {
          //                     //to convert list items into dropdown menu items
          //                     return DropdownMenuItem(
          //                       child: Center(child: Text(item)),
          //                       value: item,
          //                     );
          //                   }).toList(),
          //                   validator: (value) =>
          //                   value == null
          //                       ? 'هذا الحقل مطلوب'
          //                       : null,
          //                   onSaved: (selectedValue) {
          //                     setState(() {
          //                       committed = selectedValue;
          //                     });
          //                   },
          //                   onChanged: (selectedValue) {},
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: TextFormField(
          //                   maxLines: 5,
          //                   decoration: InputDecoration(
          //                     labelText: 'هل ظهرت عليك أي أعراض جانبية :',
          //                     hintText: 'اذكرها',
          //                   ),
          //                   validator: (value) =>
          //                   value == null
          //                       ? 'هذا الحقل مطلوب'
          //                       : null,
          //                   onSaved: (value) {
          //                     sideEffects = value;
          //                   },
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: TextFormField(
          //                   maxLines: 5,
          //                   decoration: InputDecoration(
          //                     labelText: 'ملاحظات :',
          //                     hintText: 'اذكرها',
          //                   ),
          //                   validator: (value) =>
          //                   value == null
          //                       ? 'هذا الحقل مطلوب'
          //                       : null,
          //                   onSaved: (value) {
          //                     sideEffects = value;
          //                   },
          //                 ),
          //               ),
          //               RaisedButton(
          //                 child: Text('حفظ'),
          //                 onPressed: {
          //                   setState: ((){
          //                     if (_formKey.currentState.validate()){
          //                       _formKey.currentState.save();
          //                       saveReport(widget.uid);
          //                     }
          //                   })
          //                 }
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     }
          // ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Text('body'),
      // body: SafeArea(
      //   child: Container(
      //     child: StreamBuilder(
      //         stream: FirebaseFirestore.instance
      //             .collection('/Patient')
      //             .doc(widget.uid)
      //             .collection('/Reports ')
      //             .snapshots(),
      //         builder: (context, snapshot) {
      //           if (!snapshot.hasData) {
      //             return Center( child: CircularProgressIndicator());
      //           } if (snapshot.data.docs.length == 0) {
      //             return Container(child: Text('لم تقم بكاتبة أي تقرير حتى الان'));
      //           } else {
      //             return ListView.builder(
      //               //padding: ,
      //                 itemCount: snapshot.data.docs.length,
      //                 itemBuilder: (context, index) {
      //                   DocumentSnapshot report =
      //                   snapshot.data.docs[index];
      //                   String completed = report.data()['completed'];
      //                   String committed = report.data()['committed'];
      //                   String sideEffects = report.data()['side effects'];
      //                   String notes = report.data()['notes'];
      //                   return Card(
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(15.0),
      //                     ),
      //                     color: kGreyColor,
      //                     margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      //                     child: Row(
      //                         children: [
      //                           Text('التقرير رقم$index',
      //                               style: TextStyle(fontSize: 15)),
      //                           Column(
      //                               children: [
      //                                 Text('تم الانتهاء من الوصفة: $completed '),
      //                                 Text('تم الالتزام بالوصفة:  $committed'),
      //                                 Text('أعراض جانبية:'),
      //                                 Text('$sideEffects'),
      //                                 Text('ملاحظات:'),
      //                                 Text('$notes'),
      //                               ]
      //                           ),
      //                           Spacer(),
      //                           PopupMenuButton(
      //                               itemBuilder: (BuildContext context){
      //                                 return ['عرض الوصفة الخاصة بهذا التقرير', 'حذف التقرير'].map((e) {
      //                                   return PopupMenuItem<String>(
      //                                     value: e,
      //                                     child: Text(e),
      //                                   );
      //                                 }).toList();
      //                               },
      //                               onSelected: (item){
      //                                 if (item == 'حذف التقرير'){
      //                                   report.reference.delete();
      //                                 } else {
      //                                   //show prescription
      //                                 }
      //                               }
      //                           ), //weather delete or display prescription
      //                         ]
      //                     ),
      //                   );
      //                   // ListTile(
      //                   //   leading: Icon(Icons.receipt_rounded),
      //                   //   title: Text('التقرير رقم$index'),
      //                   //   //subtitle: Text(''),
      //                   //   trailing: Row(
      //                   //     children: [
      //                   //       IconButton(
      //                   //           icon: Icon(Icons.assignment_rounded),
      //                   //           onPressed: (){
      //                   //
      //                   //           }
      //                   //       ),
      //                   //       IconButton(
      //                   //           icon: Icon(Icons.edit_outlined),
      //                   //           onPressed: (){
      //                   //             Navigator.push( context,
      //                   //                 MaterialPageRoute(
      //                   //                     builder: (context) =>
      //                   //                         EditMedicalHistoryPage(
      //                   //                           uid: widget.uid,
      //                   //                         )
      //                   //                 )
      //                   //             );
      //                   //           }
      //                   //       ),
      //                   //     ],
      //                   //   ),
      //                   // );
      //                 }
      //             );
      //           }
      //         }
      //     ),
      //   ),
      // ),
    );
  }
}


// void me() {
//   report.prescriptionDocID = prescription.reference.id;
//   Navigator.of(context).push(new MaterialPageRoute(
//       fullscreenDialog: true,
//       builder: (context) {
//         return Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DropdownButtonFormField(
//                     dropdownColor: Colors.black,
//                     decoration: InputDecoration(
//                       labelText: 'هل انتهيت من الوصفة الطبية؟',
//                     ),
//                     icon: Icon(Icons.arrow_drop_down),
//                     value: report.completed,
//                     items: yesNoAnswers.map((item) {
//                       //to convert list items into dropdown menu items
//                       return DropdownMenuItem(
//                         child: Center(child: Text(item)),
//                         value: item,
//                       );
//                     }).toList(),
//                     validator: (value) =>
//                     value == null
//                         ? 'هذا الحقل مطلوب'
//                         : null,
//                     onSaved: (selectedValue) {
//                       setState(() {
//                         report.completed  = selectedValue;
//                       });
//                     },
//                     onChanged: (selectedValue) {},
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DropdownButtonFormField(
//                     dropdownColor: Colors.black,
//                     decoration: InputDecoration(
//                       labelText: 'هل التزمت بالوصفة الطبية؟',
//                     ),
//                     icon: Icon(Icons.arrow_drop_down),
//                     value: report.committed,
//                     items: yesNoAnswers.map((item) {
//                       //to convert list items into dropdown menu items
//                       return DropdownMenuItem(
//                         child: Center(child: Text(item)),
//                         value: item,
//                       );
//                     }).toList(),
//                     validator: (value) =>
//                     value == null
//                         ? 'هذا الحقل مطلوب'
//                         : null,
//                     onSaved: (selectedValue) {
//                       setState(() {
//                         report.committed = selectedValue;
//                       });
//                     },
//                     onChanged: (selectedValue) {},
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     maxLines: 5,
//                     decoration: InputDecoration(
//                       labelText: 'هل ظهرت عليك أي أعراض جانبية :',
//                       hintText: 'اذكرها',
//                     ),
//                     validator: (value) =>
//                     value == null
//                         ? 'هذا الحقل مطلوب'
//                         : null,
//                     onSaved: (value) {
//                       report.sideEffects = value;
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     maxLines: 5,
//                     decoration: InputDecoration(
//                       labelText: 'ملاحظات :',
//                       hintText: 'اذكرها',
//                     ),
//                     validator: (value) =>
//                     value == null
//                         ? 'هذا الحقل مطلوب'
//                         : null,
//                     onSaved: (value) {
//                       report.notes = value;
//                     },
//                   ),
//                 ),
//                 RaisedButton(
//                     child: Text('حفظ'),
//                     onPressed: (){
//                       setState((){
//                         if (_formKey.currentState.validate()) {
//                           _formKey.currentState.save();
//                           report.saveReport(widget.uid);
//                           //Scaffold.of(context).showSnackBar(snackBar);
//                           //Navigator.pop(context);
//                         }
//                       });
//                     }),
//               ],
//             ),
//           ),
//         );
//       }
//   ));
// }
