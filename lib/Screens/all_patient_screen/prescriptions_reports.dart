import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants.dart';
import 'edit_medical_history_screen.dart';
import 'fill_medical_history_screen.dart';

class PrescriptionsReports extends StatefulWidget {
  final String uid;
  PrescriptionsReports({this.uid});
  @override
  _PrescriptionsReportsState createState() => _PrescriptionsReportsState();
}

  Widget showModalBottomSheet(){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 40.0,),
        Text('اختر الوصفة التي تريد التقرير عنها:',
          style: TextStyle(
            fontSize: 20.0,
            color: kRedColor, ),
        ),
        SizedBox(
          height: 30,
          width: 1000,
          child: FlatButton(
            child: Text('اخــتـر'),
            color: kTextFieldborderColor,
            onPressed: (){},
          ),
        ),
        Text('هل أتممت الوصفة الطبية؟',
          style: TextStyle(
            fontSize: 20.0,
            color: kRedColor, ),
        ),
        TextField(
          maxLines: 2, decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),),
        Text('هل التزمت بالوصفة الطبية؟',
          style: TextStyle(
            fontSize: 20.0,
            color: kRedColor, ),
        ),
        TextField(
          maxLines: 2, decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),),
        Text('هل ظهرت عليك أعراض جانبية، اذكرها:',
          style: TextStyle(
            fontSize: 20.0,
            color: kRedColor, ),
        ),
        TextField(
          maxLines: 5, decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),),
        Text('ملاحظات أخرى:',
          style: TextStyle(
            fontSize: 20.0,
            color: kRedColor, ),
        ),
        TextField(
          maxLines: 5, decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),),
        FlatButton(
          child: Text('حفظ'),
          color: kRedColor,
          onPressed: (){},
        ),
      ],
    ),
  );
}



class _PrescriptionsReportsState extends State<PrescriptionsReports> {
  @override
  Widget build(BuildContext context) {
    //display prescriptions list with an add report icon button
    return Scaffold(
      backgroundColor: klighterColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        backgroundColor: kBlueColor,
        onPressed: () {
          showModalBottomSheet();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Patient')
                .doc(widget.uid)
                .collection('/Reports ')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center( child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot report =
                      snapshot.data.docs[index];
                      String completed = report.data()['completed'];
                      String committed = report.data()['completed'];
                      String sideEffects = report.data()['side effects'];
                      String notes = report.data()['notes'];
                      return Container(
                        child: Row(
                          children: [
                            Text('التقرير رقم$index',
                            style: TextStyle(fontSize: 15)),
                            Column(
                              children: [
                                Text('تم الانتهاء من الوصفة: $completed '),
                                Text('تم الالتزام بالوصفة:  $committed'),
                                Text('أعراض جانبية:'),
                                Text('$sideEffects'),
                                Text('ملاحظات:'),
                                Text('$notes'),
                              ]
                            ),
                            PopupMenuButton(
                                itemBuilder: (BuildContext context){
                                 return ['عرض الوصفة الخاصة بهذا التقرير', 'حذف التقرير'].map((e) {
                                   return PopupMenuItem<String>(
                                     value: e,
                                     child: Text(e),
                                   );
                                 }).toList();
                                },
                                onSelected: (item){
                                  if (item == 'حذف التقرير'){
                                    report.reference.delete();
                                  } else {
                                    //show prescription
                                  }
                                }
                            ), //weather delete or display prescription
                          ]
                        ),
                      );
                        ListTile(
                        leading: Icon(Icons.receipt_rounded),
                        title: Text('التقرير رقم$index'),
                        //subtitle: Text(''),
                        trailing: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.assignment_rounded),
                                onPressed: (){

                                }
                            ),
                            IconButton(
                                icon: Icon(Icons.edit_outlined),
                                onPressed: (){
                                  Navigator.push( context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditMedicalHistoryPage(
                                                uid: widget.uid,
                                              )
                                      )
                                  );
                                }
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
            }
        ),
      ),
    );
  }
}
