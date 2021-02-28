import 'package:alwasef_app/Screens/services/prescription_model.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// searchTextField = AutoCompleteTextField<PrescriptionModel>(
// // textChanged: (value) {
// //   print('pritnttt $value');
// // },
// itemSubmitted: (item) {
// setState(() {
// searchTextField.textField.controller.text =
// item.scientificName.toLowerCase();
// });
// },
// controller: controller,
// clearOnSubmit: false,
// key: key,
// suggestions: drugs,
// style: TextStyle(
// color: kBlueColor,
// fontSize: 16.0,
// ),
// decoration: InputDecoration(
// contentPadding:
// EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
// hintText: 'ابحث عن اسم الدواء',
// hintStyle: TextStyle(color: kBlueColor),
// ),
// itemBuilder: (context, item) {
// return row(item);
// },
// itemSorter: (a, b) {
// return a.scientificName
//     .toLowerCase()
//     .compareTo(b.scientificName.toLowerCase());
// },
// itemFilter: (item, query) {
// return item.scientificName.startsWith(query);
// }),
class AddPrescriptions extends StatefulWidget {
  static final String id = 'add_prescription_screen';
  @override
  _AddPrescriptionsState createState() => _AddPrescriptionsState();
}

class _AddPrescriptionsState extends State<AddPrescriptions> {
  //Data from Api with default value
  String drugName = '...';
  String pharmaceuticalForm = '...';
  String strength = '...';
  String strengthUnit = '...';
  String administrationRoute = '...';
  String storageCondition = '...';
  String size = '...';
  String sizeUnit = '...';
  String price = '...';
  final String date = formatter.format(now);
  //Data from TextFields
  int dose;
  int quantity;
  int refill;
  int dosingExpire;
  var dropdownValue;
  String instructionNote;
  String doctorNotes;
  var TheDrug;
  //Random Variables
  String notAvailable = 'لا يوجد';
  String textt;
  var vv;
  final maxLines = 5;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  //Lists
  static List<PrescriptionModel> drugsForDisplay = List<PrescriptionModel>();
  List<PrescriptionModel> _drugs = List<PrescriptionModel>();
  //Methods
  Future<List<PrescriptionModel>> fetchPrescription() async {
    String URL =
        "https://script.googleusercontent.com/macros/echo?user_content_key=ch35Vxoajiqxza0FSvAdEheh0HES3Lz2e4-4UZlh4MBzWaer9nX0yrAT_5-tL0WKnYgC5u5T0UHSBNPXpL-2dKnZOCBggDAbm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPsISVB9LxVeJlpr_xgRdjHnjvdICkfnEX1ie34R1BLiWZPA0kx7zt8eOiaQDa_wFLM0pjjXN9yIvJsw0wqpxiI&lib=MpUICE4vsIfJjj6VE8jMtH_aUQYat3_A-";

    http.Response response = await http.get(URL);

    List<PrescriptionModel> allDrugs = List<PrescriptionModel>();

    if (response.statusCode == 200) {
      List jsonArray = json.decode(response.body);

      for (var obj in jsonArray) {
        PrescriptionModel.fromJason(obj);
      }
    }

    return allDrugs;
  }

  @override
  void initState() {
    super.initState();
    fetchPrescription();
    fetchPrescription().then((value) {
      setState(() {
        _drugs.addAll(value);
        drugsForDisplay = _drugs;
      });
    });
  }

