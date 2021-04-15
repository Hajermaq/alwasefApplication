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
            style: GoogleFonts.almarai(color: kGreyColor, fontSize: 28.0),
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
                      return Center(
                        child: Text(
                          'ليس هناك أي تقارير حاليا.',
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

                            String precriberName = report.data()['prescriper-nam'];
                            String pharmacistName = report.data()['pharmacist-name'];
                            //search by
                            String name = report.data()['patient-name'];
                            String tradeName = report.data()['tradeName'];

                            //search logic
                            if (name
                                .toLowerCase()
                                .contains(searchValue.toLowerCase()) ||
                                name
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase()) ||
                                tradeName
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
                                        title: Text('تقرير المريض: $name', style: TextStyle(fontSize: 15)),
                                        subtitle: Text('اسم الدواء: $tradeName '),
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
          ],
        ),
      ),
    );
  }
}
