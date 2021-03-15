import 'dart:collection';

import 'package:alwasef_app/Screens/all_doctor_screens/prescriptions_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePrescription extends StatefulWidget {
  UpdatePrescription(
      {this.uid,
      this.tradeName,
      this.tradeNameArabic,
      this.scientificName,
      this.scientificNameArabic,
      this.strength,
      this.storageConditions,
      this.publicPrice,
      this.sizeUnit,
      this.size,
      this.administrationRoute,
      this.pharmaceuticalForm,
      this.registerNumber,
      this.strengthUnit,
      this.documentID});
  final String uid;
  final String registerNumber;
  final String tradeName;
  final String tradeNameArabic;
  final String scientificName;
  final String scientificNameArabic;
  final String pharmaceuticalForm;
  final String strength;
  final String strengthUnit;
  final String administrationRoute;
  final String storageConditions;
  final String size;
  final String sizeUnit;
  final String publicPrice;
  final String documentID;
  static final String id = 'add_prescription_screen';
  @override
  _UpdatePrescriptionState createState() => _UpdatePrescriptionState();
}

class _UpdatePrescriptionState extends State<UpdatePrescription> {
  //Data from Api with default value
  // String tradeName = widget.tradeName;  String tradeNameArabic = '...';
  // String scientificName = '...';
  // String scientificNameArabic = '...';
  // String pharmaceuticalForm = '...';
  // String strength = '...';
  // String strengthUnit = '...';
  // String administrationRoute = '...';
  // String storageConditions = '...';
  // int size = 0;
  // String sizeUnit = '...';
  // String publicPrice = '...';

  // formatted date
  static final DateTime now = DateTime.now();
  final String creationDate = formatter.format(now);
  //Data from TextFields
  int dose = 0;
  int quantity = 0;
  int refill = 0;
  int dosingExpire = 0;
  var dropdownValue;
  String instructionNote = ' ';
  String doctorNotes = ' ';
  String startDate = ' ';
  String endDate = ' ';
  String RegisterNumber = '';
  //Random Variables
  String stringFromTF;
  final maxLines = 5;
  // the creation on the prescription date
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  //Lists
  static List<Prescription> drugsForDisplay = List<Prescription>();
  List<Prescription> _drugs = List<Prescription>();
  //
  // getId() {
  //   FirebaseFirestore.instance
  //       .collection("/Patient")
  //       .doc(widget.uid)
  //       .collection('/Prescriptions')
  //       .add({
  //     "name": "john",
  //     "age": 50,
  //   }).then((value) {
  //     print(value.id);
  //   });
  // }

  _searchBar() {
    return FilledRoundTextFields(
      hintMessage: 'ابحث عن اسم الدواء هنا',
      fillColor: kGreyColor,
    );
  }

