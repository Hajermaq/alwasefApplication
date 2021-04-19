import 'dart:math';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
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
  AddPrescriptions({this.uid, this.pharmacistUid});
  final String uid;
  final String pharmacistUid;
  static final String id = 'add_prescription_screen';
  @override
  _AddPrescriptionsState createState() => _AddPrescriptionsState();
}

class _AddPrescriptionsState extends State<AddPrescriptions> with SingleTickerProviderStateMixin{
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
  ValueNotifier<DateTime> tempStartDate = ValueNotifier<DateTime>(DateTime.now());
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
                                CircularProgressIndicator(
                                    backgroundColor: kGreyColor,
                                    valueColor:
                                        AlwaysStoppedAnimation(kBlueColor)),
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            validator: Validation()
                                                .validateIntegerNumber,
                                            keyboardType: TextInputType.number,
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
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DateTimeField(
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              labelText: 'تاريخ بداية الوصفة:',
                                              border: OutlineInputBorder(),
                                              prefixIcon:
                                                  Icon(Icons.calendar_today),
                                            ),
                                            format: dateFormat,
                                            validator: (value) => value == null
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
                                                initialDate: tempStartDate.value,
                                                firstDate: currentValue ??
                                                    DateTime.now(),
                                                lastDate: DateTime(2070),
                                              ).then((DateTime dateTime) => tempStartDate.value = dateTime);
                                            },
                                            onSaved: (value) {
                                              if (value != null) {
                                                startDate =
                                                    formatter.format(value);
                                              }
                                            },

                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DateTimeField(
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              labelText: 'تاريخ نهاية الوصفة:',
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
                                                initialDate: tempStartDate.value ??
                                                    DateTime.now(),
                                                firstDate: tempStartDate.value,
                                                lastDate: DateTime(2070),
                                              );
                                            },
                                            onSaved: (value) {
                                              if (value != null) {
                                                endDate =
                                                    formatter.format(value);
                                              }
                                            },
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
                                            //controller: hospCtrl,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 100.0,
                                              vertical: 20.0),
                                          child: Container(
                                            height: 50.0,
                                            child: RaisedButton(
                                              textColor: kGreyColor,
                                              color: Colors.white,
                                              child: Text(
                                                '     إرسال     ',
                                                style: TextStyle(
                                                  color: kGreyColor,
                                                  // fontFamily: 'Montserrat',
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_key.currentState
                                                    .validate()) {
                                                  _key.currentState.save();
                                                  UserManagement(
                                                          currentPatient_uid:
                                                              widget.uid)
                                                      .newPrescriptionSetUp(
                                                    context: context,
                                                    patientId: widget.uid,
                                                    prescriberId: prescriberId,
                                                    prepharmacistId:
                                                        widget.pharmacistUid,
                                                    presciptionId: '[$s]',
                                                    creationDate: creationDate,
                                                    startDate: startDate,
                                                    endDate: endDate,
                                                    scientificName:
                                                        scientificName,
                                                    tradeName: tradeName,
                                                    tradeNameArabic:
                                                        tradeNameArabic,
                                                    strengthUnit: strengthUnit,
                                                    strength: strength,
                                                    note1: note1,
                                                    note2: note2,
                                                    pharmaceuticalForm:
                                                        pharmaceuticalForm,
                                                    administrationRoute:
                                                        administrationRoute,
                                                    storageConditions:
                                                        storageConditions,
                                                    publicPrice: publicPrice,
                                                    refill: refill,
                                                    frequency: frequency,
                                                    instructionNote:
                                                        instructionNote,
                                                    doctorNotes: doctorNotes,
                                                  );

                                                  Flushbar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    borderRadius: 4.0,
                                                    margin: EdgeInsets.all(8.0),
                                                    duration:
                                                        Duration(seconds: 4),
                                                    messageText: Text(
                                                      ' تم إضافة وصفة جديدة لهذا المريض',
                                                      style: TextStyle(
                                                        color: kBlueColor,
                                                        fontFamily: 'Almarai',
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )..show(context).then((r) =>
                                                      Navigator.pop(context));
                                                } else {
                                                  // there is an error
                                                  setState(() {
                                                    autovalidateMode =
                                                        AutovalidateMode.always;
                                                  });
                                                }
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
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
