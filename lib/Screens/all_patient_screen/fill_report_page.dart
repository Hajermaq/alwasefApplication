import 'package:alwasef_app/models/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../constants.dart';


class CreateReportPage extends StatefulWidget {
  final String uid;
  final String name;
  final String prescriberID;
  final String pharmacistID;
  final String tradeName;
  CreateReportPage({this.uid, this.name, this.pharmacistID, this.prescriberID, this.tradeName});
  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Report report = Report();
  List<String> yesNoAnswers = ['لا', 'نعم'];
  String prescriperName;
  String pharmacistName;
  String temp1, temp2;

  getPrescriberName(String prescriberID) async{
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(prescriberID)
        .get()
        .then((doc) {
      prescriperName = doc.data()['doctor-name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  getPharmacistName(String pharmacistID) async{
    await FirebaseFirestore.instance
        .collection('/Pharmacist')
        .doc(pharmacistID)
        .get()
        .then((doc) {
      pharmacistName = doc.data()['pharmacist-name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getPrescriberName(widget.prescriberID);
    getPharmacistName(widget.pharmacistID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyColor,
      body: Builder(
        builder: (BuildContext context) => SafeArea(
            minimum: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(

                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'التقرير ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        height: 20,
                        thickness: 6,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 10.0),
                      child: Text(
                          'ينشئ هذا التقرير المريض اللذي انتهى من الوصفة\n أو بدأ بتناول الدواء فقط ',
                          textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'هل انتهيت من الوصفة الطبية؟',
                        ),
                        icon: Icon(Icons.arrow_drop_down),
                        value: temp1,
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
                            report.patientID = widget.uid;
                            report.patientName = widget.name;
                            report.prescriberName = prescriperName;
                            report.pharmacistName = pharmacistName;
                            report.tradeName = widget.tradeName;
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
                        value: temp2,
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          var valueAsList = value.split('\n'); // save it as a list
                          valueAsList.removeWhere((item) => item == ''); // remove ''
                          report.sideEffects = valueAsList;
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          report.notes = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            child: Text('حفظ'),
                            onPressed: (){
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                report.saveReport(widget.uid);
                                Flushbar(
                                  backgroundColor: kLightColor,
                                  borderRadius: 4.0,
                                  margin: EdgeInsets.all(8.0),
                                  duration: Duration(seconds: 2),
                                  messageText: Text(' تم إضافة تقرير لهذه الوصفة بنجاح',
                                    style: TextStyle(color: kBlueColor, fontFamily: 'Almarai', ),
                                    textAlign: TextAlign.center,
                                  ),
                                )..show(context).then((r) => Navigator.pop(context));
                              }
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                            child: Text('إلغاء'),
                            onPressed: (){
                              _formKey.currentState.reset();
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
