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
  // final authM = FirebaseAuth.instance;
  // final fireM = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  List<String> maritalStatusList = ['أعزب', 'متزوج', 'غير ذلك'];
  List<String> yesNoAnswers = ['لا', 'نعم'];
  List<String> smokingList = ['لا أبدا', 'أحيانا', ' نعم دائما'];

  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  // final TextEditingController maritalSCtrl = TextEditingController();
  // final TextEditingController hospCtrl = TextEditingController();
  // final TextEditingController surgCtrl = TextEditingController();
  // final TextEditingController currMedCtrl = TextEditingController();
  // final TextEditingController chroDisCtrl = TextEditingController();
  // final TextEditingController allergCtrl = TextEditingController();
  // final TextEditingController medAllergCtrl = TextEditingController();

  String newInitialValue(String newIniVal) {
    return newIniVal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      //backgroundColor: ,
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
                DocumentSnapshot medicalHistory = snapshot.data;
                final age = Age.dateDifference(
                    fromDate:
                        DateTime.parse(medicalHistory.data()['bith date']),
                    toDate: DateTime.now(),
                    includeToDate: false);
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

                return ListView(scrollDirection: Axis.vertical, children: [
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
                      initialValue: medicalHistory.data()['weight'].toString(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                      //TODO: try onSaved
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference.update({'weight': value});
                        });
                        //newValWeight = value;
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
                      initialValue: medicalHistory.data()['height'].toString(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference.update({'height': value});
                        });
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
                      onChanged: (selectedValue) {
                        setState(() {
                          medicalHistory.reference
                              .update({'marital status': selectedValue});
                        });
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
                      onChanged: (selectedValue) {
                        setState(() {
                          medicalHistory.reference
                              .update({'smoking': selectedValue});
                        });
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
                      onChanged: (selectedValue) {
                        setState(() {
                          medicalHistory.reference
                              .update({'pregnancy': selectedValue});
                        });
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
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference
                              .update({'hospitalization': value.split('\n')});
                        });
                      },
                      //controller: hospCtrl,
                    ),
                  ),
                  //جراحة
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'هل خضعت لأي عملية جراحية من قبل :',
                        hintText: 'اكتب كل عملية في سطر',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: surgeryVal.join('\n'),
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference
                              .update({'surgery': value.split('\n')});
                        });
                      },
                      //controller: surgCtrl,
                    ),
                  ),
                  // //مرض مزمن
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'هل تعاني من أي أمراض مزمنة :',
                        hintText: 'اكتب كل مرض في سطر',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: chronicDisVal.join('\n'),
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference
                              .update({'chronic disease': value.split('\n')});
                        });
                      },
                      //controller: chroDisCtrl,
                    ),
                  ),
                  // //أدوية حالية
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'هل تتناول أي أدوية حاليا :',
                        hintText: 'اكتب كل دواء في سطر',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: currentMedVal.join('\n'),
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference.update(
                              {'current medications': value.split('\n')});
                        });
                      },
                      //controller: currMedCtrl,
                    ),
                  ),
                  //حساسية
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'هل تعاني من أي حساسية :',
                        hintText: 'اكتب كل حساسية في سطر',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: allergyVal.join('\n'),
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference
                              .update({'allergies': value.split('\n')});
                        });
                      },
                      //controller: allergCtrl,
                    ),
                  ),
                  //حساسية دوائية
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText:
                            'هل تعاني من أي حساسية تجاه نوع من الأدوية :',
                        hintText: 'اكتب كل نوع في سطر',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: medAllergyVal.join('\n'),
                      onChanged: (value) {
                        setState(() {
                          medicalHistory.reference.update(
                              {'medication allergies': value.split('\n')});
                        });
                      },
                      //controller: medAllergCtrl,
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text('حفظ التعديلات'),
                          onPressed: () {
                            if (!_formKey2.currentState.validate()) {
                              return;
                            }
                            _formKey2.currentState.reset();

                            weightCtrl.clear();
                            heightCtrl.clear();
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ]);
              }
            }),
      ),
    ));
  }
}
