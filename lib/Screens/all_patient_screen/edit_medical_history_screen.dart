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
import '../../constants.dart';
import 'fill_medical_history_screen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class EditMedicalHistoryPage extends StatefulWidget {
  static const String id = 'edit_medical_history';
  @override
  _EditMedicalHistoryPageState createState() => _EditMedicalHistoryPageState();
}

class _EditMedicalHistoryPageState extends State<EditMedicalHistoryPage> {

  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  List<String> genderList = ['ذكر', 'أنثى'];
  List<String> maritalStatusList = ['أعزب', 'متزوج', 'غير ذلك'];
  List<String> yesNoAnswers = ['لا', 'نعم'];
  List<String> smokingList = ['لا أبدا', 'أحيانا', ' نعم دائما'];

  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  final TextEditingController hospCtrl = TextEditingController();
  final TextEditingController surgCtrl = TextEditingController();
  final TextEditingController currMedCtrl = TextEditingController();
  final TextEditingController chroDisCtrl = TextEditingController();
  final TextEditingController allergCtrl = TextEditingController();
  final TextEditingController medAllergCtrl = TextEditingController();

  dynamic initialValName,
      initialValGender,
      initialValBirthDate,
      initialValAge,
      initialValWeight,
      initialValHeight,
      initialValMaritalStatus,
      initialValPregnancy,
      initialValSmoking,
      initialValHospitalization,
      initialValSurgery,
      initialValCurrentMed,
      initialValChronicDisease,
      initialValAllergies,
      initialValMedAllergies;


  // return a Future<Null> it is useless
  // void getValOfField(dynamic variable, String field) async {
  //   await FirebaseFirestore.instance.collection('Medical History')
  //       .doc(FirebaseAuth.instance.currentUser.uid).get()
  //       .then((value) {
  //     variable = value.get(field);
  //   });
  // }
  // void getValOfField(dynamic variable, String field) async {
  //   final collection = await FirebaseFirestore.instance.collection('Medical History').get();
  //   for (var doc in collection.docs){
  //     if (doc.id == FirebaseAuth.instance.currentUser.uid){
  //       variable = doc.get(field);
  //     }
  //   }
  // }
  void retrieveData() async {
    QuerySnapshot collection = await FirebaseFirestore.instance.collection('Medical History').get();
    for (var doc in collection.docs){
      if (doc.id == FirebaseAuth.instance.currentUser.uid){
        initialValName = doc.get('full name');
        initialValGender = doc.get('gender');
        initialValBirthDate = doc.get('birth date').toString();
        initialValAge = doc.get('age');
        initialValWeight = doc.get('weight');
        initialValHeight = doc.get('height');
        initialValMaritalStatus = doc.get('marital status');
        initialValPregnancy = doc.get('pregnancy');
        initialValSmoking = doc.get('smoking');
        initialValHospitalization = doc.get('hospitalization');
        initialValSurgery = doc.get('surgery');
        initialValCurrentMed = doc.get('current medications');
        initialValChronicDisease = doc.get('chronic disease');
        initialValAllergies = doc.get('allergies');
        initialValMedAllergies = doc.get('medication allergies');
      }
    }
  }



  //  void allGetValOfField(){
  //    getValOfField(initialValName, 'full name');
  //    getValOfField(initialValGender, 'gender');
  //    getValOfField(initialValBirthDate, 'birth date');
  //    getValOfField(initialValAge, 'age');
  //    getValOfField(initialValWeight, 'weight');
  //    getValOfField(initialValHeight, 'height');
  //    getValOfField(initialValMaritalStatus, 'marital status');
  //    getValOfField(initialValPregnancy, 'pregnancy');
  //    getValOfField(initialValSmoking, 'smoking');
  //    getValOfField(initialValHospitalization, 'hospitalization');
  //    getValOfField(initialValSurgery, 'surgery');
  //    getValOfField(initialValCurrentMed, 'current medications');
  //    getValOfField(initialValChronicDisease, 'chronic disease');
  //    getValOfField(initialValAllergies, 'allergies');
  //    getValOfField(initialValMedAllergies, 'medication allergies');
  //
  //  }
  //

  void iniState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Form(key: _formKey, child: ListView(
            padding: EdgeInsets.all(8.0),
            children: [


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
                  ),
                  initialValue: initialValName,
                  enabled: false,

                ),
              ),

