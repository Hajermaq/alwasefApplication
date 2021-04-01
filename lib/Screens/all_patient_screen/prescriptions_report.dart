import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';


class PrescriptionsReports extends StatefulWidget {
  final String uid;
  PrescriptionsReports({this.uid});
  @override
  _PrescriptionsReportsState createState() => _PrescriptionsReportsState();
}

class _PrescriptionsReportsState extends State<PrescriptionsReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التقارير الحالية'),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/Patient')
                .doc(widget.uid)
                .collection('/Reports')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center( child: CircularProgressIndicator());
              } if (snapshot.data.docs.length == 0) {
                return Container(child: Text('لم تقم بكاتبة أي تقرير حتى الان', style: TextStyle(color: Colors.black)));
              } else {
                return ListView.builder(
                  //padding: ,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot report =
                      snapshot.data.docs[index];
                      String completed = report.data()['completed'];
                      String committed = report.data()['committed'];
                      String sideEffects = report.data()['side effects'];
                      String notes = report.data()['notes'];
                      return Flexible(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: kGreyColor,
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          child: Container(
                            child: Row(
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('التقرير رقم$index',
                                            style: TextStyle(fontSize: 30)),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Text('تم الانتهاء من الوصفة: $completed '),
                                        Text('تم الالتزام بالوصفة:  $committed'),
                                        Text('أعراض جانبية:'),
                                        Text('$sideEffects'),
                                        Text('ملاحظات:'),
                                        Text('$notes'),
                                      ]
                                  ),
                                  Spacer(),
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
                                        if (item == 'حذف التقرير'){ //TODO: aletdialog
                                          report.reference.delete();
                                        } else {
                                          //show prescription
                                        }
                                      }
                                  ), //weather delete or display prescription
                                ]
                            ),
                          ),
                        ),
                      );
                      // ListTile(
                      //   leading: Icon(Icons.receipt_rounded),
                      //   title: Text('التقرير رقم$index'),
                      //   //subtitle: Text(''),
                      //   trailing: Row(
                      //     children: [
                      //       IconButton(
                      //           icon: Icon(Icons.assignment_rounded),
                      //           onPressed: (){
                      //
                      //           }
                      //       ),
                      //       IconButton(
                      //           icon: Icon(Icons.edit_outlined),
                      //           onPressed: (){
                      //             Navigator.push( context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         EditMedicalHistoryPage(
                      //                           uid: widget.uid,
                      //                         )
                      //                 )
                      //             );
                      //           }
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }
                );
              }
            }
        ),
      ),
    );
  }
}