  // Future<Null> _selectedDate(BuildContext context) async {
  //   DateTime _datePicker = await showDatePicker(
  //       context: context,
  //       initialDate: _date,
  //       firstDate: DateTime.now().subtract(Duration(days: 0)),
  //       lastDate: DateTime(2050),
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(
  //             data: ThemeData(
  //               primarySwatch: kBlueColor,
  //             ),
  //             child: child);
  //       });
  //
  //   if (_datePicker != null && _datePicker != _date) {
  //     setState(() {
  //       _date = _datePicker;
  //     });
  //   }
  // }

  // String checkDrugName() {
  //   if ((tradeName == ' ' || tradeNameArabic == ' ') && scientificName != ' ')
  //     return scientificName;
  //   else if ((scientificName == ' ' || scientificNameArabic == ' ') &&
  //       tradeName != ' ')
  //     return tradeName;
  //   else if ((tradeName == ' ' || scientificName == ' ') &&
  //       tradeNameArabic != ' ')
  //     return tradeNameArabic;
  //   else
  //     return scientificNameArabic;
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.documentID);
    // getRegisterNumber();
    // print(RegisterNumber);
    print(widget.uid);
    print(widget.tradeNameArabic);
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: kLightColor,
      ),
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              _searchBar(),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        DrugInfoCard(
                          drugName: widget.tradeNameArabic,
                          pharmaceuticalForm: widget.pharmaceuticalForm,
                          strength: widget.strength,
                          strengthUnit: widget.strengthUnit,
                          date: creationDate,
                          administrationRoute: widget.administrationRoute,
                          storageCondition: widget.storageConditions,
                          size: widget.size,
                          sizeUnit: widget.sizeUnit,
                          price: widget.publicPrice,
                        ),
                        Card(
                          color: kGreyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                InfoRow(
                                  label_1: 'الجرعة',
                                  onChanged_1: (value) {
                                    dose = int.parse(value);
                                  },
                                  label_2: 'الكمية',
                                  onChanged_2: (value) {
                                    quantity = int.parse(value);
                                  },
                                ),
                                InfoRow(
                                  label_1: 'اعادة \nالتعبئه',
                                  onChanged_1: (value) {
                                    refill = int.parse(value);
                                  },
                                  label_2: 'يوم انتهاء\n الوصفة',
                                  onChanged_2: (value) {
                                    dosingExpire = int.parse(value);
                                  },
                                ),
                                Divider(
                                  color: klighterColor,
                                  thickness: 0.9,
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'التكرار',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.white54,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),

                                            // dropdown below..
                                            child: DropdownButton<String>(
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                                isExpanded: true,
                                                value: dropdownValue,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 42,
                                                underline: SizedBox(),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    dropdownValue = newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  'مرة في اليوم (QD)',
                                                  'مرتين في اليوم (BID)',
                                                  'ثلاث مرات في اليوم (TID)',
                                                  'أربع مرات في اليوم (QID)',
                                                  'خمس مرات في اليوم (PID)',
                                                  'حسب الحاجة (PRN)',
                                                  'قبل النوم (QHS)',
                                                  'مرة في الأسبوع (Qweek)',
                                                  'مرة في الشهر (Qmonth)',
                                                  'مرة كل يومين (QOD)',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList()),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'تاريخ البداية',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: DatePicker(
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value == null) {
                                                print('Field id empty');
                                              }
                                            },
                                            date: creationDate,
                                            onChanged: (value) {
                                              startDate =
                                                  formatter.format(value);
                                              print('date not picked');
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'تاريخ النهاية',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: DatePicker(
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value == null) {
                                                print('Field id empty');
                                              }
                                            },
                                            date: creationDate,
                                            onChanged: (value) {
                                              if (value != null) {
                                                endDate =
                                                    formatter.format(value);
                                                print('no data');
                                              } else {
                                                print('date not picked');
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: klighterColor,
                                  thickness: 0.9,
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'تعليمات\n للمريض ',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: Container(
                                            margin: EdgeInsets.all(12),
                                            height: maxLines * 24.0,
                                            child: TextField(
                                              onChanged: (value) {
                                                instructionNote = value;
                                              },
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              maxLines: maxLines,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white54,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: ListTile(
                                          leading: Text(
                                            'ملاحظات \n للصيدلي ',
                                            style: ksubBoldLabelTextStyle,
                                          ),
                                          title: Container(
                                            margin: EdgeInsets.all(12),
                                            height: maxLines * 24.0,
                                            child: TextField(
                                              onChanged: (value) {
                                                doctorNotes = value;
                                              },
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              maxLines: maxLines,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white54,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 20.0),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        child: RaisedButton(
                          textColor: kButtonTextColor,
                          color: kGreyColor,
                          child: Text(
                            'تحديث',
                            style: TextStyle(
                              color: Colors.white,
                              // fontFamily: 'Montserrat',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          onPressed: () async {
                            UserManagement(
                                    documentId: widget.documentID,
                                    currentPatient_uid: widget.uid)
                                .prescriptionUpdate(context, instructionNote,
                                    dropdownValue, refill);
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrugInfoCard extends StatelessWidget {
  const DrugInfoCard({
    Key key,
    @required this.drugName,
    @required this.pharmaceuticalForm,
    @required this.strength,
    @required this.strengthUnit,
    @required this.date,
    @required this.administrationRoute,
    @required this.storageCondition,
    @required this.size,
    @required this.sizeUnit,
    @required this.price,
  }) : super(key: key);

  final String drugName;
  final String pharmaceuticalForm;
  final String strength;
  final String strengthUnit;
  final String date;
  final String administrationRoute;
  final String storageCondition;
  final String size;
  final String sizeUnit;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.build_circle_outlined,
              size: 50,
            ),
            title: Text(
              drugName,
              style: kBoldLabelTextStyle,
            ),
            subtitle: Text(
              '  $pharmaceuticalForm   -   $strength $strengthUnit ',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'التاريخ',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: klighterColor,
            thickness: 0.9,
            endIndent: 20,
            indent: 20,
          ),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'الإستعمال',
                      style: ksubBoldLabelTextStyle,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      administrationRoute,
                      style: kValuesTextStyle,
                    ),
                  ],
                ),
                VerticalDivider(
                  indent: 20,
                  endIndent: 20.0,
                  color: kLightColor,
                  thickness: 1.5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' ظروف التخزين',
                      style: ksubBoldLabelTextStyle,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      storageCondition,
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  indent: 20,
                  endIndent: 20.0,
                  color: kLightColor,
                  thickness: 1.5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' الحجم',
                      style: ksubBoldLabelTextStyle,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      '$size $sizeUnit',
                      style: kValuesTextStyle,
                    ),
                  ],
                ),
                VerticalDivider(
                  indent: 20,
                  endIndent: 20.0,
                  color: kLightColor,
                  thickness: 1.5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'السعر',
                      style: ksubBoldLabelTextStyle,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      price,
                      style: kValuesTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  InfoRow(
      {this.label_1,
      this.label_2,
      this.value_1,
      this.value_2,
      this.onChanged_1,
      this.onChanged_2,
      this.onTap_1,
      this.onTap_2,
      this.hintText});
  final String label_1;
  final String label_2;
  final String value_1;
  final String value_2;
  final String hintText;
  Function onChanged_1;
  Function onChanged_2;
  Function onTap_1;
  Function onTap_2;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Container(
            child: Expanded(
              child: ListTile(
                leading: Text(
                  label_1,
                  style: ksubBoldLabelTextStyle,
                ),
                title: Container(
                  child: TextField(
                    onTap: onTap_1,
                    onChanged: onChanged_1,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white54,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: ListTile(
                leading: Text(
                  label_2,
                  style: ksubBoldLabelTextStyle,
                ),
                title: Container(
                  child: TextField(
                    onTap: onTap_2,
                    onChanged: onChanged_2,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      fillColor: Colors.white54,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