              RaisedButton(
                child: Text('test'),
                onPressed: (){
                  //retrieveData();
                  
                  print(initialValName);
                  print(initialValGender);
                  print(initialValBirthDate);
                  print(initialValAge);
                  print(initialValWeight);
                  print(initialValHeight);

                  print(initialValMaritalStatus);
                  print(initialValPregnancy);
                  print(initialValSmoking);

                  print(initialValHospitalization);
                  print(initialValSurgery);
                  print(initialValCurrentMed);
                  print(initialValChronicDisease);
                  print(initialValAllergies);
                  print(initialValMedAllergies);


                }
              ),

              //الجنس
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  dropdownColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'الجنس:',
                    border: OutlineInputBorder(),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  value: initialValGender,
                  // items: genderList.map((item) {
                  //   //to convert list items into dropdown menu items
                  //   return DropdownMenuItem(
                  //     child: Center(child: Text(item)),
                  //     value: item,
                  //   );
                  // }).toList(),

                ),
              ),

              // //تاريخ الميلاد
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimeField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الميلاد:',
                    border: OutlineInputBorder(),
                  ),
                  //initialValue: initialValBirthDate.toString(),
                  enabled: false,
                ),
              ),

              // //العمر
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //       labelText: 'العمر :',
              //       border: OutlineInputBorder(),
              //     ),
              //     validator: (value) {
              //       if (value.isEmpty) {
              //         return 'هذا الحقل مطلوب';
              //       }
              //       return null;
              //     },
              //     onChanged: (value) {
              //       medicalHistory.age = int.parse(value);
              //       // age = Age.dateDifference(
              //       //     fromDate: birthDate, toDate: DateTime.now(), includeToDate: false) as int;
              //     },
              //     controller: ageCtrl,
              //   ),
              // ),
              //
              // //الوزن
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //       labelText: 'الوزن :',
              //       suffixText: 'كلجم',
              //       border: OutlineInputBorder(),
              //     ),
              //     validator: (value) {
              //       if (value.isEmpty) {
              //         return 'هذا الحقل مطلوب';
              //       }
              //       return null;
              //     },
              //     onChanged: (value) {
              //       medicalHistory.weight = double.parse(value);
              //     },
              //     controller: weightCtrl,
              //   ),
              // ),
              //
              // //الطول
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //       labelText: 'الطول :',
              //       suffixText: 'سم',
              //       border: OutlineInputBorder(),
              //     ),
              //     validator: (value) {
              //       if (value.isEmpty) {
              //         return 'هذا الحقل مطلوب';
              //       }
              //       return null;
              //     },
              //     onChanged: (value) {
              //       medicalHistory.height = double.parse(value);
              //     },
              //     controller: heightCtrl,
              //   ),
              // ),
              //
              // //الحالة الاجتماعية
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField(
              //     dropdownColor: Colors.black,
              //     decoration: InputDecoration(
              //       labelText: 'الحالة الاجتماعية :',
              //       border: OutlineInputBorder(),
              //     ),
              //     icon: Icon(Icons.arrow_drop_down),
              //     value: medicalHistory.maritalStatus,
              //     items: maritalStatusList.map((item) {
              //       //to convert list items into dropdown menu items
              //       return DropdownMenuItem(
              //         child: Center(child: Text(item)),
              //         value: item,
              //       );
              //     }).toList(),
              //     validator: (value) =>
              //     value == null
              //         ? 'هذا الحقل مطلوب'
              //         : null,
              //     onChanged: (selectedValue) {
              //       setState(() {
              //         medicalHistory.maritalStatus = selectedValue;
              //       });
              //     },
              //   ),
              // ),
              //
              // //التدخين
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField(
              //     dropdownColor: Colors.black,
              //     decoration: InputDecoration(
              //       labelText: 'هل تدخن :',
              //       border: OutlineInputBorder(),
              //     ),
              //     icon: Icon(Icons.arrow_drop_down),
              //     value: medicalHistory.smoking,
              //     items: smokingList.map((item) {
              //       //to convert list items into dropdown menu items
              //       return DropdownMenuItem(
              //         child: Center(child: Text(item)),
              //         value: item,
              //       );
              //     }).toList(),
              //     validator: (value) =>
              //     value == null
              //         ? 'هذا الحقل مطلوب'
              //         : null,
              //     onChanged: (selectedValue) {
              //       setState(() {
              //         medicalHistory.smoking = selectedValue;
              //       });
              //     },
              //   ),
              // ),
              //
              // //الحمل
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField(
              //     dropdownColor: Colors.black,
              //     decoration: InputDecoration(
              //       labelText: 'هل هناك احتمال حمل :',
              //       border: OutlineInputBorder(),
              //     ),
              //     value: medicalHistory.pregnancy,
              //     items: yesNoAnswers.map((item) {
              //       //to convert list items into dropdown menu items
              //       return DropdownMenuItem(
              //         child: Center(child: Text(item)),
              //         value: item,
              //       );
              //     }).toList(),
              //     validator: (value) =>
              //     value == null
              //         ? 'هذا الحقل مطلوب'
              //         : null,
              //     onChanged: (selectedValue) {
              //       setState(() {
              //         medicalHistory.pregnancy = selectedValue;
              //       });
              //     },
              //   ),
              // ),
              //
              // //تنويم
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     decoration: InputDecoration(
              //       labelText: 'هل سبق أن تم تنويمك في المستشفى :',
              //       hintText: 'اكتب كل سبب في سطر',
              //       border:
              //       OutlineInputBorder(),
              //     ),
              //     onChanged: (value) {
              //       medicalHistory.hospitalizations = value.split('\n');
              //     },
              //     controller: hospCtrl,
              //   ),
              // ),
              //
              // //جراحة
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     decoration: InputDecoration(
              //       labelText: 'هل خضعت لأي عملية جراحية من قبل :',
              //       hintText: 'اكتب كل عملية في سطر',
              //       border:
              //       OutlineInputBorder(),
              //     ),
              //     onChanged: (value) {
              //       medicalHistory.surgery = value.split('\n');
              //     },
              //     controller: surgCtrl,
              //   ),
              // ),
              //
              // //مرض مزمن
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     decoration: InputDecoration(
              //       labelText: 'هل تعاني من أي أمراض مزمنة :',
              //       hintText: 'اكتب كل مرض في سطر',
              //       border:
              //       OutlineInputBorder(),
              //     ),
              //     onChanged: (value) {
              //       medicalHistory.chronicDisease = value.split('\n');
              //     },
              //     controller: chroDisCtrl,
              //   ),
              // ),
              //
              // //أدوية حالية
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     decoration: InputDecoration(
              //       labelText: 'هل تتناول أي أدوية حاليا :',
              //       hintText: 'اكتب كل دواء في سطر',
              //       border:
              //       OutlineInputBorder(),
              //     ),
              //     onChanged: (value) {
              //       medicalHistory.currentMed = value.split('\n');
              //     },
              //     controller: currMedCtrl,
              //   ),
              // ),
              //
              // //حساسية
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     decoration: InputDecoration(
              //       labelText: 'هل تعاني من أي حساسية :',
              //       hintText: 'اكتب كل حساسية في سطر',
              //       border:
              //       OutlineInputBorder(),
              //     ),
              //     onChanged: (value) {
              //       medicalHistory.allergies = value.split('\n');
              //     },
              //     controller: allergCtrl,
              //   ),
              // ),
              //
              // //حساسية دوائية
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     decoration: InputDecoration(
              //       labelText: 'هل تعاني من أي حساسية تجاه نوع من الأدوية :',
              //       hintText: 'اكتب كل نوع في سطر',
              //       border: OutlineInputBorder(),
              //     ),
              //     validator: (value) {
              //       if (value.isEmpty) {
              //         return 'هذا الحقل مطلوب';
              //       }
              //       return null;
              //     },
              //     onChanged: (value) {
              //       medicalHistory.medAllergies = value.split('\n');
              //     },
              //     controller: medAllergCtrl,
              //   ),
              // ),
              //
              // Divider(
              //   height: 20,
              //   thickness: 3,
              // ),
              //
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 10.0),
              //   child: Text(
              //       'تأكد من صحة المعلومات التي تقدمها لأن ذلك يحسن من الخدمة المقدة لك ',
              //       textAlign: TextAlign.center),
              // ),
              //
              //
              // Center(
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: RaisedButton(
              //             child: Text('تعديل'),
              //             onPressed: () {
              //               if (!_formKey.currentState.validate()) {
              //                 return ;
              //               }
              //               _formKey.currentState.save();
              //               saveMedicalHistoryForm();
              //               //Navigator.pop(context);
              //             }),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: RaisedButton(
              //             child: Text('رجوع'),
              //             onPressed: () {
              //               ageCtrl.clear();
              //               weightCtrl.clear();
              //               heightCtrl.clear();
              //               hospCtrl.clear();
              //               surgCtrl.clear();
              //               currMedCtrl.clear();
              //               chroDisCtrl.clear();
              //               allergCtrl.clear();
              //               medAllergCtrl.clear();
              //               Navigator.pop(context);
              //             }
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          ),
        )
    );
  }
}
