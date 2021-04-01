import 'package:alwasef_app/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class CreateReportPage extends StatefulWidget {
  final String uid;
  final String prescriptionRefID;
  CreateReportPage({this.uid, this.prescriptionRefID});
  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
Report report = Report();
List<String> yesNoAnswers = ['لا', 'نعم'];
final snackBar = SnackBar(
    content: Text(' تم إضافة تقرير لهذه الوصفة بنجاح'));
String temp1, temp2;

class _CreateReportPageState extends State<CreateReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kGreyColor,
      body: Builder(
        builder:(context) => SafeArea(
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
                      thickness: 10,
                    ),
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
                          report.prescriptionRefID = widget.prescriptionRefID;
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
                            setState((){
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                report.saveReport(widget.uid);
                                Scaffold.of(context).showSnackBar(snackBar);
                                Navigator.pop(context);
                              }
                            });
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
