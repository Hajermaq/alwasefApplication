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

class EditMedicalHistoryPage extends StatefulWidget {
  static const String id = 'edit_medical_history';
  // constructor
//   EditMedicalHistoryPage({
//     this.initialValName,
//     this.initialValGender,
//     this.initialValAge,
//     this.initialValBirthDate,
//     this.initialValWeight,
//     this.initialValHeight,
//     this.initialValMaritalStatus,
//     this.initialValPregnancy,
//     this.initialValSmoking,
//     this.initialValHospitalization,
//     this.initialValSurgery,
//     this.initialValCurrentMed,
//     this.initialValChronicDisease,
//     this.initialValAllergies,
//     this.initialValMedAllergies,
// });
//   final dynamic initialValName,
//       initialValGender,
//       initialValAge,
//       initialValBirthDate,
//       initialValWeight,
//       initialValHeight,
//       initialValMaritalStatus,
//       initialValPregnancy,
//       initialValSmoking,
//       initialValHospitalization,
//       initialValSurgery,
//       initialValCurrentMed,
//       initialValChronicDisease,
//       initialValAllergies,
//       initialValMedAllergies;

  @override
  _EditMedicalHistoryPageState createState() => _EditMedicalHistoryPageState();
}

class _EditMedicalHistoryPageState extends State<EditMedicalHistoryPage> {
  final authM = FirebaseAuth.instance;
  final fireM = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  //TODO: Dlete this
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

  String initialValName = '';
  dynamic initialValGender,
      initialValAge,
      initialValBirthDate,
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

  // this method returns a Future<Null> it is useless
  // void getValOfField(dynamic variable, String field) async {
  //   await FirebaseFirestore.instance.collection('Medical History')
  //       .doc(FirebaseAuth.instance.currentUser.uid).get()
  //       .then((value) {
  //     variable = value.get(field);
  //   });
  // }

  // void retrieveData1() async {
  //   try{
  //     //QuerySnapshot
  //     final collection = await FirebaseFirestore.instance.collection('Medical History').get();
  //     for (var doc in collection.docs){
  //       if (doc.id == FirebaseAuth.instance.currentUser.uid){
  //         initialValName = doc.get('full name');
  //         // initialValGender = doc.get('gender');
  //         // initialValBirthDate = doc.get('birth date').toString();
  //         // initialValAge = doc.get('age');
  //         // initialValWeight = doc.get('weight');
  //         // initialValHeight = doc.get('height');
  //         // initialValMaritalStatus = doc.get('marital status');
  //         // initialValPregnancy = doc.get('pregnancy');
  //         // initialValSmoking = doc.get('smoking');
  //         // initialValHospitalization = doc.get('hospitalization');
  //         // initialValSurgery = doc.get('surgery');
  //         // initialValCurrentMed = doc.get('current medications');
  //         // initialValChronicDisease = doc.get('chronic disease');
  //         // initialValAllergies = doc.get('allergies');
  //         // initialValMedAllergies = doc.get('medication allergies');
  //
  //       }
  //     }
  //   } catch(e){
  //     print(e);
  //   }
  // }

