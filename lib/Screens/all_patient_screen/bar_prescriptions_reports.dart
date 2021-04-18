import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0),
      child: Scaffold(
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
          title: Text('التقارير الحالية',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Patient')
                .doc(widget.uid)
                .collection('Reports')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center( child: CircularProgressIndicator(
                    backgroundColor: kGreyColor,
                    valueColor: AlwaysStoppedAnimation(kBlueColor)
                )
                );
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

                      String prescriberID = report.data()['prescriper-id'];
                      String pharmacistID = report.data()['pharmacist-id'];


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
                                      cardColor: Colors.white,
                                    ),
                                    child: PopupMenuButton(
                                        offset: Offset(20,40),
                                        itemBuilder: (BuildContext context){
                                          return ['حذف التقرير'].map((e) {
                                            return PopupMenuItem<String>(
                                              value: e,
                                              child: Text(e, style: TextStyle(color: kBlueColor)),
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
                                                  titleTextStyle: TextStyle(
                                                    color: kBlueColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Almarai',
                                                  ),
                                                  content: Text('قد يؤدي ذلك إلى ضعف الخدمة المقدمة لك '),
                                                  contentTextStyle: TextStyle(
                                                    color: kBlueColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Almarai',
                                                  ),
                                                  actions: [
                                                    yesButton,
                                                    noButton
                                                  ],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                  ),
                                                  elevation: 24.0,
                                                  backgroundColor: Colors.white,
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

                                        Theme(
                                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            title:  Text('معلومات الواصف والصيدلي: ',
                                                style: ksubBoldLabelTextStyle
                                            ),
                                            children: [
                                              FutureBuilder(
                                                future: FirebaseFirestore.instance
                                                    .collection('/Doctors')
                                                    .doc(prescriberID)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation(Colors.transparent),
                                                        ));
                                                  } else {
                                                    var me = snapshot.data;
                                                    String doctorName2 = me.get('doctor-name');
                                                    return Row(
                                                        children: [
                                                          SizedBox(width: 15),
                                                          Text('الواصف: ',
                                                              style: ksubBoldLabelTextStyle
                                                          ),
                                                          SizedBox(width: 15.0,),

                                                          Text('$doctorName2',
                                                              style: TextStyle(
                                                                color: Colors.black45,
                                                                fontSize: 15.0,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ]
                                                    );
                                                  }
                                                },

                                              ),
                                              SizedBox(height: 15.0,),
                                              FutureBuilder(
                                                future: FirebaseFirestore.instance
                                                    .collection('/Pharmacist')
                                                    .doc(pharmacistID)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                        child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation(Colors.transparent),) //kGreyColor
                                                    );
                                                  } else {
                                                    var doc = snapshot.data;
                                                    String pharmacistName = doc.get('pharmacist-name');
                                                    return Row(
                                                        children: [
                                                          SizedBox(width: 15),
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
                                                    );
                                                  }
                                                },
                                              ),
                                              SizedBox(height: 15.0,),
                                            ],
                                          ),
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



