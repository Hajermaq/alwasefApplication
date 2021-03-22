import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
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
  int dose;
  int quantity;
  int refill;
  int dosingExpire;
  var dropdownValue;
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
                                          onChanged_1: (value) {
                                            dose = int.parse(value);
                                          },
                                          labelText: 'الجرعة',
                                        ),
                                        TextField_1(
                                          onChanged_1: (value) {
                                            quantity = int.parse(value);
                                          },
                                          labelText: 'الكمية',
                                        ),
                                        TextField_1(
                                          onChanged_1: (value) {
                                            refill = int.parse(value);
                                          },
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
                                                    fontSize: 25.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                              value: dropdownValue,
                                              icon: Icon(Icons.arrow_drop_down),
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
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()),
                                        ),
                                        DatePicker(
                                          initialValue: DateTime.now(),
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
                                          onChanged: (value) {
                                            _key.currentState.validate();
                                          },
                                        ),
                                        DatePicker(
                                          initialValue: DateTime.now(),
                                          labelText: 'تاريخ النهاية',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'التاريخ مطلوب';
                                            }
                                            return null;
                                          },
                                          date: creationDate,
                                          onSaved: (value) {
                                            endDate = formatter.format(value);
                                          },
                                          onChanged: (value) {
                                            _key.currentState.validate();
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
                                            initialValue: ' ',
                                            labelText: 'تعليمات للمريض',
                                            onChanged_1: (value) {
                                              instructionNote = value;
                                            },
                                            maxLines: maxLines,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(12),
                                          height: maxLines * 24.0,
                                          child: TextField_1(
                                            initialValue: ' ',
                                            labelText: 'ملاحظات للصيدلي',
                                            onChanged_1: (value) {
                                              doctorNotes = value;
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
                                        TextField_1(
                                          onChanged_1: (value) {
                                            dose = int.parse(value);
                                          },
                                          labelText: 'الجرعة',
                                          initialValue: 'hry',
                                        ),
                                        TextField_1(
                                          onChanged_1: (value) {
                                            quantity = int.parse(value);
                                          },
                                          labelText: 'الكمية',
                                        ),
                                        TextField_1(
                                          onChanged_1: (value) {
                                            refill = int.parse(value);
                                          },
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
                                                    fontSize: 25.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                              value: dropdownValue,
                                              icon: Icon(Icons.arrow_drop_down),
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
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()),
                                        ),
                                        DatePicker(
                                          initialValue: DateTime.now(),
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
                                          onChanged: (value) {
                                            _key.currentState.validate();
                                          },
                                        ),
                                        DatePicker(
                                          initialValue: DateTime.now(),
                                          labelText: 'تاريخ النهاية',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'التاريخ مطلوب';
                                            }
                                            return null;
                                          },
                                          date: creationDate,
                                          onSaved: (value) {
                                            endDate = formatter.format(value);
                                          },
                                          onChanged: (value) {
                                            _key.currentState.validate();
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
                                            initialValue: '',
                                            labelText: 'تعليمات للمريض',
                                            onChanged_1: (value) {
                                              instructionNote = value;
                                            },
                                            maxLines: maxLines,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(12),
                                          height: maxLines * 24.0,
                                          child: TextField_1(
                                            initialValue: '',
                                            labelText: 'ملاحظات للصيدلي',
                                            onChanged_1: (value) {
                                              doctorNotes = value;
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
                                frequency: dropdownValue,
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
              color: kBlueColor,
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

class TextField_1 extends StatelessWidget {
  TextField_1(
      {this.onTap_1,
      this.onChanged_1,
      this.labelText,
      this.initialValue,
      this.maxLines,
      this.validator});

  final Function onTap_1;
  final Function onChanged_1;
  final Function validator;
  final String labelText;
  final String initialValue;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
      child: TextFormField(
        validator: validator,
        maxLines: maxLines,
        initialValue: ' ',
        onTap: onTap_1,
        onChanged: onChanged_1,
        style: TextStyle(
          color: kGreyColor,
        ),
        decoration: InputDecoration(
          fillColor: Colors.white54,
          filled: true,
          labelText: labelText,
          labelStyle: GoogleFonts.almarai(
              color: kBlueColor, fontSize: 25.0, fontWeight: FontWeight.bold),
          errorStyle: TextStyle(
            color: kRedColor,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kRedColor,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(35.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: kBlueColor, width: 3.0),
          ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          //   borderSide: BorderSide(color: kBlueColor),
          // ),
        ),
      ),
    );
  }
}
