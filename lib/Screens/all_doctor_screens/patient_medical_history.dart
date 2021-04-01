import 'dart:math';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:alwasef_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PatientMedicalHistory extends StatefulWidget {
  PatientMedicalHistory({this.uid});
  final String uid;
  @override
  _PatientMedicalHistoryState createState() => _PatientMedicalHistoryState();
}

class _PatientMedicalHistoryState extends State<PatientMedicalHistory> {
  List<Widget> getArraytinfo(List list, String label) {
    List<Widget> listofWidgets = [];
    for (var i in list) {
      listofWidgets.add(
        Column(
          children: [
            ListTileDivider(
              color: Colors.black26,
            ),
            MedicalHistoyListTile(
              titleText: label,
              dataText: '$i',
            ),
          ],
        ),
      );
    }
    return listofWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: klighterColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/Patient')
              .doc(widget.uid)
              .collection('/Medical History')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //main variable
              DocumentSnapshot medicalHistory = snapshot.data.docs[0];
              //Lists
              List chronicdiseasesList =
                  medicalHistory.data()['chronic disease'];
              // FirebaseFirestore.instance
              //     .collection('/Medical History')
              //     .doc(widget.uid)
              //     .update(
              //       'chronic disease',
              //       FieldValue.arrayUnion('hey'),
              //     );

              List hospitalizationList =
                  medicalHistory.data()['hospitalization'];
              List allergiesList = medicalHistory.data()['allergies'];
              List medicationAllergiesList =
                  medicalHistory.data()['medication allergies'];
              List surgeriesList = medicalHistory.data()['surgery'];
              List currentMedicationList =
                  medicalHistory.data()['current medications'];
              //BMI related
              double heightInCm = medicalHistory.data()['height'];
              double heightInM = heightInCm / 100;
              double weight = medicalHistory.data()['weight'];
              String BMI = (weight / pow(heightInM, 2)).toStringAsFixed(2);

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MedicalHistoryHeadLine(
                          wantIcon: false,
                          label: 'معلومات عامة',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'الاسم الكامل',
                          dataText: '${medicalHistory.data()['full name']}',
                        ),
                        ListTileDivider(
                          color: Colors.black26,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'تاريخ الميلاد',
                          dataText: '${medicalHistory.data()['birth date']}',
                        ),
                        ListTileDivider(
                          color: Colors.black26,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'العمر',
                          dataText: '${medicalHistory.data()['age']}',
                        ),
                        ListTileDivider(
                          color: Colors.black26,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'الجنس',
                          dataText: '${medicalHistory.data()['gender']}',
                        ),
                        ListTileDivider(
                          color: Colors.black26,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'الحالة الإجتماعية',
                          dataText:
                              '${medicalHistory.data()['marital status']}',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MedicalHistoryHeadLine(
                          wantIcon: false,
                          label: 'المتغيرات الكمية',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'الطول',
                          dataText: '$heightInCm سم',
                        ),
                        ListTileDivider(
                          color: Colors.black26,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'الوزن',
                          dataText: '$weight كجم',
                        ),
                        ListTileDivider(
                          color: Colors.black26,
                        ),
                        MedicalHistoyListTile(
                          titleText: 'مؤشر كتلة الجسم',
                          dataText: '${BMI} كجم/ متر2',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MedicalHistoryHeadLine(
                          label: 'الأمراض المزمنة',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        Column(
                          children:
                              getArraytinfo(chronicdiseasesList, 'مرض مزمن'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MedicalHistoryHeadLine(
                          label: 'الأمراض التحسسية',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        Column(
                          children: getArraytinfo(allergiesList, 'حساسية'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MedicalHistoryHeadLine(
                          label: 'حساسية الدواء',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        Column(
                          children: getArraytinfo(
                              medicationAllergiesList, 'حساسية من'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MedicalHistoryHeadLine(
                          label: 'العمليات السابقة',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        Column(
                          children: getArraytinfo(surgeriesList, 'عملية'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MedicalHistoryHeadLine(
                          label: 'الأدوية الحالية',
                        ),
                        ListTileDivider(
                          color: Colors.black,
                        ),
                        Column(
                          children:
                              getArraytinfo(currentMedicationList, 'الدواء'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return CircularProgressIndicator();
          }),
    ));
  }
}

class MedicalHistoryHeadLine extends StatelessWidget {
  MedicalHistoryHeadLine({this.label, this.onTap, this.wantIcon});
  final String label;
  final Function onTap;
  final bool wantIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onTap,
            child: wantIcon == false
                ? SizedBox()
                : Icon(
                    Icons.add,
                  ),
          )
        ],
      ),
    );
  }
}

class MedicalHistoyListTile extends StatelessWidget {
  MedicalHistoyListTile({this.dataText, this.titleText});
  final String titleText;
  final String dataText;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        titleText,
        style: TextStyle(color: Colors.black),
      ),
      trailing: Text(
        dataText,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
