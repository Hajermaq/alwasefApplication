import 'dart:math';

import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/components/drug_info_card.dart';
import 'package:alwasef_app/components/text_field_1.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPrescriptions extends StatefulWidget {
  AddPrescriptions({this.uid});
  final String uid;
  static final String id = 'add_prescription_screen';
  @override
  _AddPrescriptionsState createState() => _AddPrescriptionsState();
}

class _AddPrescriptionsState extends State<AddPrescriptions> {
  //FirrStore
  String prescriberId = FirebaseAuth.instance.currentUser.uid;
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
  // formatted date
  static final DateTime now = DateTime.now();
  final String creationDate = formatter.format(now);
  //Data from TextFields
  var dropdownvalue;
  double dose;
  int quantity;
  int refill;
  int dosingExpire;
  var doseUnit;
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
  //to generate random number
  Random rnd = new Random();
  String s = '';

  //Lists
  static List<Prescription> drugsForDisplay = List<Prescription>();
  List<Prescription> _drugs = List<Prescription>();

  @override
  void initState() {
    var l = new List.generate(6, (_) => rnd.nextInt(10));
    print(l);

    for (var i in l) {
      s = '$s' + i.toString();
    }
  } //Methods

  Future<List<Prescription>> fetchPrescription() async {
    String URL =
        "https://script.googleusercontent.com/macros/echo?user_content_key=cZjO7AxQnGr5mEQU49YQ-3MB88SmMHHlsnReCM8fc3VrB0Jmbp6gVSgTMbPyDazhEpcLWrPjyvkfh4NDqrIzSIdQYbaMdEOSm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnOQBGUzymd9dmG3yxLUZhJsOi89FooeW3AOJmSEjWW9Tv86I0CPwvhEbPZSPmNd8uTjl2UHC3vVSohIuEUGeYk7e5IOKNOHuf9z9Jw9Md8uu&lib=MpUICE4vsIfJjj6VE8jMtH_aUQYat3_A-";

    http.Response response = await http.get(URL);

    List<Prescription> allDrugs = List<Prescription>();

    if (response.statusCode == 200) {
      List jsonArray = json.decode(response.body);

      for (var obj in jsonArray) {
        for (var v in obj.values) {
          var b = v.toString();
          String tradename = obj['tradeName'].toLowerCase();
          String scientificname = obj['scientificName'].toLowerCase();
          String tradenamearabic = obj['tradeNameArabic'].toLowerCase();
          if (scientificname.contains(stringFromTF) ||
              tradename.contains(stringFromTF) ||
              tradenamearabic.contains(stringFromTF)) {
            registerNumber = obj['RegisterNumber'].toString();
            tradeName = obj['tradeName'].toString();
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
      hintMessage: 'ابحث عن اسم الدواء هنا',
      onChanged: (text) {
        setState(() {
          if (!text.isEmpty) {
            stringFromTF = text.toLowerCase();
            fetchPrescription();
          } else {
            print('null');
          }
        });
      },
      fillColor: kGreyColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: kLightColor,
      ),
      child: Scaffold(
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
                    FutureBuilder(
                      future: fetchPrescription(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Form(
                            key: _key,
                            autovalidateMode: autovalidateMode,
                            child: Column(
                              children: [
                                DrugInfoCard(
                                    drugName: tradeName,
                                    pharmaceuticalForm: pharmaceuticalForm,
                                    date: creationDate,
                                    administrationRoute: administrationRoute,
                                    storageCondition: storageConditions,
                                    price: publicPrice),
                                SizedBox(
                                  height: 90,
                                ),
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 90,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Form(
                            key: _key,
                            autovalidateMode: autovalidateMode,
                            child: Column(
                              children: [
                                DrugInfoCard(
                                  drugName: tradeNameArabic.isEmpty
                                      ? tradeName
                                      : tradeNameArabic,
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
                                    scientificName),
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
                                        TextField_1(
                                          textInputType:
                                              TextInputType.numberWithOptions(
                                                  decimal: false),
                                          onSaved: (value) {
                                            refill = int.parse(value);
                                          },
                                          validator: Validation()
                                              .validateIntegerNumber,
                                          labelText: 'إعادة التعبئة',
                                        ),
                                        DatePicker(
                                          labelText: 'تاريخ البداية',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'التاريخ مطلوب';
                                            }
                                            return null;
                                          },
                                          date: creationDate,
                                          onSaved: (value) {
                                            startDate = formatter.format(value);
                                          },
                                        ),
                                        DatePicker(
                                          labelText: 'تاريخ النهاية',
                                          date: creationDate,
                                          onSaved: (value) {
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
                                            onSaved: (String newValue) {
                                              setState(() {
                                                instructionNote = newValue;
                                              });
                                            },
                                            maxLines: maxLines,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(12),
                                          height: maxLines * 24.0,
                                          child: TextField_1(
                                            labelText: 'ملاحظات للصيدلي',
                                            onSaved: (String newValue) {
                                              setState(() {
                                                doctorNotes = newValue;
                                              });
                                            },
                                            maxLines: maxLines,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 20.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          textColor: Colors.white54,
                          color: kGreyColor,
                          child: Text(
                            'إرسال',
                            style: TextStyle(
                              color: Colors.white,
                              // fontFamily: 'Montserrat',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              UserManagement(currentPatient_uid: widget.uid)
                                  .newPrescriptionSetUp(
                                context: context,
                                patientId: widget.uid,
                                prescriberId: prescriberId,
                                presciptionId: '[$s]',
                                creationDate: creationDate,
                                startDate: startDate,
                                endDate: endDate,
                                scientificName: scientificName,
                                tradeName: tradeName,
                                tradeNameArabic: tradeNameArabic,
                                strengthUnit: strengthUnit,
                                strength: strength,
                                note1: note1,
                                note2: note2,
                                pharmaceuticalForm: pharmaceuticalForm,
                                administrationRoute: administrationRoute,
                                storageConditions: storageConditions,
                                publicPrice: publicPrice,
                                refill: refill,
                                frequency: frequency,
                                instructionNote: instructionNote,
                                doctorNotes: doctorNotes,
                              );
                            } else {
                              // there is an error
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