  retrieveData() async {
    //value.get(field);

    // DocumentReference docR = FirebaseFirestore.instance.collection('/Medical History')
    //     .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    //.doc(FirebaseAuth.instance.currentUser.uid);

    await FirebaseFirestore.instance
        .collection('/Medical History')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      initialValName = doc.get('full name');
      setState(() {});
    });

    // DocumentSnapshot docS;
    // FirebaseFirestore.instance
    //     .collection('/Medical History')
    //     .doc(FirebaseAuth.instance.currentUser.uid)
    //     .get()
    //     .then((value) {
    //       // return doc.data()['full name'].toString();
    //       // initialValName = doc.data()['full name'];
    //       docS = value;
    // });
    // return docS.get('full name');

    // final collection = await fireM.collection('Medical History').get();
    // for (var doc in collection.docs) {
    //   if (doc.id == FirebaseAuth.instance.currentUser.uid) {
    //     initialValName = doc.get('full name');
    //   }
    // }
  }

  // void iniState() {
  //   setState(() {
  //     retrieveData();
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    setState(() {
      retrieveData();
    });
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
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
                //initialValue: retrieveData(),
                controller: TextEditingController(text: '$initialValName'),
                readOnly: true,
              ),
            ),

            RaisedButton(
                child: Text('test'),
                onPressed: () {
                  //print(retrieveData());

                  FirebaseFirestore.instance
                      .collection('Medical History')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get()
                      .then((value) {
                    print(value.get('full name'));
                  });
                  print('nonono');
                  // final collection = await FirebaseFirestore.instance.collection('Medical History').get();
                  //  for (var doc in collection.docs){
                  //    if (doc.id == FirebaseAuth.instance.currentUser.uid){
                  //      print(doc.get('full name'));

                  // FirebaseFirestore.instance
                  //     .collection('/Medical History')
                  //     .doc(FirebaseAuth.instance.currentUser.uid)
                  //     .get()
                  //     .then((doc) {
                  // initialValName = doc.data()['full name'];});

                  print(initialValName);
                  // print(initialValGender);
                  // print(initialValBirthDate);
                  // print(initialValAge);
                  // print(initialValWeight);
                  // print(initialValHeight);
                  //
                  // print(initialValMaritalStatus);
                  // print(initialValPregnancy);
                  // print(initialValSmoking);
                  //
                  // print(initialValHospitalization);
                  // print(initialValSurgery);
                  // print(initialValCurrentMed);
                  // print(initialValChronicDisease);
                  // print(initialValAllergies);
                  // print(initialValMedAllergies);
                }),

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

            // تاريخ الميلاد
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimeField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'تاريخ الميلاد:',
                  border: OutlineInputBorder(),
                ),
                //initialValue: initialValBirthDate,
                readOnly: true,
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
                onChanged: (value) {
                  //medicalHistory.age = int.parse(value);
                  // age = Age.dateDifference(
                  //     fromDate: birthDate, toDate: DateTime.now(), includeToDate: false) as int;
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
                //initialValue: initialValWeight.toString(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
                onChanged: (value) {
                  fireM.doc(authM.currentUser.uid).update({
                    'weight': value as double,
                  });
                },
                controller: weightCtrl,
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
                //initialValue: initialValHeight.toString(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
                onChanged: (value) {
                  fireM.doc(authM.currentUser.uid).update({
                    'height': value as double,
                  });
                },
                controller: heightCtrl,
              ),
            ),

            //الحالة الاجتماعية
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

            //تنويم
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textAlign: TextAlign.center,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'هل سبق أن تم تنويمك في المستشفى :',
                  hintText: 'اكتب كل سبب في سطر',
                  border: OutlineInputBorder(),
                ),
                initialValue: initialValHospitalization,
                onChanged: (value) {
                  fireM.doc(authM.currentUser.uid).update({
                    'hospitalization': value.split('\n'),
                  });
                },
                controller: hospCtrl,
              ),
            ),

            //جراحة
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textAlign: TextAlign.center,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'هل خضعت لأي عملية جراحية من قبل :',
                  hintText: 'اكتب كل عملية في سطر',
                  border: OutlineInputBorder(),
                ),
                //initialValue: initialValSurgery,
                onChanged: (value) {
                  fireM.doc(authM.currentUser.uid).update({
                    'surgery': value.split('\n'),
                  });
                },
                controller: surgCtrl,
              ),
            ),

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
            //     initialValue: initialValChronicDisease,
            //     onChanged: (value) {
            //       fireM.doc(authM.currentUser.uid).update({
            //         'chronic disease': value.split('\n'),
            //       });                  },
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
            //     initialValue: initialValCurrentMed,
            //     onChanged: (value) {
            //       fireM.doc(authM.currentUser.uid).update({
            //         'current medications': value.split('\n'),
            //       });
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
            //     initialValue: initialValAllergies,
            //     onChanged: (value) {
            //       fireM.doc(authM.currentUser.uid).update({
            //         'allergies': value.split('\n'),
            //       });                  },
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
            //     initialValue: initialValMedAllergies,
            //     onChanged: (value) {
            //       fireM.doc(authM.currentUser.uid).update({
            //         'medication allergies': value.split('\n'),
            //       });
            //     },
            //     controller: medAllergCtrl,
            //   ),
            // ),

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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text('تعديل'),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          //saveMedicalHistoryForm();
                          //Navigator.pop(context);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text('رجوع'),
                        onPressed: () {
                          ageCtrl.clear();
                          weightCtrl.clear();
                          heightCtrl.clear();
                          hospCtrl.clear();
                          surgCtrl.clear();
                          currMedCtrl.clear();
                          chroDisCtrl.clear();
                          allergCtrl.clear();
                          medAllergCtrl.clear();
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
