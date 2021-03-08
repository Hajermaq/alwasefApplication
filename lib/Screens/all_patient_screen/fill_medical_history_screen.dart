import 'package:alwasef_app/Screens/all_patient_screen/patients_mainpage.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:age/age.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';

class FillMedicalHistoryPage extends StatefulWidget {
  static const String id = 'patient_medical_history';
  @override
  _FillMedicalHistoryPageState createState() => _FillMedicalHistoryPageState();
}

class _FillMedicalHistoryPageState extends State<FillMedicalHistoryPage> {
  final authM = FirebaseAuth.instance;
  final fireM = FirebaseFirestore.instance;
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  String patientFullName = ' ';
  String gender;
  String birthDate;
  int age;
  double weight;
  double height;
  String maritalStatus;
  String pregnancy;
  String smoking;
  List<String> hospitalizations;
  List<String> surgery;
  List<String> currentMed; //current medications
  List<String> chronicDisease;
  List<String> allergies;
  List<String> medAllergies; //medication allergies

  List<String> genderList = ['ذكر', 'أنثى'];
  List<String> maritalStatusList = ['أعزب', 'متزوج', 'غير ذلك'];
  List<String> yesNoAnswers = ['لا', 'نعم'];
  List<String> smokingList = ['لا أبدا', 'أحيانا', ' نعم دائما'];

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  final TextEditingController hospCtrl = TextEditingController();
  final TextEditingController surgCtrl = TextEditingController();
  final TextEditingController currMedCtrl = TextEditingController();
  final TextEditingController chroDisCtrl = TextEditingController();
  final TextEditingController allergCtrl = TextEditingController();
  final TextEditingController medAllergCtrl = TextEditingController();
  bool has = false;

  void iniState() {
    super.initState();
    // getCurrentPatient();
  }

  void saveMedicalHistoryForm() async {
    //or fire.collection('/Medical History').add()
    CollectionReference collection =
    FirebaseFirestore.instance.collection('/Medical History');
    await collection.add({
      'patient': authM.currentUser.uid,
      'full name': patientFullName,
      'gender': gender,
      'birth date': birthDate,
      'age': age,
      'weight': weight,
      'height': height,
      'marital status': maritalStatus,
      'pregnancy': pregnancy,
      'smoking': smoking,
      'hospitalization': hospitalizations,
      'surgery': surgery,
      'current medications': currentMed,
      'chronic disease': chronicDisease,
      'medication allergies': medAllergies,
      'allergies': allergies,
    });
  }

  int calculateAge() {
    DateTime birthDateYear = DateTime.parse(birthDate);
    int agee = (DateTime
        .now()
        .year - birthDateYear.year);
    age = agee;
    return agee;
  }

  // Widget fillMedicalHistoryForm() {
  //   //hasMedicalHistory();
  //   //if (has) {
  //  // } else
  //   //  return displayMedicalHistoryForm();
  // }

  // Widget displayMedicalHistoryForm() {
  //   return Scaffold();
  // }


  // Widget hasMedicalHistory() {
  //
  // }


  // Widget updateMedicalHistory(){
  //   return Container;
  // }


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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    patientFullName = value;
                  },
                  controller: nameCtrl,
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
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  value: gender,
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
                      gender = selectedValue;
                    });
                  },
                ),
              ),

              //تاريخ الميلاد
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    child: Text(birthDate == null ?
                    //if not null display the date
                    'اختر تاريخ ميلادك' : birthDate),
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now())
                          .then((pickedDate) {
                        setState(() {
                          birthDate = dateFormat.format(pickedDate);
                          calculateAge();
                        });
                      });
                    }),
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
                  onChanged: (value) {
                    age = int.parse(value);
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    weight = double.parse(value);
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    height = double.parse(value);
                  },
                  controller: heightCtrl,
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
                  value: maritalStatus,
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
                      maritalStatus = selectedValue;
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
                  value: smoking,
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
                      smoking = selectedValue;
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
                  value: pregnancy,
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
                      pregnancy = selectedValue;
                    });
                  },
                ),
              ),

              //تنويم
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'هل سبق أن تم تنويمك في المستشفى :',
                    hintText: 'اكتب كل سبب في سطر',
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    hospitalizations = value.split('\n');
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
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    surgery = value.split('\n');
                    print(surgery);
                  },
                  controller: surgCtrl,
                ),
              ),

              //مرض مزمن
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'هل تعاني من أي أمراض مزمنة :',
                    hintText: 'اكتب كل مرض في سطر',
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    chronicDisease = value.split('\n');
                  },
                  controller: chroDisCtrl,
                ),
              ),

              //أدوية حالية
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'هل تتناول أي أدوية حاليا :',
                    hintText: 'اكتب كل دواء في سطر',
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    currentMed = value.split('\n');
                  },
                  controller: currMedCtrl,
                ),
              ),

              //حساسية
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'هل تعاني من أي حساسية :',
                    hintText: 'اكتب كل حساسية في سطر',
                    border:
                    OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    allergies = value.split('\n');
                  },
                  controller: allergCtrl,
                ),
              ),

              //حساسية دوائية
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'هل تعاني من أي حساسية تجاه نوع من الأدوية :',
                    hintText: 'اكتب كل نوع في سطر',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    medAllergies = value.split('\n');
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text('حفظ'),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return ;
                            }
                            _formKey.currentState.save();
                            saveMedicalHistoryForm();
                            //Navigator.pop(context);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text('إلغاء'),
                          onPressed: () {
                            nameCtrl.clear();
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


}
