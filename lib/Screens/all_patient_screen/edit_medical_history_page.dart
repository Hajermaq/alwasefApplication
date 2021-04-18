import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:age/age.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'package:collection/collection.dart';
import 'dart:math';


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



  bool somethingChanged = false;
  Function eq = const ListEquality().equals;
  Widget yesButton;
  Widget noButton;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kGreyColor,
        body: SafeArea(
          minimum: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Form(
            key: _formKey2,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/Patient')
                    .doc(widget.uid)
                    .collection('/Medical History')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(
                        backgroundColor: kGreyColor,
                        valueColor: AlwaysStoppedAnimation(kBlueColor))
                    );
                  } else {
                    DocumentSnapshot medicalHistory = snapshot.data.docs[0];
                    final age = Age.dateDifference(
                        fromDate: DateTime.parse(medicalHistory.get('birth date')),
                        toDate: DateTime.now(),
                        includeToDate: false);
                    String weightVal = medicalHistory.data()['weight'].toString();
                    String heightVal = medicalHistory.data()['height'].toString();
                    double heightInM = double.parse(heightVal) / 100;
                    String BMI = (double.parse(weightVal) / pow(heightInM, 2)).toStringAsFixed(2);

                    var maritalStatusVal = medicalHistory.data()['marital status'];
                    var smokingVal = medicalHistory.data()['smoking'];
                    var pregnancyVal = medicalHistory.data()['pregnancy'];
                    //Lists
                    var hospVal = medicalHistory.data()['hospitalization'];
                    var surgeryVal = medicalHistory.data()['surgery'];
                    var chronicDisVal = medicalHistory.data()['chronic disease'];
                    var currentMedVal =
                        medicalHistory.data()['current medications'];
                    var allergyVal = medicalHistory.data()['allergies'];
                    var medAllergyVal =
                        medicalHistory.data()['medication allergies'];

                    return Container(
                      child:
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column( children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'السجل الطبي للمريض ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                //Spacer(),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: Colors.white,
                                  ),
                                  child: PopupMenuButton<String>(
                                    offset: Offset(30,50),
                                    itemBuilder: (BuildContext context) {
                                      return ['حذف السجل الطبي'].map((e)  {
                                        return PopupMenuItem<String>(
                                          value: e,
                                          child: Text(e, style: TextStyle(color: Colors.black54)),
                                        );
                                      }).toList();
                                    },
                                    onSelected:(value) {
                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {
                                           yesButton = FlatButton(
                                               child: Text('نعم'),
                                               onPressed:() async {
                                                 await FirebaseFirestore.instance
                                                     .collection('/Patient')
                                                     .doc(widget.uid)
                                                     .collection('/Medical History')
                                                     .doc(medicalHistory.id)
                                                     .delete();
                                                 Navigator.pop(context); //TODO: gives error in previous page
                                                 Navigator.pop(context);
                                                 //Navigator.popUntil(context, ModalRoute.withName('/PatientMainPage'));
                                                 //Navigator.pushNamed(context,WelcomeScreen.id);


                                               }
                                           );
                                           noButton = FlatButton(
                                               child: Text('لا'),
                                               onPressed:() {
                                                 Navigator.pop(context);
                                               },
                                           );

                                           return AlertDialog(
                                             title: Text('هل أنت متأكد من حذف السجل الصحي؟',
                                                 textAlign: TextAlign.center
                                             ),
                                             titleTextStyle: TextStyle(
                                                 color: Colors.black54,
                                                 fontSize: 15,
                                                 fontWeight: FontWeight.bold,
                                                 fontFamily: 'Almarai',
                                             ),
                                             content: Text('قد يؤدي ذلك إلى ضعف الخدمة المقدمة لك '),
                                             contentTextStyle: TextStyle(
                                               color: Colors.black54,
                                               fontSize: 15,
                                               fontWeight: FontWeight.bold,
                                               fontFamily: 'Almarai',
                                             ),
                                             actions: [
                                               yesButton,
                                               noButton
                                             ],
                                             shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.all(Radius.circular(13)),
                                             ),
                                             elevation: 24.0,
                                             backgroundColor: Colors.white,
                                           );
                                         }
                                       );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 20,
                                thickness: 5,
                              ),
                            ),
                            //الاسم
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
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
                                style: TextStyle(color: Colors.black54),
                                decoration: InputDecoration(
                                  labelText: 'الجنس:',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.wc_outlined),
                                ),
                                initialValue: medicalHistory.data()['gender'],
                                readOnly: true,
                              ),
                            ),
                            //تاريخ الميلاد
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
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
                            Padding( //TODO: How to update age in database?
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
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
                                style: TextStyle(color: Colors.black54),
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
                                      medicalHistory.reference.update({'weight': double.parse(value)});
                                      this.somethingChanged = true;
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
                                style: TextStyle(color: Colors.black54),
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
                                      medicalHistory.reference.update({'height': double.parse(value)});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                                //controller: heightCtrl,
                              ),
                            ),
                            //مؤشر كتلة الجسم
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'مؤشر كتلة الجسم :',
                                  suffixText: 'كجم/ متر2',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: BMI,
                                readOnly: true,
                              ),
                            ),
                            //الحالة الاجتماعية
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: 'الحالة الاجتماعية :',
                                  border: OutlineInputBorder(),
                                ),
                                icon: Icon(Icons.arrow_drop_down),
                                value: maritalStatusVal,
                                items: maritalStatusList.map((item) {
                                  //to convert list items into dropdown menu items
                                  return DropdownMenuItem(
                                    child: Center(child: Text(item, style: TextStyle(color: Colors.black54))),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {},
                                onSaved: (selectedValue) {
                                  if (maritalStatusVal != selectedValue){
                                    setState(() {
                                      medicalHistory.reference.update({'marital status': selectedValue});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            //التدخين
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: 'هل تدخن :',
                                  border: OutlineInputBorder(),
                                ),
                                icon: Icon(Icons.arrow_drop_down),
                                value: smokingVal,
                                items: smokingList.map((item) {
                                  //to convert list items into dropdown menu items
                                  return DropdownMenuItem(
                                    child: Center(child: Text(item, style: TextStyle(color: Colors.black54))),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {},
                                onSaved: (selectedValue) {
                                  if (smokingVal != selectedValue){
                                    setState(() {
                                      medicalHistory.reference.update({'smoking': selectedValue});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            //الحمل
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: 'هل هناك احتمال حمل :',
                                  border: OutlineInputBorder(),
                                ),
                                value: pregnancyVal,
                                items: yesNoAnswers.map((item) {
                                  //to convert list items into dropdown menu items
                                  return DropdownMenuItem(
                                    child: Center(child: Text(item, style: TextStyle(color: Colors.black54))),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {},
                                onSaved: (selectedValue) {
                                  if (pregnancyVal != selectedValue){
                                    setState(() {
                                      medicalHistory.reference.update({'pregnancy': selectedValue});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            // التنويم
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'هل سبق أن تم تنويمك في المستشفى :',
                                  hintText: 'اكتب كل سبب في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: hospVal.join('\n'),
                                onSaved: (value) {
                                  var valueAsList = value.split('\n');  //save value as a list
                                  valueAsList.removeWhere((item) => item == '');  //remove ''
                                  if (eq(valueAsList, hospVal) == false){
                                    setState(() {
                                      medicalHistory.reference.update({'hospitalization': valueAsList});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },

                                //controller: hospCtrl,
                              ),
                            ),
                            //جراحة
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'هل خضعت لأي عملية جراحية من قبل :',
                                  hintText: 'اكتب كل عملية في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: surgeryVal.join('\n'),
                                onSaved: (value) {
                                  var valueAsList = value.split('\n');  //save value as a list
                                  valueAsList.removeWhere((item) => item == '');  //remove ''
                                  if (eq(valueAsList, surgeryVal) == false){
                                    setState(() {
                                      medicalHistory.reference.update({'surgery': valueAsList});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                                //controller: surgCtrl,
                              ),
                            ),
                            // //مرض مزمن
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'هل تعاني من أي أمراض مزمنة :',
                                  hintText: 'اكتب كل مرض في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: chronicDisVal.join('\n'),
                                onSaved: (value) {
                                  var valueAsList = value.split('\n');  //save value as a list
                                  valueAsList.removeWhere((item) => item == '');  //remove ''
                                  if (eq(valueAsList, chronicDisVal) == false){
                                    setState(() {
                                      medicalHistory.reference.update({'chronic disease': valueAsList});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                                //controller: chroDisCtrl,
                              ),
                            ),
                            // //أدوية حالية
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'هل تتناول أي أدوية حاليا :',
                                  hintText: 'اكتب كل دواء في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: currentMedVal.join('\n'),
                                onSaved: (value) {
                                  var valueAsList = value.split('\n');  //save value as a list
                                  valueAsList.removeWhere((item) => item == '');  //remove ''
                                  if (eq(valueAsList, currentMedVal) == false){
                                    setState(() {
                                      medicalHistory.reference.update({'current medications': valueAsList});
                                      this.somethingChanged = true;
                                      print('current');
                                    });
                                  }
                                },
                                //controller: currMedCtrl,
                              ),
                            ),
                            //حساسية
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'هل تعاني من أي حساسية :',
                                  hintText: 'اكتب كل حساسية في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: allergyVal.join('\n'),
                                onSaved: (value) {
                                  var valueAsList = value.split('\n');  //save value as a list
                                  valueAsList.removeWhere((item) => item == '');  //remove ''
                                  if (eq(valueAsList, allergyVal) == false){
                                    setState(() {
                                      medicalHistory.reference.update({'allergies': valueAsList});
                                      this.somethingChanged = true;
                                      print('allerg');
                                    });
                                  }
                                },
                                //controller: allergCtrl,
                              ),
                            ),
                            //حساسية دوائية
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black54),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText:
                                      'هل تعاني من أي حساسية تجاه نوع من الأدوية :',
                                  hintText: 'اكتب كل نوع في سطر',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: medAllergyVal.join('\n'),
                                onSaved: (value) {
                                  var valueAsList = value.split('\n');  //save value as a list
                                  valueAsList.removeWhere((item) => item == '');  //remove ''
                                  if (eq(valueAsList, medAllergyVal) == false){
                                    setState(() {
                                      medicalHistory.reference.update({'medication allergies': valueAsList});
                                      this.somethingChanged = true;
                                    });
                                  }
                                },
                                //controller: medAllergCtrl,
                              ),
                            ),

                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        child: Text('حفظ التعديلات'),
                                        onPressed: () {
                                          if (_formKey2.currentState.validate()) {
                                            _formKey2.currentState.save();
                                          }
                                          if (somethingChanged){
                                            this.somethingChanged = false;
                                            Flushbar(
                                              backgroundColor: kLightColor,
                                              borderRadius: 4.0,
                                              margin: EdgeInsets.all(8.0),
                                              duration: Duration(seconds: 2),
                                              messageText: Text(' تم تعديل السجل الطبي الخاص بك بنجاح',
                                                style: TextStyle(color: kBlueColor, fontFamily: 'Almarai', ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )..show(context).then((r) => Navigator.pop(context));
                                          }
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        child: Text('تراجع'),
                                        onPressed: () {
                                          this.somethingChanged = false;
                                          //resets the form to its initial value before the changes
                                          _formKey2.currentState.reset();
                                          Navigator.pop(context);
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
