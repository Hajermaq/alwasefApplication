import 'package:alwasef_app/models/report_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../constants.dart';

class CreateReportPage extends StatefulWidget {
  final String uid;
  final String prescriberID;
  final String pharmacistID;
  final String tradeName;
  CreateReportPage(
      {this.uid, this.pharmacistID, this.prescriberID, this.tradeName});
  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Report report = Report();
  List<String> yesNoAnswers = ['لا', 'نعم'];
  String temp1, temp2;
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
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      height: 20,
                      thickness: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 10.0),
                    child: Text(
                        'ينشئ هذا التقرير المريض اللذي انتهى من الوصفة\n أو بدأ بتناول الدواء فقط ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red)),
                  ),
                  SizedBox(height: 13),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'هل انتهيت من الوصفة الطبية؟',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: kRedColor,
                        ),
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      value: temp1,
                      items: yesNoAnswers.map((item) {
                        //to convert list items into dropdown menu items
                        return DropdownMenuItem(
                          child: Center(
                              child: Text(
                            item,
                            style: TextStyle(color: Colors.black54),
                          )),
                          value: item,
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? 'هذا الحقل مطلوب' : null,
                      onSaved: (selectedValue) {
                        setState(() {
                          report.prescriberID = widget.prescriberID;
                          report.pharmacistID = widget.pharmacistID;
                          report.tradeName = widget.tradeName;
                          report.completed = selectedValue;
                        });
                      },
                      onChanged: (selectedValue) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'هل التزمت بالوصفة الطبية؟',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: kRedColor,
                        ),
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      value: temp2,
                      items: yesNoAnswers.map((item) {
                        //to convert list items into dropdown menu items
                        return DropdownMenuItem(
                          child: Center(
                              child: Text(
                            item,
                            style: TextStyle(color: Colors.black54),
                          )),
                          value: item,
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? 'هذا الحقل مطلوب' : null,
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
                      style: TextStyle(color: Colors.black54),
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'هل ظهرت عليك أي أعراض جانبية :',
                        hintText: 'اذكرها',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: kRedColor,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        var valueAsList =
                            value.split('\n'); // save it as a list
                        valueAsList
                            .removeWhere((item) => item == ''); // remove ''
                        report.sideEffects = valueAsList;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black54),
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'ملاحظات :',
                        hintText: 'اذكرها',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: kRedColor,
                        ),
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              report.saveReport(widget.uid);
                              Flushbar(
                                backgroundColor: kLightColor,
                                borderRadius: 4.0,
                                margin: EdgeInsets.all(8.0),
                                duration: Duration(seconds: 2),
                                messageText: Text(
                                  ' تم إضافة تقرير لهذه الوصفة بنجاح',
                                  style: TextStyle(
                                    color: kBlueColor,
                                    fontFamily: 'Almarai',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )..show(context)
                                  .then((r) => Navigator.pop(context));
                            }
                          }),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                          child: Text('إلغاء'),
                          onPressed: () {
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
