import 'dart:convert';

import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/drug_info_card.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdatePrescription extends StatefulWidget {
  UpdatePrescription({this.uid, this.documentID});

  final String uid;
  final String documentID;
  static final String id = 'add_prescription_screen';
  @override
  _UpdatePrescriptionState createState() => _UpdatePrescriptionState();
}

class _UpdatePrescriptionState extends State<UpdatePrescription> {
  // formatted date
  static final DateTime now = DateTime.now();
  final String creationDate = formatter.format(now);
  //Data from Api with default value
  String tradeName = '...';
  String tradeNameArabic = '...';
  String scientificName = '...';
  String pharmaceuticalForm = '...';
  String strength = '...';
  String strengthUnit = '...';
  String administrationRoute = '...';
  String storageConditions = '...';
  String publicPrice = '...';
  String registerNumber = ' ';
  String frequency = '...';
  String note1 = '...';
  String note2 = '...';
  //Data from TextFields
  var dropdownvalue;
  int refill;
  String instructionNote;
  String doctorNotes;
  //Random Variables
  String stringFromTF;
  final maxLines = 5;
  // the creation on the prescription date
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // start date
  String startDate;
  // end date
  String endDate;
  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  //Lists
  static List<Prescription> drugsForDisplay = List<Prescription>();
  Future<List<Prescription>> fetchPrescription() async {
    String URL =
        "https://script.googleusercontent.com/macros/echo?user_content_key=cZjO7AxQnGr5mEQU49YQ-3MB88SmMHHlsnReCM8fc3VrB0Jmbp6gVSgTMbPyDazhEpcLWrPjyvkfh4NDqrIzSIdQYbaMdEOSm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnOQBGUzymd9dmG3yxLUZhJsOi89FooeW3AOJmSEjWW9Tv86I0CPwvhEbPZSPmNd8uTjl2UHC3vVSohIuEUGeYk7e5IOKNOHuf9z9Jw9Md8uu&lib=MpUICE4vsIfJjj6VE8jMtH_aUQYat3_A-";

    http.Response response = await http.get(URL);

    List<Prescription> allDrugs = List<Prescription>();

    if (response.statusCode == 200) {
      List jsonArray = json.decode(response.body);

      for (var obj in jsonArray) {
        for (var v in obj.values) {
          String tradename = obj['tradeName'].toLowerCase();
          String scientificname = obj['scientificName'].toLowerCase();
          String tradenamearabic = obj['tradeNameArabic'].toLowerCase();
          if (scientificname.contains(stringFromTF) ||
              tradename.contains(stringFromTF) ||
              tradenamearabic.contains(stringFromTF)) {
            registerNumber = obj['RegisterNumber'].toString();
            tradeName = obj['tradeName'].toString();
            print('from function $tradename');
            scientificName = obj['scientificName'].toString();
            tradeNameArabic = obj['tradeNameArabic'].toString();
            pharmaceuticalForm = obj['PharmaceuticalForm'].toString();
            strength = obj['Strength'].toString();
            strengthUnit = obj['StrengthUnit'].toString();
            administrationRoute = obj['AdministrationRoute'].toString();
            storageConditions = obj['Storage conditions'].toString();
            publicPrice = obj['Public price'].toString();
            frequency = obj['Frequency'].toString();
            note1 = obj['Note1'].toString();
            note2 = obj['Note2'].toString();
          }
        }
      }
    }

    return allDrugs;
  }