  _searchBar() {
    return FilledRoundTextFields(
      hintMessage: 'ابحث عن اسم الدواء هنا',
      onChanged: (text) {
        textt = text.toLowerCase();
        setState(() {
          _drugs.forEach((drug) {
            if (drug.tradeName.toLowerCase().contains(text.toLowerCase())) {
              drugsForDisplay.add(drug);
            }
          });
        });
      },
      fillColor: kGreyColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < drugsForDisplay.length; i++) {
      print(drugsForDisplay[i]);
    }
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: kLightColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                        final orientation = MediaQuery.of(context).orientation;
                        if (snapshot.data == null) {
                          return Column(
                            children: [
                              DrugInfoCard(
                                  drugName: drugName,
                                  pharmaceuticalForm: pharmaceuticalForm,
                                  strength: strength,
                                  strengthUnit: strengthUnit,
                                  date: date,
                                  administrationRoute: administrationRoute,
                                  storageCondition: storageCondition,
                                  size: size,
                                  sizeUnit: sizeUnit,
                                  price: price),
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
                                      InfoRow(
                                        label_1: 'الجرعة',
                                        onChanged_1: (value) {
                                          dose = value;
                                        },
                                        label_2: 'الكمية',
                                        onChanged_2: (value) {
                                          quantity = value;
                                        },
                                      ),
                                      InfoRow(
                                        label_1: 'اعادة \nالتعبئه',
                                        onChanged_1: (value) {
                                          refill = value;
                                        },
                                        label_2: 'يوم انتهاء\n الوصفة',
                                        onChanged_2: (value) {
                                          dosingExpire = value;
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
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),

                                                  // dropdown below..
                                                  child: DropdownButton<String>(
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                      ),
                                                      isExpanded: true,
                                                      value: dropdownValue,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 42,
                                                      underline: SizedBox(),
                                                      onChanged:
                                                          (String newValue) {
                                                        setState(() {
                                                          dropdownValue =
                                                              newValue;
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
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
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
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            BorderSide(),
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
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            BorderSide(),
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
                          );
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: drugsForDisplay.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    DrugInfoCard(
                                      drugName: drugsForDisplay[index]
                                                  .tradeName
                                                  .toString() ==
                                              ' '
                                          ? drugsForDisplay[index]
                                              .scientificName
                                              .toString()
                                          : drugsForDisplay[index]
                                              .tradeName
                                              .toString(),
                                      pharmaceuticalForm: drugsForDisplay[index]
                                                  .pharmaceuticalForm ==
                                              " "
                                          ? notAvailable
                                          : drugsForDisplay[index]
                                              .pharmaceuticalForm
                                              .toString(),
                                      strength:
                                          drugsForDisplay[index].strength == " "
                                              ? notAvailable
                                              : drugsForDisplay[index]
                                                  .strength
                                                  .toString(),
                                      strengthUnit: drugsForDisplay[index]
                                                  .strengthUnit
                                                  .toString() ==
                                              " "
                                          ? ' '
                                          : drugsForDisplay[index]
                                              .strengthUnit
                                              .toString(),
                                      date: date.toString(),
                                      administrationRoute:
                                          drugsForDisplay[index]
                                                      .administrationRoute
                                                      .toString() ==
                                                  " "
                                              ? notAvailable
                                              : drugsForDisplay[index]
                                                  .administrationRoute
                                                  .toString(),
                                      storageCondition: drugsForDisplay[index]
                                                  .storageConditions
                                                  .toString() ==
                                              " "
                                          ? notAvailable
                                          : drugsForDisplay[index]
                                              .storageConditions
                                              .toString(),
                                      size: drugsForDisplay[index]
                                                  .size
                                                  .toString() ==
                                              " "
                                          ? notAvailable
                                          : drugsForDisplay[index]
                                              .size
                                              .toString(),
                                      sizeUnit: drugsForDisplay[index]
                                                  .sizeUnit
                                                  .toString() ==
                                              " "
                                          ? ' '
                                          : drugsForDisplay[index]
                                              .sizeUnit
                                              .toString(),
                                      price: drugsForDisplay[index]
                                                  .publicPrice
                                                  .toString() ==
                                              ""
                                          ? notAvailable
                                          : drugsForDisplay[index]
                                              .publicPrice
                                              .toString(),
                                    ),
                                    Card(
                                      color: kGreyColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            InfoRow(
                                              label_1: 'الجرعة',
                                              onChanged_1: (value) {
                                                dose = value;
                                              },
                                              label_2: 'الكمية',
                                              onChanged_2: (value) {
                                                quantity = value;
                                              },
                                            ),
                                            InfoRow(
                                              label_1: 'اعادة \nالتعبئه',
                                              onChanged_1: (value) {
                                                refill = value;
                                              },
                                              label_2: 'يوم انتهاء\n الوصفة',
                                              onChanged_2: (value) {
                                                dosingExpire = value;
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
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      title: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white54,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),

                                                        // dropdown below..
                                                        child: DropdownButton<
                                                                String>(
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            isExpanded: true,
                                                            value:
                                                                dropdownValue,
                                                            icon: Icon(Icons
                                                                .arrow_drop_down),
                                                            iconSize: 42,
                                                            underline:
                                                                SizedBox(),
                                                            onChanged: (String
                                                                newValue) {
                                                              setState(() {
                                                                dropdownValue =
                                                                    newValue;
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
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList()),
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
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      title: Container(
                                                        margin:
                                                            EdgeInsets.all(12),
                                                        height: maxLines * 24.0,
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            instructionNote =
                                                                value;
                                                          },
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          maxLines: maxLines,
                                                          decoration:
                                                              InputDecoration(
                                                            fillColor:
                                                                Colors.white54,
                                                            filled: true,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  BorderSide(),
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
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      title: Container(
                                                        margin:
                                                            EdgeInsets.all(12),
                                                        height: maxLines * 24.0,
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            doctorNotes = value;
                                                          },
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          maxLines: maxLines,
                                                          decoration:
                                                              InputDecoration(
                                                            fillColor:
                                                                Colors.white54,
                                                            filled: true,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  BorderSide(),
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
                                );
                              });
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 20.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          textColor: kButtonTextColor,
                          color: kGreyColor,
                          child: Icon(
                            Icons.done_outline_rounded,
                            color: kLightColor,
                          ),
                          onPressed: () {},
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
      this.onChanged_2});
  final String label_1;
  final String label_2;
  final String value_1;
  final String value_2;
  Function onChanged_1;
  Function onChanged_2;
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
                    onChanged: onChanged_2,
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
        ],
      ),
    );
  }
}
