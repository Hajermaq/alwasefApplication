import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class DrugInfoCard extends StatelessWidget {
  const DrugInfoCard({
    Key key,
    @required this.drugName,
    @required this.pharmaceuticalForm,
    @required this.date,
    @required this.administrationRoute,
    @required this.storageCondition,
    @required this.price,
  }) : super(key: key);

  final String drugName;
  final String pharmaceuticalForm;

  final String date;
  final String administrationRoute;
  final String storageCondition;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: kGreyColor,
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

class DosageCard extends StatelessWidget {
  DosageCard(this.strength, this.strengthUnit, this.pharmaceuticalForm,
      this.frequency, this.note1, this.note2, this.scientificName);
  final String scientificName;
  final String strength;
  final String strengthUnit;
  final String pharmaceuticalForm;
  final String frequency;
  final String note1;
  final String note2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: kGreyColor,
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'الشكل الصيدلاني (  Dosage   )',
                  textAlign: TextAlign.center,
                  style: kBoldLabelTextStyle,
                ),
              ),
              Divider(
                color: klighterColor,
                thickness: 0.9,
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            'الاسم العلمي',
                            style: ksubBoldLabelTextStyle,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            '${scientificName.toUpperCase()}',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'الجرعة',
                            style: ksubBoldLabelTextStyle,
                          ),
                          SizedBox(
                            width: 65.0,
                          ),
                          Text(
                            '$strengthUnit',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '$strength',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'شكل الجرعة',
                            style: ksubBoldLabelTextStyle,
                          ),
                          SizedBox(
                            width: 19.0,
                          ),
                          Text(
                            '$pharmaceuticalForm',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'التكرار',
                            style: ksubBoldLabelTextStyle,
                          ),
                          SizedBox(
                            width: 65.0,
                          ),
                          Text(
                            '$frequency',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: kGreyColor,
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'معلومات اضافية',
                  textAlign: TextAlign.center,
                  style: kBoldLabelTextStyle,
                ),
              ),
              Divider(
                color: klighterColor,
                thickness: 0.9,
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      note2.isEmpty
                          ? Row(
                              children: [
                                Text(
                                  '( 1 )',
                                  style: ksubBoldLabelTextStyle,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '$note1',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '( 1 )',
                                      style: ksubBoldLabelTextStyle,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$note1',
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '( 2 )',
                                      style: ksubBoldLabelTextStyle,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$note2',
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
