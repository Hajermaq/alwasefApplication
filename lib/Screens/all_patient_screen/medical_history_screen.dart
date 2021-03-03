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


class MedicalHistoryPage extends StatefulWidget {
  static const String id = 'patient_medical_history';
  @override
  _MedicalHistoryPageState createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final authM = FirebaseAuth.instance;
  final fireM = FirebaseFirestore.instance;
  final dateFormat = DateFormat('yyyy-MM-dd');

  User currentPatient;
  String patientFullName;
  String gender;
  DateTime birthDate;
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

  TextEditingController nameCtrl;
  TextEditingController ageCtrl;
  TextEditingController weightCtrl;
  TextEditingController heightCtrl;
  TextEditingController hospCtrl;
  TextEditingController surgCtrl;
  TextEditingController currMedCtrl;
  TextEditingController chroDisCtrl;
  TextEditingController allergCtrl;
  TextEditingController medAllergCtrl;

  void iniState(){
    super.initState();
    getCurrentPatient();
  }

  getCurrentPatient() async{
    try{
      final user = authM.currentUser;
      if(user != null){
        currentPatient = user;
      }
    } catch(e){
      print(e);
    }
  }

  void createMedicalHistory() async{
    //or fire.collection('/Medical History').add()
    CollectionReference collection = FirebaseFirestore.instance.collection('/Medical History');
    await collection.add({
      'patient' : currentPatient,
      'full name' : patientFullName,
      'gender': gender,
      'birth date': birthDate,
      'age': age,
      'weight': weight,
      'height': height,
      'marital status': maritalStatus,
      'pregnancy': pregnancy,
      'smoking' : smoking,
      'hospitalization': hospitalizations,
      'surgery': surgery,
      'current medications': currentMed,
      'chronic disease': chronicDisease,
      'medication allergies': medAllergies,
      'allergies': allergies,
    });
  }
  //Map<String, List<String>>getMedicalHistory(){

  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          //TODO: restrict user to fill certain forms
          //TODO: age calculate
          //TODO:  DateTime format

