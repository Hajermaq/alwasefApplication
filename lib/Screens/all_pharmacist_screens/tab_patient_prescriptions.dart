import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants.dart';
import 'check_prescriptions_inconsistencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:age/age.dart';

class PrescriptionsPh extends StatefulWidget {
  PrescriptionsPh({this.uid});
  final String uid;
  @override
  _PrescriptionsPhState createState() => _PrescriptionsPhState();
}

class _PrescriptionsPhState extends State<PrescriptionsPh> {
  String searchValue = '';
  List inconsistencyResult;
  Widget yesButton;
  Widget noButton;

  List<Widget> alertContent(List<dynamic> result) {
    List<Widget> list = [];
    for (var i = 0; i < result.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(' (!) ' + result[i][0]),
            SizedBox(height: 8),
            Text(' (!) ' + result[i][1]),
            Text('_________________________________'),
            SizedBox(height: 8),
          ],
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.build),
          backgroundColor: kBlueColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (inconsistencyResult[0] == 'can not compare less than 2') {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Icon(Icons.announcement_outlined,
                              color: Colors.white, size: 75),
                          SizedBox(height: 50),
                          Text('ليس هناك عدد كاف من الوصفات لمقارنته',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      titleTextStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      elevation: 24.0,
                      backgroundColor: kScaffoldBackGroundColor,
                    );
                  } else if (inconsistencyResult[0] == 'no inconsistencies') {
                    int compared = inconsistencyResult[1];
                    return AlertDialog(
                      title: Column(
                        children: [
                          Icon(Icons.assignment_turned_in_outlined,
                              color: Colors.green, size: 75),
                          SizedBox(height: 50),
                          Text('تم مقارنة $compared وصفات',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                              ),
                              textAlign: TextAlign.center),
                          SizedBox(height: 13),
                          Text('ولم يتم تحديد أي خطر على المريض',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      titleTextStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      elevation: 24.0,
                      backgroundColor: kScaffoldBackGroundColor,
                    );
                  } else {
                    int compared = inconsistencyResult[1];
                    return AlertDialog(
                      title: Container(
                        child: Column(
                          children: [
                            Icon(Icons.warning_amber_outlined,
                                color: Colors.red, size: 75),
                            SizedBox(height: 50),
                            Text(
                              'تم مقارنة $compared وصفات',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 13),
                            Text('وتم تحديد خطر على المريض',
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 18),
                          ],
                        ),
                      ),
                      titleTextStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      content: Column(
                        children: alertContent(inconsistencyResult[0]),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      elevation: 24.0,
                      backgroundColor: kScaffoldBackGroundColor,
                    );
                  }
                });
          },
        ),
        body: Column(
          children: [
            FilledRoundTextFields(
              hintMessage: 'ابحث عن وصفة',
              fillColor: kGreyColor,
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/Patient')
                      .doc(widget.uid)
                      .collection('/Prescriptions')
                      .where('status', isNotEqualTo: 'inconsistent')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // the prescriptions list that will be checked
                    List drugsToCheck = [];
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                              backgroundColor: kGreyColor,
                              valueColor: AlwaysStoppedAnimation(kBlueColor)));
                    }
                    if (snapshot.data.docs.length == 0) {
                      inconsistencyResult = CheckInconsistencies()
                          .checkInconsistency(drugsToCheck);
                      return Center(
                          child: Text(
                        'لا توجد وصفات طبية.',
                        style: TextStyle(color: Colors.black54, fontSize: 17),
                      ));
                    } else {
                      snapshot.data.docs.forEach((prescription) {
                        String status = prescription.data()['status'];
                        String start = prescription.data()['start-date'];
                        DateTime startDate = DateTime.tryParse(start);
                        int refill = prescription.data()['refill'];

                        var difference = Age.dateDifference(
                            fromDate: startDate,
                            toDate: DateTime.now(),
                            includeToDate: false);
                        if (startDate.isBefore(DateTime.now())) {
                          // delete if 1 month passed
                          if ((difference.months >= 1 ||
                                  difference.days >= 28) &&
                              refill == 0 &&
                              status == 'dispensed') {
                            UserManagement().PastPrescriptionsSetUp(
                              context,
                              widget.uid,
                              prescription.data()['prescriber-id'].toString(),
                              prescription.data()['pharmacist-id'].toString(),
                              'deleted',
                              prescription
                                  .data()['prescription-creation-date']
                                  .toString(),
                              prescription.data()['start-date'].toString(),
                              prescription.data()['end-date'].toString(),
                              prescription.data()['scientificName'].toString(),
                              prescription.data()['tradeName'].toString(),
                              prescription.data()['tradeNameArabic'].toString(),
                              prescription.data()['strength'].toString(),
                              prescription.data()['strength-unit'].toString(),
                              prescription
                                  .data()['pharmaceutical-form']
                                  .toString(),
                              prescription
                                  .data()['administration-route']
                                  .toString(),
                              prescription
                                  .data()['storage-conditions']
                                  .toString(),
                              prescription.data()['price'].toString(),
                              prescription.data()['refill'],
                              prescription.data()['frequency'],
                              prescription
                                  .data()['instruction-note']
                                  .toString(),
                              prescription.data()['doctor-note'].toString(),
                            );
                            FirebaseFirestore.instance
                                .collection('/Patient')
                                .doc(widget.uid)
                                .collection('/Prescriptions')
                                .doc(prescription.id)
                                .delete();
                          }
                        }
                        String scientificName =
                            prescription.data()['scientificName'];
                        drugsToCheck.add(scientificName);
                      });
                      inconsistencyResult = CheckInconsistencies()
                          .checkInconsistency(drugsToCheck);

                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            Widget statusIcon;
                            DocumentSnapshot prescription =
                                snapshot.data.docs[index];

                            String status = prescription.data()['status'];
                            String prescriberID =
                                prescription.data()['prescriber-id'];
                            int refill = prescription.data()['refill'];

                            //search by
                            String tradeName = prescription.data()['tradeName'];
                            String dose =
                                prescription.data()['dose'].toString();

                            if (status == 'pending') {
                              statusIcon = Icon(
                                Icons.hourglass_top_outlined,
                                color: kBlueColor,
                              );
                            } else if (status == 'updated') {
                              statusIcon = Icon(
                                Icons.update,
                                color: kBlueColor,
                              );
                            } else if (status == 'dispensed') {
                              statusIcon = Icon(
                                  Icons.assignment_turned_in_outlined,
                                  color: Colors.green);
                            } else if (status == 'requested refill') {
                              statusIcon = Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: Colors.deepPurple);
                            }

                            // search logic
                            if (tradeName
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                tradeName
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase()) ||
                                dose
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                dose
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase())) {
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('/Doctors')
                                      .doc(prescriberID)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LinearProgressIndicator(
                                            backgroundColor: kGreyColor,
                                            valueColor: AlwaysStoppedAnimation(
                                                kBlueColor)),
                                      ));
                                    }
                                    DocumentSnapshot doc = snapshot.data;

                                    String doctorName =
                                        doc.data()['doctor-name'];
                                    String tempDoctorSpeciality =
                                        doc.data()['doctor-speciality'];
                                    String doctorSpeciality;
                                    String experienceYears =
                                        doc.data()['experience-years'];
                                    String doctorPhoneNumber =
                                        doc.data()['phone-number'];

                                    if (tempDoctorSpeciality == 'طبيب قلب') {
                                      doctorSpeciality = 'cardiologist';
                                    } else if (tempDoctorSpeciality ==
                                        'طبيب باطنية') {
                                      doctorSpeciality =
                                          'Internal medicine physicians';
                                    } else if (tempDoctorSpeciality ==
                                        'طبيب أسرة') {
                                      doctorSpeciality = 'family physician';
                                    } else {
                                      doctorSpeciality = 'Psychologist';
                                    }

                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      color: kGreyColor,
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 0),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              // TODO: change it to different names maybe?
                                              prescription.data()['tradeName'],
                                              style: kBoldLabelTextStyle,
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                prescription.data()[
                                                    'prescription-creation-date'],
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15.0,
                                                    letterSpacing: 2.0),
                                              ),
                                            ),
                                            trailing: OutlinedButton.icon(
                                              icon: statusIcon,
                                              label: Text(
                                                "${prescription.data()['status']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: kBlueColor),
                                              ),
                                              onPressed: null,
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide(
                                                    width: 2.0,
                                                    color: kBlueColor),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32.0),
                                                ),
                                              ),
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
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'الاسم العلمي',
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 15.0,
                                                      ),
                                                      Text(
                                                        '${prescription.data()['scientificName']}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 65.0,
                                                      ),
                                                      Text(
                                                        '${prescription.data()['strength-unit']}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        '${prescription.data()['strength']}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 19.0,
                                                      ),
                                                      Text(
                                                        '${prescription.data()['pharmaceutical-form']}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 65.0,
                                                      ),
                                                      Text(
                                                        '${prescription.data()['frequency']}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        'تعليمات',
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 50.0,
                                                      ),
                                                      InkWell(
                                                        child: Text(
                                                          'انقر هنا للقراءة',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: 250,
                                                                  child: Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                    ),
                                                                    color:
                                                                        kGreyColor,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        ListTile(
                                                                          title:
                                                                              Text(
                                                                            'تعليمات عن الوصفة',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                kBoldLabelTextStyle,
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              klighterColor,
                                                                          thickness:
                                                                              0.9,
                                                                          endIndent:
                                                                              20,
                                                                          indent:
                                                                              20,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(15.0),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                prescription.data()['note_2'] == ''
                                                                                    ? Padding(
                                                                                        padding: const EdgeInsets.only(right: 80.0),
                                                                                        child: Column(
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
                                                                                                    '${prescription.data()['instruction-note']}',
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
                                                                                                    '${prescription.data()['note_1']}',
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
                                                                                                  '${prescription.data()['instruction-note']}',
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
                                                                                                  '${prescription.data()['note_1']}',
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
                                                                                                '( 3 )',
                                                                                                style: ksubBoldLabelTextStyle,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 15.0,
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Text(
                                                                                                  '${prescription.data()['note_2']}',
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
                                                                );
                                                              });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'عدد مرات إعادة العبئة',
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 15.0,
                                                      ),
                                                      Text(
                                                        '${prescription.data()['refill']}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'الواصف',
                                                            style:
                                                                ksubBoldLabelTextStyle,
                                                          ),
                                                          SizedBox(
                                                            width: 15.0,
                                                          ),
                                                          Text(
                                                            'د.  $doctorName',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: IconButton(
                                                          icon: Icon(Icons
                                                              .info_outline),
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Container(
                                                                    height: 200,
                                                                    child: Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      color:
                                                                          kGreyColor,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          ListTile(
                                                                            title:
                                                                                Text(
                                                                              'معلومات عن الطبيب',
                                                                              textAlign: TextAlign.center,
                                                                              style: kBoldLabelTextStyle,
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                klighterColor,
                                                                            thickness:
                                                                                0.9,
                                                                            endIndent:
                                                                                20,
                                                                            indent:
                                                                                20,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(15.0),
                                                                            child:
                                                                                Container(
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        'اسم الطبيب:',
                                                                                        style: ksubBoldLabelTextStyle,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 47.0,
                                                                                      ),
                                                                                      Text(
                                                                                        'د.  $doctorName',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black45,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        'عدد سنين الخبرة:',
                                                                                        style: ksubBoldLabelTextStyle,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 15.0,
                                                                                      ),
                                                                                      Text(
                                                                                        '$experienceYears',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black45,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        'مجال الإختصاص:',
                                                                                        style: ksubBoldLabelTextStyle,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 15.0,
                                                                                      ),
                                                                                      Text(
                                                                                        '$doctorSpeciality',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black45,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        'رقم الهاتف:',
                                                                                        style: ksubBoldLabelTextStyle,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 54.0,
                                                                                      ),
                                                                                      Text(
                                                                                        '$doctorPhoneNumber',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black45,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight.bold,
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
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'ملاحظات الطبيب للصيدلي',
                                                        style:
                                                            ksubBoldLabelTextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 20.0,
                                                      ),
                                                      InkWell(
                                                        child: Text(
                                                          'انقر هنا للقراءة',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: 250,
                                                                  child: Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                    ),
                                                                    color:
                                                                        kGreyColor,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        ListTile(
                                                                          title:
                                                                              Text(
                                                                            'ملاحظات من الطبيب للصيدلي',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                kBoldLabelTextStyle,
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              klighterColor,
                                                                          thickness:
                                                                              0.9,
                                                                          endIndent:
                                                                              20,
                                                                          indent:
                                                                              20,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(15.0),
                                                                          child:
                                                                              Text(
                                                                            '${prescription.data()['doctor-note']}',
                                                                            style:
                                                                                ksubBoldLabelTextStyle,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          // alert doctor
                                                          RaisedButton(
                                                            color:
                                                                klighterColor,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    color:
                                                                        kGreyColor,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Text(
                                                                "تنبيه الطبيب"),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    String
                                                                        pharmacistNotes;
                                                                    final GlobalKey<
                                                                            FormState>
                                                                        _formKey =
                                                                        new GlobalKey<
                                                                            FormState>();
                                                                    yesButton =
                                                                        FlatButton(
                                                                            child:
                                                                                Text('إرسال'),
                                                                            onPressed: () async {
                                                                              if (_formKey.currentState.validate()) {
                                                                                _formKey.currentState.save();
                                                                                await FirebaseFirestore.instance.collection('/Patient').doc(widget.uid).collection('/Prescriptions').doc(prescription.id).update({
                                                                                  'pharmacist-notes': pharmacistNotes,
                                                                                  'status': 'inconsistent',
                                                                                  'pharmacist-id': FirebaseAuth.instance.currentUser.uid,
                                                                                });
                                                                              }
                                                                              Navigator.pop(context);
                                                                            });
                                                                    noButton =
                                                                        FlatButton(
                                                                      child: Text(
                                                                          'إلغاء'),
                                                                      onPressed:
                                                                          () {
                                                                        _formKey
                                                                            .currentState
                                                                            .reset();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    );
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'هل أنت متأكد من إرسال تنبيه للطبيب لتعديلها؟',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Almarai',
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center),
                                                                      titleTextStyle: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              kBlueColor),
                                                                      content: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Form(
                                                                              key: _formKey,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: TextFormField(
                                                                                  maxLines: 5,
                                                                                  style: TextStyle(color: Colors.black54),
                                                                                  decoration: InputDecoration(
                                                                                    labelText: 'ملاحظات :',
                                                                                    hintText: 'اكتب سبب عدم مناسبة هذه الوصفة ',
                                                                                  ),
                                                                                  onSaved: (value) {
                                                                                    pharmacistNotes = value;
                                                                                  },
                                                                                  validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 30),
                                                                            Text('عند اختيارك (إرسال) لن يكون بمقدورك معاينة الوصفة إلى أن يقوم الطبيب بتعديلها',
                                                                                style: TextStyle(
                                                                                  color: kBlueColor,
                                                                                  fontFamily: 'Almarai',
                                                                                ),
                                                                                textAlign: TextAlign.center),
                                                                          ]),
                                                                      actions: [
                                                                        yesButton,
                                                                        noButton
                                                                      ],
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(25)),
                                                                      ),
                                                                      elevation:
                                                                          24.0,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                    );
                                                                  });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),

                                                          // dispense prescription
                                                          RaisedButton(
                                                              color:
                                                                  klighterColor,
                                                              shape: RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color:
                                                                          kGreyColor,
                                                                      width: 2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Text(
                                                                  "تأكيد الوصفة"),
                                                              onPressed: () {
                                                                if (status ==
                                                                    'requested refill') {
                                                                  // if a patient send a refill request
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        int newRefill =
                                                                            refill -
                                                                                1;
                                                                        yesButton = FlatButton(
                                                                            child: Text('نعم'),
                                                                            onPressed: () async {
                                                                              await FirebaseFirestore.instance.collection('/Patient').doc(widget.uid).collection('/Prescriptions').doc(prescription.id).update({
                                                                                'refill': newRefill,
                                                                                'status': 'dispensed',
                                                                                'pharmacist-id': FirebaseAuth.instance.currentUser.uid,
                                                                              });
                                                                              Navigator.pop(context);
                                                                            });
                                                                        noButton =
                                                                            FlatButton(
                                                                          child:
                                                                              Text('لا'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        );
                                                                        return AlertDialog(
                                                                          title: Text(
                                                                              'هل تريد تأكيد الوصفة؟',
                                                                              style: TextStyle(fontFamily: 'Almarai', color: kBlueColor),
                                                                              textAlign: TextAlign.center),
                                                                          titleTextStyle: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: kBlueColor),
                                                                          content: Text(
                                                                              'عند تأكيدك للوصفة سينقص عدد مرات إعادة التعبئة المسموح بها لهذ هالوصفة',
                                                                              style: TextStyle(
                                                                                color: kBlueColor,
                                                                                fontFamily: 'Almarai',
                                                                              ),
                                                                              textAlign: TextAlign.center),
                                                                          actions: [
                                                                            yesButton,
                                                                            noButton
                                                                          ],
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(25)),
                                                                          ),
                                                                          elevation:
                                                                              24.0,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                        );
                                                                      });
                                                                } else if (status ==
                                                                    'dispensed') {
                                                                  // if its already dispensed
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title: Text(
                                                                              ' تم تأكيد الوصفة سابقا ',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Almarai',
                                                                              ),
                                                                              textAlign: TextAlign.center),
                                                                          titleTextStyle: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: kBlueColor),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(25)),
                                                                          ),
                                                                          elevation:
                                                                              24.0,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                        );
                                                                      });
                                                                } else {
                                                                  // if pending or updated
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        yesButton = FlatButton(
                                                                            child: Text('نعم'),
                                                                            onPressed: () async {
                                                                              await FirebaseFirestore.instance.collection('/Patient').doc(widget.uid).collection('/Prescriptions').doc(prescription.id).update({
                                                                                'status': 'dispensed',
                                                                                'pharmacist-id': FirebaseAuth.instance.currentUser.uid,
                                                                              });
                                                                              Navigator.pop(context);
                                                                            });
                                                                        noButton =
                                                                            FlatButton(
                                                                          child:
                                                                              Text('لا'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        );
                                                                        return AlertDialog(
                                                                          title: Text(
                                                                              'هل تريد تأكيد الوصفة؟',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Almarai',
                                                                              ),
                                                                              textAlign: TextAlign.center),
                                                                          titleTextStyle: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: kBlueColor),
                                                                          actions: [
                                                                            yesButton,
                                                                            noButton
                                                                          ],
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(25)),
                                                                          ),
                                                                          elevation:
                                                                              24.0,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                        );
                                                                      });
                                                                }
                                                              }),
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          // reject request refill
                                                          status ==
                                                                  'requested refill'
                                                              ? RaisedButton(
                                                                  color:
                                                                      klighterColor,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color:
                                                                              kGreyColor,
                                                                          width:
                                                                              2),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Text(
                                                                      "رفض الطلب"),
                                                                  onPressed:
                                                                      () async {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          yesButton = FlatButton(
                                                                              child: Text('نعم'),
                                                                              onPressed: () async {
                                                                                UserManagement().PastPrescriptionsSetUp(
                                                                                  context,
                                                                                  widget.uid,
                                                                                  prescription.data()['prescriber-id'].toString(),
                                                                                  prescription.data()['pharmacist-id'].toString(),
                                                                                  'refill request rejected',
                                                                                  prescription.data()['prescription-creation-date'].toString(),
                                                                                  prescription.data()['start-date'].toString(),
                                                                                  prescription.data()['end-date'].toString(),
                                                                                  prescription.data()['scientificName'].toString(),
                                                                                  prescription.data()['tradeName'].toString(),
                                                                                  prescription.data()['tradeNameArabic'].toString(),
                                                                                  prescription.data()['strength'].toString(),
                                                                                  prescription.data()['strength-unit'].toString(),
                                                                                  prescription.data()['pharmaceutical-form'].toString(),
                                                                                  prescription.data()['administration-route'].toString(),
                                                                                  prescription.data()['storage-conditions'].toString(),
                                                                                  prescription.data()['price'].toString(),
                                                                                  prescription.data()['refill'],
                                                                                  prescription.data()['frequency'],
                                                                                  prescription.data()['instruction-note'].toString(),
                                                                                  prescription.data()['doctor-note'].toString(),
                                                                                );
                                                                                FirebaseFirestore.instance.collection('/Patient').doc(widget.uid).collection('/Prescriptions').doc(prescription.id).delete();
                                                                                Navigator.pop(context);
                                                                              });
                                                                          noButton =
                                                                              FlatButton(
                                                                            child:
                                                                                Text('لا'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          );
                                                                          return AlertDialog(
                                                                            title: Text('هل تريد رفض طلب التعبئة؟',
                                                                                style: TextStyle(fontFamily: 'Almarai', color: kBlueColor),
                                                                                textAlign: TextAlign.center),
                                                                            titleTextStyle: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: kBlueColor),
                                                                            content: Text('عند اختيارك (نعم) ستحذف الوصفة',
                                                                                style: TextStyle(
                                                                                  color: kBlueColor,
                                                                                  fontFamily: 'Almarai',
                                                                                ),
                                                                                textAlign: TextAlign.center),
                                                                            actions: [
                                                                              yesButton,
                                                                              noButton
                                                                            ],
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                            ),
                                                                            elevation:
                                                                                24.0,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                          );
                                                                        });
                                                                  })
                                                              : SizedBox(),
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
                                    );
                                  });
                            }
                            return SizedBox();
                          });
                    }
                  }),
            ),
          ],
        ));
  }
}
