import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/components/drug_info_card.dart';
import 'package:alwasef_app/components/text_field_1.dart';
import 'package:alwasef_app/models/prescription_model.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/prescriptions_page.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/DatePicker.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dropdownfield/dropdownfield.dart';
import 'dart:convert';

class AddPrescriptions extends StatefulWidget {
  AddPrescriptions({this.uid});
  final String uid;
  static final String id = 'add_prescription_screen';
  @override
  _AddPrescriptionsState createState() => _AddPrescriptionsState();
}

class _AddPrescriptionsState extends State<AddPrescriptions> {
  //Data from Api with default value
  String tradeName = '...';
  String tradeNameArabic = '...';
  String scientificName = '...';
  String scientificNameArabic = '...';
  String pharmaceuticalForm = '...';
  String strength = '...';
  String strengthUnit = '...';
  String administrationRoute = '...';
  String storageConditions = '...';
  String size = '...';
  String sizeUnit = '...';
  String publicPrice = '...';
  String registerNumber = ' ';
  String prescriberId = FirebaseAuth.instance.currentUser.uid;
  // formatted date
  static final DateTime now = DateTime.now();
  final String creationDate = formatter.format(now);
  //Data from TextFields
  double dose;
  int quantity;
  int refill;
  int dosingExpire;
  var frequency;
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

  //Lists
  static List<Prescription> drugsForDisplay = List<Prescription>();
  List<Prescription> _drugs = List<Prescription>();

  //Methods
  Future<List<Prescription>> fetchPrescription() async {
    String URL =
        "https://script.googleusercontent.com/macros/echo?user_content_key=cAbM4t4QBok3C-ge7q-btotJwo5vEKkmPMfTJG7KxohRGXb1klbjY2WwX5qzlnIMrooCIe9jBqj8Jzb0JQp7oOylv8--WLXPm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPsISVB9LxVeJlpr_xgRdjHnjvdICkfnEX1ie34R1BLiWZPA0kx7zt8eOiaQDa_wFLM0pjjXN9yIvJsw0wqpxiI&lib=MpUICE4vsIfJjj6VE8jMtH_aUQYat3_A-";

    http.Response response = await http.get(URL);

    List<Prescription> allDrugs = List<Prescription>();

    if (response.statusCode == 200) {
      List jsonArray = json.decode(response.body);

      for (var obj in jsonArray) {
        // print('1');
        for (var v in obj.values) {
          // print('2');
          var b = v.toString();
          String name = obj['tradeName'].toLowerCase();
          if (name.contains(stringFromTF)) {
            registerNumber = obj['RegisterNumber'].toString();
            tradeName = obj['tradeName'].toString();
            scientificName = obj['scientificName'].toString();
            tradeNameArabic = obj['tradeNameArabic'].toString();
            scientificNameArabic = obj['scientificNameArabic'].toString();
            pharmaceuticalForm = obj['PharmaceuticalForm'].toString();
            strength = obj['Strength'].toString();
            strengthUnit = obj['StrengthUnit'].toString();
            administrationRoute = obj['AdministrationRoute'].toString();
            storageConditions = obj['Storage conditions'].toString();
            size = obj['Size'].toString();
            sizeUnit = obj['SizeUnit'].toString();
            publicPrice = obj['Public price'].toString();
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
        stringFromTF = text.toLowerCase();
        fetchPrescription();
      },
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
                                    strength: strength,
                                    strengthUnit: strengthUnit,
                                    date: creationDate,
                                    administrationRoute: administrationRoute,
                                    storageCondition: storageConditions,
                                    size: size,
                                    sizeUnit: sizeUnit,
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
                                  strength: strength,
                                  strengthUnit: strengthUnit,
                                  date: creationDate,
                                  administrationRoute: administrationRoute,
                                  storageCondition: storageConditions,
                                  size: size,
                                  sizeUnit: sizeUnit,
                                  price: publicPrice,
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
                                                  onSaved: (value) {
                                                    dose = double.parse(value);
                                                  },
                                                  labelText: 'الجرعة',
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
                                                    value: doseUnit,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    validator: Validation()
                                                        .validateDropDownMenue,
                                                    onChanged: (v) {},
                                                    onSaved: (String newValue) {
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
                                          onSaved: (value) {
                                            quantity = int.parse(value);
                                          },
                                          validator: Validation()
                                              .validateIntegerNumber,
                                          labelText: 'الكمية',
                                        ),
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
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              value: frequency,
                                              icon: Icon(Icons.arrow_drop_down),
                                              validator: Validation()
                                                  .validateDropDownMenue,
                                              onChanged: (v) {},
                                              onSaved: (String newValue) {
                                                setState(() {
                                                  frequency = newValue;
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
                                                'اخرى',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              }).toList()),
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
                                registerNumber: registerNumber,
                                creationDate: creationDate,
                                startDate: startDate,
                                endDate: endDate,
                                scientificName: scientificName,
                                scientificNameArabic: scientificNameArabic,
                                tradeName: tradeName,
                                tradeNameArabic: tradeNameArabic,
                                strengthUnit: strengthUnit,
                                strength: strength,
                                pharmaceuticalForm: pharmaceuticalForm,
                                administrationRoute: administrationRoute,
                                size: size,
                                sizeUnit: sizeUnit,
                                storageConditions: storageConditions,
                                publicPrice: publicPrice,
                                dose: dose,
                                quantity: quantity,
                                refill: refill,
                                dosingExpire: dosingExpire,
                                frequency: frequency,
                                doseUnit: doseUnit,
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