          //الاسم
          Padding(padding: const EdgeInsets.all(10.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'الاسم الكامل:', border: OutlineInputBorder(), ), //errorText: 'الرجاء كتابة الاسم',),
              //validator: (value) => value.length < 4 ? null : 'الرجاء كتابة الاسم كاملا',
              onSaved: (value){
                patientFullName = value; },
              controller: nameCtrl,
              ),
          ),

          //الجنس
          Padding(padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(dropdownColor: Colors.grey, decoration: InputDecoration(labelText: 'الجنس:', border: OutlineInputBorder(),),
              icon: Icon(Icons.arrow_drop_down),
              value: gender,
              items: genderList.map((item) {  //to convert list items into dropdown menu items
              return DropdownMenuItem(
                 child: Center(child: Text(item)),
                 value: item,
              );
              }).toList(),
              onChanged: (selectedValue){
                setState(() {
                  gender = selectedValue;
                });
              },),
          ),

          //تاريخ الميلاد
          Padding(padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                child: Text(birthDate == null? 'اختر تاريخ ميلادك': birthDate.toString()), //if not null display the date
                onPressed: (){
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now()
                  ).then((date) {
                    setState(() {
                      String dateS = dateFormat.format(date);
                      birthDate = dateFormat.parse(dateS);
                    });
                  });
                }),
          ),

          //العمر
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'العمر :', border: OutlineInputBorder(),),
                onChanged: (value){
                  age = value as int; },
                  // age = Age.dateDifference(
                  //     fromDate: birthDate, toDate: DateTime.now(), includeToDate: false) as int;
              controller: ageCtrl,
            ),
          ),

          //الوزن
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'الوزن :', suffixText: 'كلجم', border: OutlineInputBorder(),),
              onSaved: (value){
                patientFullName = value;},
              controller: weightCtrl,
            ),
          ),

          //الطول
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'الطول :', suffixText: 'سم', border: OutlineInputBorder(),),
              onSaved: (value){
                patientFullName = value;},
              controller: heightCtrl,
            ),
          ),

          //الحالة الاجتماعية
          Padding(padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(decoration: InputDecoration(labelText: 'الحالة الاجتماعية :', border: OutlineInputBorder(),),
              icon: Icon(Icons.arrow_drop_down),
              value: maritalStatus,
              items: maritalStatusList.map((item) {  //to convert list items into dropdown menu items
                return DropdownMenuItem(
                  child: Center(child: Text(item)),
                  value: item,
                );
              }).toList(),
              onChanged: (selectedValue){
                setState(() {
                  maritalStatus = selectedValue;
                });
              },),
          ),

          //التدخين
          Padding(padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(decoration: InputDecoration(labelText: 'هل تدخن :', border: OutlineInputBorder(),),
              icon: Icon(Icons.arrow_drop_down),
              value: smoking,
              items: smokingList.map((item) {  //to convert list items into dropdown menu items
                return DropdownMenuItem(
                  child: Center(child: Text(item)),
                  value: item,
                );
              }).toList(),
              onChanged: (selectedValue){
                setState(() {
                  smoking = selectedValue;
                });
              },),
          ),

          //الحمل
          Padding(padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(decoration: InputDecoration(labelText: 'هل هناك احتمال حمل :', border: OutlineInputBorder(),),
              value: pregnancy,
              items: yesNoAnswers.map((item) {  //to convert list items into dropdown menu items
                return DropdownMenuItem(
                  child: Center(child: Text(item)),
                  value: item,
                );
              }).toList(),
              onChanged: (selectedValue){
                setState(() {
                  pregnancy = selectedValue;
                });
              },),
          ),

          //تنويم
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'هل سبق أن تم تنويمك في المستشفى :', hintText: 'افصل بين كل سبب بعلامة /', border: OutlineInputBorder(),//fillColor: Colors.red, //suffix: Icon(Icons.add),
            ),
              onSaved: (value){
                hospitalizations = value.split('/'); },
              controller: nameCtrl,
            ),
          ),

          //جراحة
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'هل خضعت لأي عملية جراحية من قبل :', hintText: 'افصل بين كل عملية بعلامة /', border: OutlineInputBorder(), //fillColor: Colors.red, //suffix: Icon(Icons.add),
            ),
              onSaved: ( value){
                surgery = value.split('/');
                print(surgery); },
              controller: hospCtrl,
            ),
          ),


          Padding(padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: (){

              },
            ),
          ),

          //مرض مزمن
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'هل تعاني من أي أمراض مزمنة :', hintText: 'اذكرها', border: OutlineInputBorder(), //fillColor: Colors.red, //suffix: Icon(Icons.add),
            ),
              onSaved: ( value){
                chronicDisease = value.split('/');},
              controller: chroDisCtrl,
            ),
          ),

          //أدوية حالية
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'هل تتناول أي أدوية حاليا :', hintText: 'اذكر الأسباب', border: OutlineInputBorder(), //fillColor: Colors.red, //suffix: Icon(Icons.add),
            ),
              onSaved: ( value){
                currentMed = value.split('/');},
              controller: currMedCtrl,
            ),
          ),

          //حساسية
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'هل تعاني من أي حساسية :', hintText: 'اذكر الأمور التي تثيرها', border: OutlineInputBorder(), //fillColor: Colors.red, //suffix: Icon(Icons.add),
            ),
              onSaved: ( value){
                allergies = value.split('/');},
              controller: allergCtrl,
            ),
          ),

          //حساسية دوائية
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'هل تعاني من أي حساسية تجاه نوع من الأدوية :', hintText: 'اذكر نوع الأدوية', border: OutlineInputBorder(), //fillColor: Colors.red, //suffix: Icon(Icons.add),
            ),
              onSaved: ( value){
                medAllergies = value.split('/');},
              controller: medAllergCtrl,
            ),
          ),

          Padding(padding: const EdgeInsets.all(8.0),
            child: Text('تأكد من صحة المعلومات التي تقدمها لأن ذلك يحسن من الخدمة المقدة لك ', textAlign: TextAlign.center),
          ),
          Padding(padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                child: Text('حفظ'),
                onPressed: (){
                  createMedicalHistory();
                  //Navigator.pushNamed(context, PatientMainPage.id);
                }),
          ),
        ],
      ),
    ));
  }
}
