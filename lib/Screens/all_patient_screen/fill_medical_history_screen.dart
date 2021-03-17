import 'package:alwasef_app/Screens/all_patient_screen/edit_medical_history_screen.dart';
import 'package:alwasef_app/Screens/all_patient_screen/patients_mainpage.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/models/medical_history_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:age/age.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
  final GlobalKey<FormState>_formKey = new GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  List<String> genderList = ['ذكر', 'أنثى'];
  List<String> maritalStatusList = ['أعزب', 'متزوج', 'غير ذلك'];
  List<String> yesNoAnswers = ['لا', 'نعم'];
  List<String> smokingList = ['لا أبدا', 'أحيانا', ' نعم دائما'];

  TextEditingController nameCtrl,
      birthDateCtrl,
      ageCtrl,
      weightCtrl,
      heightCtrl,
      hospCtrl,
      surgCtrl,
      currMedCtrl,
      chroDisCtrl,
      allergCtrl,
      medAllergCtrl;


  void iniState() {
    super.initState();
    nameCtrl = TextEditingController();
    ageCtrl = TextEditingController();
    weightCtrl = TextEditingController();
    heightCtrl = TextEditingController();
    hospCtrl = TextEditingController();
    surgCtrl = TextEditingController();
    currMedCtrl = TextEditingController();
    chroDisCtrl = TextEditingController();
    allergCtrl = TextEditingController();
    medAllergCtrl = TextEditingController();
  }

  // void dispose(){
  //   // nameCtrl.dispose();
  //   // ageCtrl.dispose();
  //   // weightCtrl.dispose();
  //   // heightCtrl.dispose();
  //   // hospCtrl.dispose();
  //   // surgCtrl.dispose();
  //   // currMedCtrl.dispose();
  //   // chroDisCtrl.dispose();
  //   // allergCtrl.dispose();
  //   // medAllergCtrl.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Form(key: _formKey, child: ListView(
            padding: EdgeInsets.all(8.0),
            children: [

              //TODO: check forms validations

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
                    return null;
                  },
                  onSaved: (value) {
                    medicalHistory.patientFullName = value;
                    medicalHistory.patientUID = authM.currentUser.uid;
                  },
                  onChanged: (value) {
                    _formKey.currentState.validate();
                  },
                  //controller: nameCtrl,
                ),
              ),

              //الجنس
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  dropdownColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'الجنس:',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.wc_sharp),
                  ),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  value: medicalHistory.gender,
                  items: genderList.map((item) {
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
                  onChanged: (selectedValue) {
                    setState(() {
                      medicalHistory.gender = selectedValue;
                    });
                  },
                ),
              ),

              //TODO: use DatePicker class
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
                  value == null
                      ? 'هذا الحقل مطلوب'
                      : null,
                  onShowPicker: (context, currentValue){
                    return showDatePicker(
                        context: context,
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now()
                    );
                  },
                  onChanged: (date){
                    medicalHistory.birthDate = dateFormat.format(date);
                  },
                ),
              ),

              //العمر
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'العمر :',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                  //TODO: auto age calculate after choosing birth date? see if possible
                  onChanged: (value) {
                    medicalHistory.age = int.parse(value);
                    // age = Age.dateDifference(
                    //     fromDate: birthDate, toDate: DateTime.now(), includeToDate: false) as int;
                    // initialValue: Age.dateDifference(
                    //     fromDate: DateTime.parse(medicalHistory.birthDate),
                    //     toDate: DateTime.now(),
                    //     includeToDate: false).years.toString(),
                  },
                  controller: ageCtrl,
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
                  onChanged: (value) {
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
                  onChanged: (value) {
                    medicalHistory.height = double.parse(value);
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
                  value: medicalHistory.maritalStatus,
                  items: maritalStatusList.map((item) {
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
                  onChanged: (selectedValue) {
                    setState(() {
                      medicalHistory.maritalStatus = selectedValue;
                    });
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text('حفظ'),
                        onPressed: () {
                          setState((){
                            if (_formKey.currentState.validate()) {
                              //_formKey.currentState.save();
                              //medicalHistory.saveMedicalHistoryForm(authM.currentUser.uid);
                              //_formKey.currentState.reset();
                              //print(_formKey.currentState);
                              print('valid');

                              // final snackBar = SnackBar(content: Text('تم إنشاء ملف التاريخ الطبي الخاص بك'));
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              //Navigator.pop(context);
                            }
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text('إلغاء'),
                        onPressed: () {
                          //_formKey.currentState.reset();
                          Navigator.pop(context);
                        }
                    ),
                  ),
                ],
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
                  value: medicalHistory.smoking,
                  items: smokingList.map((item) {
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
                  onChanged: (selectedValue) {
                    setState(() {
                      medicalHistory.smoking = selectedValue;
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
                  value: medicalHistory.pregnancy,
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
                  onChanged: (selectedValue) {
                    setState(() {
                      medicalHistory.pregnancy = selectedValue;
                    });
                  },
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
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    medicalHistory.hospitalizations = value.split('\n');
                    //TODO: remove null values from list before saving it.
                  },
                  controller: hospCtrl,
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
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    medicalHistory.surgery = value.split('\n');
                  },
                  controller: surgCtrl,
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
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    medicalHistory.chronicDisease = value.split('\n');
                  },
                  controller: chroDisCtrl,
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
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    medicalHistory.currentMed = value.split('\n');
                  },
                  controller: currMedCtrl,
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
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    medicalHistory.allergies = value.split('\n');
                  },
                  controller: allergCtrl,
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
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'هذا الحقل مطلوب';
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    medicalHistory.medAllergies = value.split('\n');
                  },
                  controller: medAllergCtrl,
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
                            setState((){
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                medicalHistory.saveMedicalHistoryForm(authM.currentUser.uid);
                                //_formKey.currentState.reset();
                                print(_formKey.currentState);
                                //print(nameCtrl.text);

                                // final snackBar = SnackBar(content: Text('تم إنشاء السجل الطبي الخاص بك'));
                                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                //Navigator.pop(context);
                              }
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text('إلغاء'),
                          onPressed: () {
                            // nameCtrl.clear();
                            // ageCtrl.clear();
                            // weightCtrl.clear();
                            // heightCtrl.clear();
                            // hospCtrl.clear();
                            // surgCtrl.clear();
                            // currMedCtrl.clear();
                            // chroDisCtrl.clear();
                            // allergCtrl.clear();
                            // medAllergCtrl.clear();
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        )
    );
  }


//   EditMedicalHistoryPage objectOfMH(){
//     EditMedicalHistoryPage newObj = EditMedicalHistoryPage(
//       initialValName: medicalHistory.patientFullName,
//       initialValGender: medicalHistory.gender,
//       initialValAge: medicalHistory.age,
//       initialValBirthDate: medicalHistory.birthDate,
//       initialValWeight: medicalHistory.weight,
//       initialValHeight: medicalHistory.height,
//       initialValMaritalStatus: medicalHistory.maritalStatus,
//       initialValPregnancy: medicalHistory.pregnancy,
//       initialValSmoking: medicalHistory.smoking,
//       initialValHospitalization: medicalHistory.hospitalizations,
//       initialValSurgery: medicalHistory.surgery,
//       initialValCurrentMed: medicalHistory.currentMed,
//       initialValChronicDisease: medicalHistory.chronicDisease,
//       initialValAllergies: medicalHistory.allergies,
//       initialValMedAllergies: medicalHistory.medAllergies,
//     );
//     String newVal = medicalHistory.patientFullName;
//   return newVal;
// }
// static String objectOfMH(){
//   String newVal = medicalHistory.patientFullName;
//   return newVal;
// }

}
