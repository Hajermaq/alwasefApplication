import 'package:alwasef_app/models/medical_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class FillMedicalHistoryPage extends StatefulWidget {
  final String uid;
  FillMedicalHistoryPage({this.uid});
  static const String id = 'fill_medical_history';
  @override
  _FillMedicalHistoryPageState createState() => _FillMedicalHistoryPageState();
}

class _FillMedicalHistoryPageState extends State<FillMedicalHistoryPage> {
  final authM = FirebaseAuth.instance;
  final fireM = FirebaseFirestore.instance;
  MedicalHistory medicalHistory = MedicalHistory();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  List<String> genderList = ['ذكر', 'أنثى'];
  List<String> maritalStatusList = ['أعزب', 'متزوج', 'غير ذلك'];
  List<String> yesNoAnswers = ['لا', 'نعم'];
  List<String> smokingList = ['لا أبدا', 'أحيانا', ' نعم دائما'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyColor,
      body: SafeArea(
        minimum: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'السجل الطبي للمريض ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      if (value.length < 10) {
                        return 'أدخل اسمك الكامل';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      medicalHistory.patientFullName = value;
                      medicalHistory.patientUID = authM.currentUser.uid;
                    },
                    //controller: nameCtrl,
                  ),
                ),

                //الجنس
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'الجنس:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wc_outlined),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    value: medicalHistory.gender,
                    items: genderList.map((item) {
                      //to convert list items into dropdown menu items
                      return DropdownMenuItem(
                        child: Center(
                            child: Text(item,
                                style: TextStyle(color: Colors.black54))),
                        value: item,
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'هذاالحقل مطلوب' : null,
                    onSaved: (selectedValue) {
                      setState(() {
                        medicalHistory.gender = selectedValue;
                      });
                    },
                    onChanged: (selectedValue) {},
                  ),
                ),

                //تاريخ الميلاد
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimeField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'تاريخ الميلاد:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    format: dateFormat,
                    validator: (value) =>
                        value == null ? 'هذا الحقل مطلوب' : null,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: kGreyColor,
                                onPrimary: klighterColor,
                                surface: kLightColor,
                              ),
                            ),
                            child: child,
                          );
                        },
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                    },
                    onSaved: (date) {
                      medicalHistory.birthDate = dateFormat.format(date);
                    },
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      medicalHistory.weight = double.parse(value);
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      medicalHistory.height = double.parse(value);
                    },
                    //controller: heightCtrl,
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
                    value: medicalHistory.maritalStatus,
                    items: maritalStatusList.map((item) {
                      //to convert list items into dropdown menu items
                      return DropdownMenuItem(
                        child: Center(
                            child: Text(item,
                                style: TextStyle(color: Colors.black54))),
                        value: item,
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'هذا الحقل مطلوب' : null,
                    onSaved: (selectedValue) {
                      setState(() {
                        medicalHistory.maritalStatus = selectedValue;
                      });
                    },
                    onChanged: (selectedValue) {},
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
                    value: medicalHistory.smoking,
                    items: smokingList.map((item) {
                      //to convert list items into dropdown menu items
                      return DropdownMenuItem(
                        child: Center(
                            child: Text(item,
                                style: TextStyle(color: Colors.black54))),
                        value: item,
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'هذا الحقل مطلوب' : null,
                    onSaved: (selectedValue) {
                      setState(() {
                        medicalHistory.smoking = selectedValue;
                      });
                    },
                    onChanged: (selectedValue) {},
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
                    value: medicalHistory.pregnancy,
                    items: yesNoAnswers.map((item) {
                      //to convert list items into dropdown menu items
                      return DropdownMenuItem(
                        child: Center(
                            child: Text(item,
                                style: TextStyle(color: Colors.black54))),
                        value: item,
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'هذا الحقل مطلوب' : null,
                    onSaved: (selectedValue) {
                      setState(() {
                        medicalHistory.pregnancy = selectedValue;
                      });
                    },
                    onChanged: (selectedValue) {},
                  ),
                ),

                //تنويم
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'هل سبق أن تم تنويمك في المستشفى :',
                      hintText: 'اكتب كل سبب في سطر',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      var valueAsList = value.split('\n'); // save it as a list
                      valueAsList
                          .removeWhere((item) => item == ''); // remove ''
                      medicalHistory.hospitalizations = valueAsList;
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
                    onSaved: (value) {
                      var valueAsList = value.split('\n'); // save it as a list
                      valueAsList
                          .removeWhere((item) => item == ''); // remove ''
                      medicalHistory.surgery = valueAsList;
                    },
                    //controller: surgCtrl,
                  ),
                ),

                //مرض مزمن
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'هل تعاني من أي أمراض مزمنة :',
                      hintText: 'اكتب كل مرض في سطر',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      var valueAsList = value.split('\n'); // save it as a list
                      valueAsList.removeWhere((item) => item == '');
                      medicalHistory.chronicDisease = valueAsList;
                    },
                    //controller: chroDisCtrl,
                  ),
                ),

                //أدوية حالية
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'هل تتناول أي أدوية حاليا :',
                      hintText: 'اكتب كل دواء في سطر',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      var valueAsList = value.split('\n'); // save it as a list
                      valueAsList.removeWhere((item) => item == '');
                      medicalHistory.currentMed = valueAsList;
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
                    onSaved: (value) {
                      var valueAsList = value.split('\n'); // save it as a list
                      valueAsList.removeWhere((item) => item == '');
                      medicalHistory.allergies = valueAsList;
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
                      labelText: 'هل تعاني من أي حساسية تجاه نوع من الأدوية :',
                      hintText: 'اكتب كل نوع في سطر',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      var valueAsList = value.split('\n'); // save it as a list
                      valueAsList.removeWhere((item) => item == '');
                      medicalHistory.medAllergies = valueAsList;
                    },
                    //controller: medAllergCtrl,
                  ),
                ),

                Divider(
                  height: 20,
                  thickness: 3,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 10.0),
                  child: Text(
                      'تأكد من صحة المعلومات التي تقدمها لأن ذلك يحسن من الخدمة المقدة لك ',
                      textAlign: TextAlign.center),
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            child: Text('حفظ'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                medicalHistory.saveMedicalHistoryForm(
                                    authM.currentUser.uid);
                                Flushbar(
                                  backgroundColor: kLightColor,
                                  borderRadius: 4.0,
                                  margin: EdgeInsets.all(8.0),
                                  duration: Duration(seconds: 2),
                                  messageText: Text(
                                    ' تم إنشاء السجل الطبي الخاص بك بنجاح',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            child: Text('إلغاء'),
                            onPressed: () {
                              _formKey.currentState.reset();
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
