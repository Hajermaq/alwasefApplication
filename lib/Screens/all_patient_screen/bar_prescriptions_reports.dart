import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';


class PrescriptionsReports extends StatefulWidget {
  final String uid;
  PrescriptionsReports({this.uid});
  @override
  _PrescriptionsReportsState createState() => _PrescriptionsReportsState();
}

class _PrescriptionsReportsState extends State<PrescriptionsReports> {
  Widget yesButton;
  Widget noButton;
  String searchValue = '';

  Future displayReportPrescription(String prescriptionID){ //TODO: delete this
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('/Patient')
              .doc(widget.uid)
              .collection('/Prescriptions')
              .doc(prescriptionID)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center( child: CircularProgressIndicator());
            } else {
              DocumentSnapshot prescription = snapshot.data;
              return Card(
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
              );
            }
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('التقارير الحالية',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Report')
                .where('patient-id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center( child: CircularProgressIndicator());
              } if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text(
                    'لم تقم بكتابة أي تقرير حتى الان.',
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot report = snapshot.data.docs[index];
                      String completed = report.data()['completed'];
                      String committed = report.data()['committed'];
                      String sideEffects = report.data()['side effects'].join('\n');
                      String notes = report.data()['notes'];

                      String precriberName = report.data()['prescriper-name'];
                      String pharmacistName = report.data()['pharmacist-name'];
                      //search by
                      String tradeName = report.data()['tradeName'];

                      //search logic
                      if (tradeName
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()) ||
                          tradeName
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
                                  title: Text('اسم الدواء: $tradeName '),
                                  trailing: Theme(
                                    data: Theme.of(context).copyWith(
                                      cardColor: Colors.black,
                                    ),
                                    child: PopupMenuButton(
                                        itemBuilder: (BuildContext context){
                                          return ['حذف التقرير'].map((e) {
                                            return PopupMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList();
                                        },
                                        onSelected: (item){
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                yesButton = FlatButton(
                                                    child: Text('نعم'),
                                                    onPressed:() async{
                                                      await FirebaseFirestore.instance
                                                          .collection('/Report')
                                                          .doc(report.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    }
                                                );
                                                noButton = FlatButton(
                                                  child: Text('لا'),
                                                  onPressed:() {
                                                    Navigator.pop(context);
                                                  },
                                                );

                                                return AlertDialog(
                                                  title: Text('هل أنت متأكد من حذف التقرير؟', textAlign: TextAlign.center),
                                                  titleTextStyle: TextStyle(fontSize: 22),
                                                  content: Text('قد يؤدي ذلك إلى ضعف الخدمة المقدمة لك ', style: TextStyle(fontFamily: 'Almarai',)),
                                                  actions: [
                                                    yesButton,
                                                    noButton
                                                  ],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                  ),
                                                  elevation: 24.0,
                                                  backgroundColor: Colors.black,
                                                );
                                              }
                                          );
                                        }
                                    ),
                                  ), //weather delete or display prescription,
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
                                        Divider(
                                          color: klighterColor,
                                          thickness: 0.9,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        Row(
                                            children: [
                                              Text('الواصف: ',
                                                  style: ksubBoldLabelTextStyle
                                              ),
                                              SizedBox(width: 15.0,),
                                              Text('$precriberName',
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
                                              Text('الصيدلي: ',
                                                  style: ksubBoldLabelTextStyle
                                              ),
                                              SizedBox(width: 15.0,),
                                              Text('$pharmacistName',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ]
                                        ),
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
              }
            }
        ),
      ),
    );
  }
}



