import 'dart:collection';

import 'package:alwasef_app/Screens/all_doctor_screens/prescriptions_page.dart';
import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/drug_info_card.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/text_field_1.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_prescriptions.dart';

class UpdatePrescription extends StatefulWidget {
  UpdatePrescription({this.uid, this.documentID});

  final String uid;
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
  double dose = 0.0;
  int quantity = 0;
  int refill = 0;
  int dosingExpire = 0;
  var frequency;
  var doseUnit;
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
  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  //controller

  //Lists
  static List<Prescription> drugsForDisplay = List<Prescription>();
  List<Prescription> _drugs = List<Prescription>();
  @override

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
    print(refill);
    print(widget.documentID);

    print(widget.uid);

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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/Patient')
                        .doc(widget.uid)
                        .collection('/Prescriptions')
                        .doc(widget.documentID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        instructionNote = snapshot.data.get('instruction-note');
                        frequency = snapshot.data.get('frequency');
                        refill = snapshot.data.get('refill');
                        dose = snapshot.data.get('dose');
                        doseUnit = snapshot.data.get('dose-unit');
                        quantity = snapshot.data.get('quantity');
                        startDate = snapshot.data.get('start-date');
                        endDate = snapshot.data.get('end-date');
                        doctorNotes = snapshot.data.get('doctor-note');
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            Column(
                              children: [
                                DrugInfoCard(
                                  drugName:
                                      snapshot.data.get('tradeName') == null
                                          ? snapshot.data.get('tradeNameArabic')
                                          : snapshot.data.get('tradeName'),
                                  pharmaceuticalForm:
                                      snapshot.data.get('pharmaceutical-form'),
                                  strength: snapshot.data.get('strength'),
                                  strengthUnit:
                                      snapshot.data.get('strength-unit'),
                                  date: snapshot.data
                                      .get('prescription-creation-date'),
                                  administrationRoute:
                                      snapshot.data.get('administration-route'),
                                  storageCondition:
                                      snapshot.data.get('storage-conditions'),
                                  size: snapshot.data.get('size'),
                                  sizeUnit: snapshot.data.get('size-unit'),
                                  price: snapshot.data.get('price'),
                                ),
                                Card(
                                  color: kGreyColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  margin:
                                      EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 8.0, 0.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: TextField_1(
                                                  validator: Validation()
                                                      .validateDoubleNumber,
                                                  textInputType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  onChanged: (value) {
                                                    dose = double.parse(value);
                                                  },
                                                  labelText: 'الجرعة',
                                                  initialValue:
                                                      '${snapshot.data.get('dose')}',
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: DropdownButtonFormField<
                                                        String>(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(17.0),
                                                      fillColor: Colors.white54,
                                                      filled: true,
                                                      labelStyle:
                                                          GoogleFonts.almarai(
                                                              color: kBlueColor,
                                                              fontSize: 25.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      errorStyle: TextStyle(
                                                        color: kRedColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0,
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: kRedColor,
                                                            width: 3.0),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                    value: snapshot.data
                                                        .get('dose-unit'),
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    validator: Validation()
                                                        .validateDropDownMenue,
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        doseUnit = newValue;
                                                      });
                                                    },
                                                    hint: Text(
                                                      'فضلا اختر ',
                                                      style:
                                                          GoogleFonts.almarai(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    items: <String>[
                                                      'µg',
                                                      'mg',
                                                      'g',
                                                      'ml',
                                                      'tbsp (15ml)',
                                                      'tsp (5ml)',
                                                      'gr',
                                                      'capsule',
                                                      'capsules',
                                                      'Tablet ',
                                                      'Tablets ',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      );
                                                    }).toList()),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextField_1(
                                          textInputType:
                                              TextInputType.numberWithOptions(
                                                  decimal: false),
                                          onChanged: (value) {
                                            quantity = int.parse(value);
                                          },
                                          validator: Validation()
                                              .validateIntegerNumber,
                                          labelText: 'الكمية',
                                          initialValue:
                                              '${snapshot.data.get('quantity')}',
                                        ),
                                        TextField_1(
                                          textInputType:
                                              TextInputType.numberWithOptions(
                                                  decimal: false),
                                          onChanged: (value) {
                                            refill = int.parse(value);
                                          },
                                          validator: Validation()
                                              .validateIntegerNumber,
                                          labelText: 'إعادة التعبئة',
                                          initialValue:
                                              '${snapshot.data.get('refill')}',
                                        ),
                                        Divider(
                                          color: klighterColor,
                                          thickness: 0.9,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 8.0, 20.0, 8.0),
                                          child: DropdownButtonFormField<
                                                  String>(
                                              decoration: InputDecoration(
                                                fillColor: Colors.white54,
                                                filled: true,
                                                labelText: 'التكرار',
                                                labelStyle: GoogleFonts.almarai(
                                                    color: kBlueColor,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: kRedColor,
                                                    width: 4.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kRedColor,
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                              ),
                                              icon: Icon(Icons.arrow_drop_down),
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              value: snapshot.data
                                                  .get('frequency'),
                                              validator: Validation()
                                                  .validateDropDownMenue,
                                              onChanged: (String newValue) {
                                                frequency = newValue;
                                              },
                                              // onChanged: (value) {},
                                              // hint: Text(
                                              //   '${snapshot.data.get('frequency')}',
                                              //   style: GoogleFonts.almarai(
                                              //     color: Colors.black54,
                                              //   ),
                                              // ),
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
                                                'اخرى',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Center(
                                                    child: Text(
                                                      value,
                                                    ),
                                                  ),
                                                );
                                              }).toList()),
                                        ),
                                        DatePicker(
                                          initialValue: DateTime.parse(
                                              snapshot.data.get('start-date')),
                                          labelText: 'تاريخ البداية',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'التاريخ مطلوب';
                                            }
                                            return null;
                                          },
                                          date: creationDate,
                                          onChanged: (value) {
                                            startDate = formatter.format(value);
                                          },
                                        ),
                                        DatePicker(
                                          initialValue: DateTime.parse(
                                              snapshot.data.get('end-date')),
                                          labelText: 'تاريخ النهاية',
                                          date: creationDate,
                                          validator: (value) {
                                            if (value == null) {
                                              return '';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            endDate = formatter.format(value);
                                          },
                                        ),
                                        Divider(
                                          color: klighterColor,
                                          thickness: 0.9,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(12),
                                          height: maxLines * 24.0,
                                          child: TextField_1(
                                            labelText: 'تعليمات للمريض',
                                            validator:
                                                Validation().validateMessage,
                                            onChanged: (String value) {
                                              instructionNote = value;
                                            },
                                            maxLines: maxLines,
                                            initialValue:
                                                '${snapshot.data.get('instruction-note')}',
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(12),
                                          height: maxLines * 24.0,
                                          child: TextField_1(
                                            labelText: 'ملاحظات للصيدلي',
                                            onChanged: (value) {
                                              doctorNotes = value;
                                            },
                                            maxLines: maxLines,
                                            initialValue: snapshot.data
                                                .get('doctor-note'),
                                          ),
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
                                    print(refill);
                                    print(instructionNote);
                                    print(frequency);
                                    UserManagement(
                                            documentId: widget.documentID,
                                            currentPatient_uid: widget.uid)
                                        .prescriptionUpdate(
                                      context: context,
                                      patientId: widget.uid,
                                      prescriberId: '',
                                      registerNumber:
                                          snapshot.data.get('registerNumber'),
                                      creationDate: creationDate,
                                      startDate: startDate,
                                      endDate: endDate,
                                      tradeName: snapshot.data.get('tradeName'),
                                      tradeNameArabic:
                                          snapshot.data.get('tradeNameArabic'),
                                      strengthUnit:
                                          snapshot.data.get('strength-unit'),
                                      strength: snapshot.data.get('strength'),
                                      pharmaceuticalForm: snapshot.data
                                          .get('pharmaceutical-form'),
                                      administrationRoute: snapshot.data
                                          .get('administration-route'),
                                      size: snapshot.data.get('size'),
                                      sizeUnit: snapshot.data.get('size-unit'),
                                      storageConditions: snapshot.data
                                          .get('storage-conditions'),
                                      publicPrice: snapshot.data.get('price'),
                                      dose: dose,
                                      quantity: quantity,
                                      refill: refill,
                                      dosingExpire: dosingExpire,
                                      frequency: frequency,
                                      doseUnit: doseUnit,
                                      instructionNote: instructionNote,
                                      doctorNotes: doctorNotes,
                                    );
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