  _searchBar() {
    return FilledRoundTextFields(
      onPressed: () {
        setState(() {});
      },
      hintMessage: 'ابحث عن اسم الدواء هنا',
      onChanged: (text) {
        if (!text.isEmpty) {
          stringFromTF = text.toLowerCase();
          fetchPrescription();
        } else {
          print('null');
        }
      },
      fillColor: kGreyColor,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: Form(
                  key: _key,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('/Patient')
                          .doc(widget.uid)
                          .collection('/Prescriptions')
                          .doc(widget.documentID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                              backgroundColor: kGreyColor,
                              valueColor: AlwaysStoppedAnimation(kBlueColor));
                        } else {
                          if (stringFromTF == null) {
                            tradeNameArabic =
                                snapshot.data.get('tradeNameArabic');
                            tradeName = snapshot.data.get('tradeName');
                            publicPrice = snapshot.data.get('price');
                            administrationRoute =
                                snapshot.data.get('administration-route');
                            storageConditions =
                                snapshot.data.get('storage-conditions');
                            scientificName =
                                snapshot.data.get('scientificName');
                            pharmaceuticalForm =
                                snapshot.data.get('pharmaceutical-form');
                            instructionNote =
                                snapshot.data.get('instruction-note');
                            frequency = snapshot.data.get('frequency');
                            refill = snapshot.data.get('refill');
                            strength = snapshot.data.get('strength');
                            strengthUnit = snapshot.data.get('strength-unit');
                            startDate = snapshot.data.get('start-date');
                            endDate = snapshot.data.get('end-date');
                            doctorNotes = snapshot.data.get('doctor-note');
                            note1 = snapshot.data.get('note_1');
                            note2 = snapshot.data.get('note_2');
                          } else {
                            tradeNameArabic = tradeNameArabic;
                            tradeName = tradeName;
                            publicPrice = publicPrice;
                            administrationRoute = administrationRoute;
                            storageConditions = storageConditions;
                            scientificName = scientificName;
                            pharmaceuticalForm = pharmaceuticalForm;
                            instructionNote = instructionNote;
                            frequency = frequency;
                            refill = refill;
                            strength = strength;
                            strengthUnit = strengthUnit;
                            startDate = startDate;
                            endDate = endDate;
                            doctorNotes = doctorNotes;
                            note1 = note1;
                            note2 = note2;
                          }

                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              Column(
                                children: [
                                  DrugInfoCard(
                                    drugName: tradeName,
                                    pharmaceuticalForm: pharmaceuticalForm,
                                    date: creationDate,
                                    administrationRoute: administrationRoute,
                                    storageCondition: storageConditions,
                                    price: publicPrice,
                                  ),
                                  DosageCard(
                                    strength,
                                    strengthUnit,
                                    pharmaceuticalForm,
                                    frequency,
                                    note1,
                                    note2,
                                    scientificName,
                                  ),
                                  Card(
                                    color: kGreyColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              validator: Validation()
                                                  .validateIntegerNumber,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              decoration: InputDecoration(
                                                labelText: 'إعادة التعبئة',
                                                border: OutlineInputBorder(),
                                                prefixIcon: Icon(Icons.redo),
                                              ),
                                              onSaved: (value) {
                                                refill = int.parse(value);
                                              },
                                              initialValue:
                                                  '${snapshot.data.get('refill')}',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DateTimeField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'تاريخ بداية الوصفة:',
                                                border: OutlineInputBorder(),
                                                prefixIcon:
                                                    Icon(Icons.calendar_today),
                                              ),
                                              format: dateFormat,
                                              validator: (value) =>
                                                  value == null
                                                      ? 'هذا الحقل مطلوب'
                                                      : null,
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                  context: context,
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: ThemeData.light()
                                                          .copyWith(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                          primary: kGreyColor,
                                                          onPrimary:
                                                              klighterColor,
                                                          surface: kLightColor,
                                                        ),
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                                  initialDate: DateTime.now()
                                                      .subtract(
                                                          Duration(days: 0)),
                                                  firstDate: currentValue ??
                                                      DateTime.now(),
                                                  lastDate: DateTime(2070),
                                                );
                                              },
                                              onSaved: (value) {
                                                if (value != null) {
                                                  startDate =
                                                      formatter.format(value);
                                                }
                                              },
                                              initialValue: snapshot.data
                                                          .get('start-date') ==
                                                      null
                                                  ? DateTime.tryParse('')
                                                  : DateTime.tryParse(snapshot
                                                      .data
                                                      .get('start-date')),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DateTimeField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'تاريخ نهاية الوصفة:',
                                                border: OutlineInputBorder(),
                                                prefixIcon:
                                                    Icon(Icons.calendar_today),
                                              ),
                                              format: dateFormat,
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                  context: context,
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: ThemeData.light()
                                                          .copyWith(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                          primary: kGreyColor,
                                                          onPrimary:
                                                              klighterColor,
                                                          surface: kLightColor,
                                                        ),
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                                  initialDate: DateTime.now()
                                                      .subtract(
                                                          Duration(days: 0)),
                                                  firstDate: currentValue ??
                                                      DateTime.now(),
                                                  lastDate: DateTime(2070),
                                                );
                                              },
                                              onSaved: (value) {
                                                if (value != null) {
                                                  endDate =
                                                      formatter.format(value);
                                                }
                                              },
                                              initialValue: snapshot.data
                                                          .get('end-date') ==
                                                      null
                                                  ? DateTime.tryParse('')
                                                  : DateTime.tryParse(snapshot
                                                      .data
                                                      .get('end-date')),
                                            ),
                                          ),
                                          Divider(
                                            color: klighterColor,
                                            thickness: 0.9,
                                            endIndent: 20,
                                            indent: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                labelText: 'تعليمات للمريض',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator:
                                                  Validation().validateMessage,
                                              onSaved: (value) {
                                                setState(() {
                                                  instructionNote = value;
                                                });
                                              },
                                              initialValue:
                                                  '${snapshot.data.get('instruction-note')}',
                                              //controller: hospCtrl,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                labelText: 'ملاحظات للصيدلي',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator:
                                                  Validation().validateMessage,
                                              onSaved: (value) {
                                                setState(() {
                                                  doctorNotes = value;
                                                });
                                              },
                                              initialValue: snapshot.data
                                                  .get('doctor-note'),
                                              //controller: hospCtrl,
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
                                      'تعديل',
                                      style: TextStyle(
                                        color: Colors.white,
                                        // fontFamily: 'Montserrat',
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        UserManagement(
                                                documentId: widget.documentID,
                                                currentPatient_uid: widget.uid)
                                            .prescriptionUpdate(
                                          note1: note1,
                                          note2: note2,
                                          scientificName: scientificName,
                                          context: context,
                                          patientId: widget.uid,
                                          prescriberId: snapshot.data
                                              .get('prescriber-id'),
                                          creationDate: creationDate,
                                          startDate: startDate,
                                          endDate: endDate,
                                          tradeName: tradeName,
                                          tradeNameArabic: tradeNameArabic,
                                          strengthUnit: strengthUnit,
                                          strength: strength,
                                          pharmaceuticalForm:
                                              pharmaceuticalForm,
                                          administrationRoute:
                                              administrationRoute,
                                          storageConditions: storageConditions,
                                          publicPrice: publicPrice,
                                          refill: refill,
                                          frequency: frequency,
                                          instructionNote: instructionNote,
                                          doctorNotes: doctorNotes,
                                        );

                                        Flushbar(
                                          backgroundColor: Colors.white,
                                          borderRadius: 4.0,
                                          margin: EdgeInsets.all(8.0),
                                          duration: Duration(seconds: 4),
                                          messageText: Text(
                                            ' تم تعديل الوصفة بنجاح.',
                                            style: TextStyle(
                                              color: kBlueColor,
                                              fontFamily: 'Almarai',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )..show(context).then(
                                            (r) => Navigator.pop(context));
                                      } else {
                                        // there is an error
                                        setState(() {
                                          autovalidateMode =
                                              AutovalidateMode.always;
                                        });
                                      }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
