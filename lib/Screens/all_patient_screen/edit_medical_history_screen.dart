import 'package:alwasef_app/Screens/all_patient_screen/patients_mainpage.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/models/medical_history_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:age/age.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'fill_medical_history_screen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:age/age.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';

class EditMedicalHistoryPage extends StatefulWidget {
  final String uid;
  EditMedicalHistoryPage({this.uid});
  static const String id = 'edit_medical_history2';

  @override
  _EditMedicalHistoryPageState createState() => _EditMedicalHistoryPageState();
}

class _EditMedicalHistoryPageState extends State<EditMedicalHistoryPage> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  List<String> maritalStatusList = ['أعزب', 'متزوج', 'غير ذلك'];
  List<String> yesNoAnswers = ['لا', 'نعم'];
  List<String> smokingList = ['لا أبدا', 'أحيانا', ' نعم دائما'];

  final snackBar = SnackBar(
      content: Text('تم تعديل السجل الطبي الخاص بك'));

  bool somethingChanged = false;
  Function eq = const ListEquality().equals;

  // TextEditingController weightCtrl,
  //     heightCtrl;
  //
  // void iniState() {
  //   super.initState();
  //   // weightCtrl = TextEditingController();
  //   // heightCtrl = TextEditingController();
  //
  // }
  String first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: kGreyColor,
        body: SafeArea(
          child: Form(
            key: _formKey2,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/Patient')
                    .doc(widget.uid)
                    .collection('/Medical History')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    DocumentSnapshot medicalHistory = snapshot.data.docs[0]; //TODO: gives error in nuha
                    final age = Age.dateDifference(
                        fromDate: DateTime.parse(medicalHistory.get('birth date')),
                        toDate: DateTime.now(),
                        includeToDate: false);
                    var weightVal = medicalHistory.data()['weight'].toString();
                    var heightVal = medicalHistory.data()['height'].toString();
                    var maritalStatusVal = medicalHistory.data()['marital status'];
                    var smokingVal = medicalHistory.data()['smoking'];
                    var pregnancyVal = medicalHistory.data()['pregnancy'];
                    var hospVal = medicalHistory.data()['hospitalization'];
                    var surgeryVal = medicalHistory.data()['surgery'];
                    var chronicDisVal = medicalHistory.data()['chronic disease'];
                    var currentMedVal =
                        medicalHistory.data()['current medications'];
                    var allergyVal = medicalHistory.data()['allergies'];
                    var medAllergyVal =
                        medicalHistory.data()['medication allergies'];

                    //ListView(scrollDirection: Axis.vertical, children: [
                    return Container(
                      child:
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column( children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'السجل الطبي للمريض ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 20,
                                thickness: 10,
                              ),
                            ),
                            //الاسم
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'الاسم الكامل:',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                initialValue: medicalHistory.data()['full name'],
                                readOnly: true,
                              ),
                            ),
                            //الجنس
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'الجنس:',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.wc_sharp),
                                ),
                                initialValue: medicalHistory.data()['gender'],
                              ),
                            ),
                            //تاريخ الميلاد
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'تاريخ الميلاد:',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                initialValue: medicalHistory.data()['birth date'],
                                readOnly: true,
                              ),
                            ),
                            //العمر
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'العمر :',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: age.years.toString(),
                                readOnly: true,
                              ),
                            ),
                            //الوزن
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'الوزن :',
                                  suffixText: 'كلجم',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: weightVal,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '* هذا الحقل مطلوب';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (weightVal != value){
                                    setState(() {
                                      medicalHistory.reference.update({'weight': value});
                                      somethingChanged = true;
                                    });
                                  }
                                },
                                //controller: weightCtrl,
                              ),
                            ),
                            //الطول
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'الطول :',
                                  suffixText: 'سم',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: heightVal,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '* هذا الحقل مطلوب';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (heightVal != value){
                                    setState(() {
                                      medicalHistory.reference.update({'height': value});
                                      somethingChanged = true;
                                    });
                                  }
                                },
                                //controller: heightCtrl,
                              ),
                            ),
                            //الحالة الاجتماعية
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.black,
                                decoration: InputDecoration(
                                  labelText: 'الحالة الاجتماعية :',
                                  border: OutlineInputBorder(),
                                ),
                                icon: Icon(Icons.arrow_drop_down),
                                value: maritalStatusVal,
                                items: maritalStatusList.map((item) {
                                  //to convert list items into dropdown menu items
                                  return DropdownMenuItem(
                                    child: Center(child: Text(item)),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {},
                                onSaved: (selectedValue) {
                                  if (maritalStatusVal != selectedValue){
                                    setState(() {
                                      medicalHistory.reference.update({'marital status': selectedValue});
                                      somethingChanged = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            //التدخين
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.black,
                                decoration: InputDecoration(
                                  labelText: 'هل تدخن :',
                                  border: OutlineInputBorder(),
                                ),
                                icon: Icon(Icons.arrow_drop_down),
                                value: smokingVal,
                                items: smokingList.map((item) {
                                  //to convert list items into dropdown menu items
                                  return DropdownMenuItem(
                                    child: Center(child: Text(item)),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {},
                                onSaved: (selectedValue) {
                                  medicalHistory.reference.update({'smoking': selectedValue});
                                  somethingChanged = true;
                                },
                              ),
                            ),
                            //الحمل
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.black,
                                decoration: InputDecoration(
                                  labelText: 'هل هناك احتمال حمل :',
                                  border: OutlineInputBorder(),
                                ),
                                value: pregnancyVal,
                                items: yesNoAnswers.map((item) {
                                  //to convert list items into dropdown menu items
                                  return DropdownMenuItem(
                                    child: Center(child: Text(item)),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {},
                                onSaved: (selectedValue) {
                                  if (pregnancyVal != selectedValue){
                                    setState(() {
                                      medicalHistory.reference.update({'pregnancy': selectedValue});
                                      somethingChanged = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            //التنويم
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'هل سبق أن تم تنويمك في المستشفى :',
                                  hintText: 'اكتب كل سبب في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: hospVal.join('\n'),
                                onSaved: (value) {
                                  print('-----------');
                                  print(hospVal); //list of initial value
                                  print(value);
                                  print(value.split('\n'));  //list of value

                                  //TODO: remove empty string from value
                                  var valueAsList = value.split('\n');  //
                                  //listValue.remo;
                                  if (eq(valueAsList, hospVal)){
                                    setState(() {
                                      medicalHistory.reference.update({'hospitalization': valueAsList});
                                      somethingChanged = true;
                                    });
                                  }
                                },

                                //controller: hospCtrl,
                              ),
                            ),
                            // //جراحة
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     maxLines: 5,
                            //     decoration: InputDecoration(
                            //       labelText: 'هل خضعت لأي عملية جراحية من قبل :',
                            //       hintText: 'اكتب كل عملية في سطر',
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     initialValue: surgeryVal.join('\n'),
                            //     onSaved: (value) {
                            //       var listValue = value.split('\n'); //save as a list
                            //       if (surgeryVal != listValue){
                            //         setState(() {
                            //           medicalHistory.reference.update({'surgery': value.split('\n')});
                            //           somethingChanged = true;
                            //         });
                            //       }
                            //     },
                            //     //controller: surgCtrl,
                            //   ),
                            // ),
                            // // //مرض مزمن
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     maxLines: 5,
                            //     decoration: InputDecoration(
                            //       labelText: 'هل تعاني من أي أمراض مزمنة :',
                            //       hintText: 'اكتب كل مرض في سطر',
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     initialValue: chronicDisVal.join('\n'),
                            //     onSaved: (value) {
                            //       var listValue = value.split('\n'); //save as a list
                            //       if (chronicDisVal != listValue){
                            //         setState(() {
                            //           medicalHistory.reference.update({'chronic disease': value.split('\n')});
                            //           somethingChanged = true;
                            //         });
                            //       }
                            //     },
                            //     //controller: chroDisCtrl,
                            //   ),
                            // ),
                            // // //أدوية حالية
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     maxLines: 5,
                            //     decoration: InputDecoration(
                            //       labelText: 'هل تتناول أي أدوية حاليا :',
                            //       hintText: 'اكتب كل دواء في سطر',
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     initialValue: currentMedVal.join('\n'),
                            //     onSaved: (value) {
                            //       var listValue = value.split('\n'); //save as a list
                            //       if (currentMedVal != listValue){
                            //         setState(() {
                            //           medicalHistory.reference.update({'current medications': value.split('\n')});
                            //           somethingChanged = true;
                            //         });
                            //       }
                            //     },
                            //     //controller: currMedCtrl,
                            //   ),
                            // ),
                            // //حساسية
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     maxLines: 5,
                            //     decoration: InputDecoration(
                            //       labelText: 'هل تعاني من أي حساسية :',
                            //       hintText: 'اكتب كل حساسية في سطر',
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     initialValue: allergyVal.join('\n'),
                            //     onSaved: (value) {
                            //       var listValue = value.split('\n'); //save as a list
                            //       if (allergyVal != listValue){
                            //         setState(() {
                            //           medicalHistory.reference.update({'allergies': value.split('\n')});
                            //           somethingChanged = true;
                            //         });
                            //       }
                            //     },
                            //     //controller: allergCtrl,
                            //   ),
                            // ),
                            // //حساسية دوائية
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     maxLines: 5,
                            //     decoration: InputDecoration(
                            //       labelText:
                            //           'هل تعاني من أي حساسية تجاه نوع من الأدوية :',
                            //       hintText: 'اكتب كل نوع في سطر',
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     initialValue: medAllergyVal.join('\n'),
                            //     onSaved: (value) {
                            //       var listValue = value.split('\n'); //save as a list
                            //       if (medAllergyVal != listValue){
                            //         setState(() {
                            //           medicalHistory.reference.update({'medication allergies': value.split('\n')});
                            //           somethingChanged = true;
                            //         });
                            //       }
                            //     },
                            //     //controller: medAllergCtrl,
                            //   ),
                            // ),

                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        child: Text('حفظ التعديلات'),
                                        onPressed: () {
                                          if (!_formKey2.currentState.validate()) {
                                            return ;
                                          }
                                          // print(somethingChanged);
                                          _formKey2.currentState.save();
                                          // print(somethingChanged);
                                          //
                                          // if (somethingChanged){
                                          //   Scaffold.of(context).showSnackBar(snackBar);
                                            // somethingChanged = false;
                                          // }
                                          //Navigator.pop(context);
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        child: Text('تراجع'),
                                        onPressed: () {
                                          somethingChanged = false;
                                          //resets the form to its initial value before the changes
                                          _formKey2.currentState.reset();
                                          //Navigator.pop(context);
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                    );
                  }
                }),
          ),
    ));
  }
}
