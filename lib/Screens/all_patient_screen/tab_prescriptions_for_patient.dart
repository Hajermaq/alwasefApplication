import 'dart:io';

import 'package:age/age.dart';
import 'package:alwasef_app/Screens/services/PDF_screen.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import 'fill_report_page.dart';

class PatientPrescriptions extends StatefulWidget {
  PatientPrescriptions({this.uid});
  final String uid;

  @override
  _PatientPrescriptionsState createState() => _PatientPrescriptionsState();
}

class _PatientPrescriptionsState extends State<PatientPrescriptions> {
  String searchValue = '';
  pw.Document pdf;
  String newPath = "";
  String filename = 'hey';
  //patient info
  String patientName = '';
  String age = '';
  String gender = '';
  String allergies = '';
  String hospitalName = '';
  String hospitalPhoneNumber = '';
  Widget downloadedButton;
  Widget yesButton;
  Widget noButton;

  // get information from FireStore
  getPatientInfo() async {
    await FirebaseFirestore.instance
        .collection('/Patient')
        .doc(widget.uid)
        .collection('/Medical History')
        .get()
        .then((doc) {
      if (doc.docs.isNotEmpty) {
        var medicalHistory = doc.docs[0];
        patientName = medicalHistory.data()['full name'];
        var tempAge = Age.dateDifference(
            fromDate: DateTime.parse(medicalHistory.get('birth date')),
            toDate: DateTime.now(),
            includeToDate: false);
        age = tempAge.years.toString();
        String g = medicalHistory.data()['gender'];
        if (g.contains('أنثى')) {
          gender = 'Female';
        } else {
          gender = 'Male';
        }
        List allergiesList = medicalHistory.data()['allergies'];

        for (String i in allergiesList) {
          allergies += i;
          allergies += ' , ';
        }

        print(allergies);
        if (mounted) {
          setState(() {});
        }
      } else {
        allergies = '';
        gender = '';
        age = '';
        patientName = '';
      }
    });
  }

  getHospitalInfo() async {
    String hospitalUid = '';
    await FirebaseFirestore.instance
        .collection('/Patient')
        .doc(widget.uid)
        .get()
        .then((doc) {
      hospitalUid = doc.data()['hospital-uid'];
      print(hospitalUid);
      if (mounted) {
        setState(() {});
      }
    });

    await FirebaseFirestore.instance
        .collection('/Hospital')
        .doc(hospitalUid)
        .get()
        .then((doc) {
      hospitalName = doc.data()['hospital-name'];
      hospitalPhoneNumber = doc.data()['phone-number'];
      print(hospitalName);

      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<bool> _reguestPremission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == permission.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  writeToPdf({
    pw.Document pdf,
    // header data
    String hospitalName,
    String doctorName,
    String date,
    String doctorSpeciality,
    String hospitalPhoneNumber,
    String prescriptionNo,
    //patient data
    String patientName,
    String age,
    String gender,
    String allergies,
    //patient data
    String prescription,
    String refill,
    // footer
    String doctorSignature,
  }) async {
    var data =
        await rootBundle.load("assets/fonts/NotoNaskhArabic-Regular.ttf");
    var myFont = pw.Font.ttf(data);

    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              'Prescription  Form',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                letterSpacing: 2.0,
                                fontSize: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 40,
                      ),
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          hospitalName,
                          style: pw.TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Speciality: $doctorSpeciality',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          pw.Text(
                            'Prescription no:$prescriptionNo',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      // pw.SizedBox(
                      //   height: 15,
                      // ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Phone no:$hospitalPhoneNumber',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          pw.Text(
                            'date: $date',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  height: 30,
                ),
                pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Patient name:',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            pw.Text(
                              '$patientName',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                font: myFont,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        pw.Text(
                          'Age : $age',
                          style: pw.TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Gender : $gender',
                          style: pw.TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        pw.Text(
                          '',
                          style: pw.TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Patient Allergies:',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            pw.Text(
                              ' $allergies',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                font: myFont,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        pw.Text(
                          '',
                          style: pw.TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'Rx',
                        style: pw.TextStyle(
                          fontSize: 100.0,
                        ),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Paragraph(
                        text: prescription,
                        style: pw.TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Paragraph(
                        text: '    Refill: $refill',
                        style: pw.TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(),
                    pw.Row(
                      children: [
                        pw.Text(
                          "doctor's signature: Dr.",
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        pw.Text(
                          '$doctorSignature',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ), //     font: myFont,
                  ],
                ),
              ],
            );
          }),
    );
  }

  Future<String> viewPdf(pw.Document pdf) async {
    //using this path so that the path is not visible by the user
    Directory directory = await getApplicationDocumentsDirectory();
    if (await directory.exists()) {
      File file = File(directory.path + "/$filename");
      file.writeAsBytes(await pdf.save());
      return 'saved!';
    }
    return 'not saved!';
  }

  Future<bool> savePdfFile(String filename, pw.Document pdf) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _reguestPremission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          print(directory.path);
          List<String> folders = directory.path.split("/");
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Download";
          directory = Directory(newPath);
          print(directory.path);
          // saving & saving the file
          File file = File(directory.path + "/$filename");
          file.writeAsBytes(await pdf.save());
          newPath = '';
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  // ignore: must_call_super
  void initState() {
    getPatientInfo();
    getHospitalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: klighterColor,
      body: Column(children: [
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
                  .where('status', isEqualTo: 'dispensed')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: kGreyColor,
                          valueColor: AlwaysStoppedAnimation(kBlueColor)));
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text(
                      'لا توجد وصفات.',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot prescription = snapshot.data.docs[index];
                        // time calculations for buttons (add report/request refill)
                        String start = prescription.data()['start-date'];
                        DateTime startDate = DateTime.tryParse(start);
                        int refill = prescription.data()['refill'];

                        if (startDate.isBefore(DateTime.now())) {
                          var difference = Age.dateDifference(
                              fromDate: startDate,
                              toDate: DateTime.now(),
                              includeToDate: false);
                          // delete if 1 month passed
                          if ((difference.months >= 1 ||
                                  difference.days >= 28) && refill == 0) {
                            UserManagement().PastPrescriptionsSetUp(
                              context,
                              widget.uid,
                              prescription.data()['prescriber-id'].toString(),
                              prescription.data()['pharmacist-id'].toString(),
                              'deleted',
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
                            FirebaseFirestore.instance
                                .collection('/Patient')
                                .doc(widget.uid)
                                .collection('/Prescriptions')
                                .doc(prescription.id)
                                .delete();
                          }
                          // doctor info
                          String prescriberID = prescription.data()['prescriber-id'];
                          String pharmacistID = prescription.data()['pharmacist-id'];
                          //search by
                          String tradeName = prescription.data()['tradeName'];
                          String dose = prescription.data()['dose'].toString();

                          // search logic
                          if (tradeName.toLowerCase()
                                  .contains(searchValue.toLowerCase()) ||
                              tradeName.toUpperCase()
                                  .contains(searchValue.toUpperCase()) ||
                              dose.toLowerCase()
                                  .contains(searchValue.toLowerCase()) ||
                              dose.toUpperCase()
                                  .contains(searchValue.toUpperCase())) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: kGreyColor,
                              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      // TODO: change it to different names maybe?
                                      prescription.data()['tradeName'],
                                      style: kBoldLabelTextStyle,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(5.0),
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
                                      icon: Icon(
                                          Icons.assignment_turned_in_outlined,
                                          color: Colors.green),
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
                                            width: 2.0, color: kBlueColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
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
                                            MainAxisAlignment.spaceEvenly,
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
                                                '${prescription.data()['scientificName']}',
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
                                                '${prescription.data()['strength-unit']}',
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
                                                '${prescription.data()['strength']}',
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
                                                '${prescription.data()['pharmaceutical-form']}',
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
                                                '${prescription.data()['frequency']}',
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
                                                'تعليمات',
                                                style: ksubBoldLabelTextStyle,
                                              ),
                                              SizedBox(
                                                width: 50.0,
                                              ),
                                              InkWell(
                                                child: Text(
                                                  'انقر هنا للقراءة',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                          height: 250,
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            color: kGreyColor,
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                    'تعليمات عن الوصفة',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        kBoldLabelTextStyle,
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  color:
                                                                      klighterColor,
                                                                  thickness:
                                                                      0.9,
                                                                  endIndent: 20,
                                                                  indent: 20,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        prescription.data()['note_2'] ==
                                                                                ''
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
                                                style: ksubBoldLabelTextStyle,
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Text(
                                                '${prescription.data()['refill']}',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('/Doctors')
                                                  .doc(prescriberID)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                      child: CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors
                                                                      .transparent)));
                                                }
                                                DocumentSnapshot doc =
                                                    snapshot.data;
                                                String doctorName =
                                                    doc.data()['doctor-name'];
                                                String tempDoctorSpeciality =
                                                    doc.data()['doctor-speciality'];
                                                String doctorSpeciality;
                                                String experienceYears = doc
                                                    .data()['experience-years'];
                                                String doctorPhoneNumber =
                                                    doc.data()['phone-number'];

                                                if (tempDoctorSpeciality ==
                                                    'طبيب قلب') {
                                                  doctorSpeciality =
                                                      'cardiologist';
                                                } else if (tempDoctorSpeciality ==
                                                    'طبيب باطنية') {
                                                  doctorSpeciality =
                                                      'Internal medicine physicians';
                                                } else if (tempDoctorSpeciality ==
                                                    'طبيب أسرة') {
                                                  doctorSpeciality =
                                                      'family physician';
                                                } else {
                                                  doctorSpeciality =
                                                      'Psychologist';
                                                }

                                                return Row(
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
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: IconButton(
                                                        icon: Icon(
                                                            Icons.info_outline),
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: 200,
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
                                                                            'معلومات عن الطبيب',
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
                                                );
                                              }),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('/Pharmacist')
                                                  .doc(pharmacistID)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                      child: CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors
                                                                      .transparent)));
                                                }
                                                DocumentSnapshot doc =
                                                    snapshot.data;
                                                String pharmacistName = doc
                                                    .data()['pharmacist-name'];
                                                return Row(
                                                  children: [
                                                    Text(
                                                      'الصيدلي',
                                                      style:
                                                          ksubBoldLabelTextStyle,
                                                    ),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    Text(
                                                      'ص.  $pharmacistName',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                          Divider(
                                            color: klighterColor,
                                            thickness: 0.9,
                                            endIndent: 20,
                                            indent: 20,
                                          ),
                                          // buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  //allow creating report if 7 days of more passed
                                                  (difference.months >= 1 || difference.days >= 7)
                                                      ? RaisedButton(
                                                          color: klighterColor,
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: kGreyColor,
                                                                  width: 2),
                                                              borderRadius: BorderRadius.circular(10)),
                                                          child: Text("إنشاء تقرير"),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    fullscreenDialog: true,
                                                                    builder: (context) =>
                                                                            CreateReportPage(
                                                                              uid: widget.uid,
                                                                              prescriberID: prescriberID,
                                                                              pharmacistID: pharmacistID,
                                                                              tradeName: tradeName,
                                                                            )));
                                                          },
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),

                                                  // View and safe pdf
                                                  RaisedButton(
                                                    onPressed: () async {
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (context) =>
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            height: 115,
                                                            child: Column(
                                                              children: [
                                                                //Only view prescription without downloading, using pdf viewer
                                                                ListTile(
                                                                  onTap:
                                                                      () async {
                                                                    var doc = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Doctors')
                                                                        .doc(
                                                                            prescriberID)
                                                                        .get();

                                                                    String
                                                                        doctorName =
                                                                        doc.data()[
                                                                            'doctor-name'];
                                                                    String
                                                                        tempDoctorSpeciality =
                                                                        doc.data()[
                                                                            'doctor-speciality'];
                                                                    String
                                                                        doctorSpeciality;

                                                                    if (tempDoctorSpeciality ==
                                                                        'طبيب قلب') {
                                                                      doctorSpeciality =
                                                                          'cardiologist';
                                                                    } else if (tempDoctorSpeciality ==
                                                                        'طبيب باطنية') {
                                                                      doctorSpeciality =
                                                                          'Internal medicine physicians';
                                                                    } else if (tempDoctorSpeciality ==
                                                                        'طبيب أسرة') {
                                                                      doctorSpeciality =
                                                                          'family physician';
                                                                    } else {
                                                                      doctorSpeciality =
                                                                          'Psychologist';
                                                                    }

                                                                    pdf = pw
                                                                        .Document();
                                                                    writeToPdf(
                                                                      pdf: pdf,
                                                                      doctorSpeciality:
                                                                          doctorSpeciality,
                                                                      prescriptionNo:
                                                                          '${prescription.data()['prescription-id']}',
                                                                      hospitalPhoneNumber:
                                                                          hospitalPhoneNumber,
                                                                      doctorSignature:
                                                                          doctorName,
                                                                      allergies:
                                                                          allergies,
                                                                      hospitalName:
                                                                          hospitalName,
                                                                      doctorName:
                                                                          '',
                                                                      date: prescription
                                                                              .data()[
                                                                          'prescription-creation-date'],
                                                                      patientName:
                                                                          patientName,
                                                                      gender:
                                                                          gender,
                                                                      age: age,
                                                                      prescription:
                                                                          '${prescription.data()['scientificName']} -${prescription.data()['strength']}${prescription.data()['strength-unit']} -\n ${prescription.data()['pharmaceutical-form']} - ${prescription.data()['frequency']}',
                                                                      refill: prescription
                                                                          .data()[
                                                                              'refill']
                                                                          .toString(),
                                                                    );
                                                                    await viewPdf(
                                                                        pdf);
                                                                    Directory
                                                                        directory =
                                                                        await getApplicationDocumentsDirectory();
                                                                    String
                                                                        documentPath =
                                                                        directory
                                                                            .path;

                                                                    String
                                                                        fullPath =
                                                                        documentPath +
                                                                            "/$filename";
                                                                    print(
                                                                        ' full path name $fullPath');
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                PdfPreviewScreen(
                                                                          path:
                                                                              fullPath,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  title: Text(
                                                                    'عرض الوصفة الطبية بصيغة pdf',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kBlueColor,
                                                                      fontSize:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  trailing:
                                                                      Icon(Icons
                                                                          .keyboard_arrow_left),
                                                                ),
                                                                ListTileDivider(
                                                                  color:
                                                                      kGreyColor,
                                                                ),
                                                                // Download prescription in External storage at Files App
                                                                ListTile(
                                                                  onTap:
                                                                      () async {
                                                                    var doc = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Doctors')
                                                                        .doc(
                                                                            prescriberID)
                                                                        .get();

                                                                    String
                                                                        doctorName =
                                                                        doc.data()[
                                                                            'doctor-name'];
                                                                    String
                                                                        tempDoctorSpeciality =
                                                                        doc.data()[
                                                                            'doctor-speciality'];
                                                                    String
                                                                        doctorSpeciality;

                                                                    if (tempDoctorSpeciality ==
                                                                        'طبيب قلب') {
                                                                      doctorSpeciality =
                                                                          'cardiologist';
                                                                    } else if (tempDoctorSpeciality ==
                                                                        'طبيب باطنية') {
                                                                      doctorSpeciality =
                                                                          'Internal medicine physicians';
                                                                    } else if (tempDoctorSpeciality ==
                                                                        'طبيب أسرة') {
                                                                      doctorSpeciality =
                                                                          'family physician';
                                                                    } else {
                                                                      doctorSpeciality =
                                                                          'Psychologist';
                                                                    }
                                                                    //create a pdf document
                                                                    pw.Document
                                                                        pdf1 =
                                                                        new pw
                                                                            .Document();
                                                                    // write to pdf document
                                                                    writeToPdf(
                                                                      pdf: pdf1,
                                                                      doctorSpeciality:
                                                                          doctorSpeciality,
                                                                      prescriptionNo:
                                                                          '${prescription.data()['prescription-id']}',
                                                                      hospitalPhoneNumber:
                                                                          hospitalPhoneNumber,
                                                                      doctorSignature:
                                                                          doctorName,
                                                                      allergies:
                                                                          allergies,
                                                                      hospitalName:
                                                                          hospitalName,
                                                                      doctorName:
                                                                          '',
                                                                      date: prescription
                                                                              .data()[
                                                                          'prescription-creation-date'],
                                                                      patientName:
                                                                          patientName,
                                                                      gender:
                                                                          gender,
                                                                      age: age,
                                                                      prescription:
                                                                          '${prescription.data()['scientificName']} -${prescription.data()['strength']}${prescription.data()['strength-unit']} -\n ${prescription.data()['pharmaceutical-form']} - ${prescription.data()['frequency']}',
                                                                      refill: prescription
                                                                          .data()[
                                                                              'refill']
                                                                          .toString(),
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      savePdfFile(
                                                                              'p-${prescription.data()['prescription-id']}.pdf',
                                                                              pdf1)
                                                                          .then((value) =>
                                                                              Flushbar(
                                                                                backgroundColor: Colors.white,
                                                                                borderRadius: 4.0,
                                                                                margin: EdgeInsets.all(8.0),
                                                                                duration: Duration(seconds: 4),
                                                                                messageText: Text(
                                                                                  ' تم تحميل الوصفة بنجاح.',
                                                                                  style: TextStyle(
                                                                                    color: kBlueColor,
                                                                                    fontFamily: 'Almarai',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              )..show(context));
                                                                    });

                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        downloadedButton =
                                                                            FlatButton(
                                                                          child:
                                                                              Text('حسنا'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        );
                                                                        return AlertDialog(
                                                                          title: Text(
                                                                              'أذهب الى \n Files >> Show internal storage >> your device >> Download',
                                                                              style: TextStyle(
                                                                                color: kBlueColor,
                                                                                fontFamily: 'Almarai',
                                                                              ),
                                                                              textAlign: TextAlign.center),
                                                                          titleTextStyle: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                          actions: [
                                                                            downloadedButton,
                                                                          ],
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(25)),
                                                                          ),
                                                                          elevation:
                                                                              24.0,
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  title: Text(
                                                                    'تحميل الوصفة الطبية',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kBlueColor,
                                                                      fontSize:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  trailing:
                                                                      Icon(Icons
                                                                          .keyboard_arrow_left),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    // onPressed: () async {
                                                    //   writeToPdf();
                                                    //   await savePdfFile(
                                                    //       'example.pdf');

                                                    color: klighterColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    kGreyColor,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Text("عرض"),
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),

                                                  //allow request refill if a month passed and nom of refill is 1 or more
                                                  (difference.months >= 1 || difference.days >= 28) && refill > 0
                                                      ? RaisedButton(
                                                          color: klighterColor,
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: kGreyColor,
                                                                  width: 2),
                                                              borderRadius: BorderRadius.circular(10)),
                                                          child: Text(
                                                              "طلب إعادة تعبئة"),
                                                          onPressed: () async {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  yesButton =
                                                                      FlatButton(
                                                                          child: Text('نعم'),
                                                                          onPressed: () async {
                                                                            await FirebaseFirestore.instance.collection('/Patient')
                                                                                .doc(widget.uid)
                                                                                .collection('/Prescriptions')
                                                                                .doc(prescription.id)
                                                                                .update({
                                                                              'status': 'requested refill'
                                                                            });
                                                                            Navigator.pop(context);
                                                                          });
                                                                  noButton = FlatButton(
                                                                        child: Text('لا'),
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                    },
                                                                  );

                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'هل أنت متأكد من طلب إعادة تعبئة؟',
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
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            kBlueColor),
                                                                    content: Text(
                                                                        'عند اختيارك (نعم) لن يكون بمقدورك معاينة الوصفة إلى أن يقوم الصيدلي بقبول الطلب \n\n الطلبات المرفوضة ستظهر عند قسم الوصفات السابقة',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              kBlueColor,
                                                                          fontFamily:
                                                                              'Almarai',
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                    actions: [
                                                                      yesButton,
                                                                      noButton
                                                                    ],
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25)),
                                                                    ),
                                                                    elevation:
                                                                        24.0,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  );
                                                                });
                                                          },
                                                        )
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
                          }
                          return SizedBox();
                        } else {
                          // doctor info
                          String prescriberID =
                              prescription.data()['prescriber-id'];
                          String pharmacistID =
                              prescription.data()['pharmacist-id'];

                          //search by
                          String tradeName = prescription.data()['tradeName'];
                          String dose = prescription.data()['dose'].toString();

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
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: kGreyColor,
                              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      // TODO: change it to different names maybe?
                                      prescription.data()['tradeName'],
                                      style: kBoldLabelTextStyle,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(5.0),
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
                                      icon: Icon(
                                          Icons.assignment_turned_in_outlined,
                                          color: Colors.green),
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
                                            width: 2.0, color: kBlueColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
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
                                            MainAxisAlignment.spaceEvenly,
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
                                                '${prescription.data()['scientificName']}',
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
                                                '${prescription.data()['strength-unit']}',
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
                                                '${prescription.data()['strength']}',
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
                                                '${prescription.data()['pharmaceutical-form']}',
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
                                                '${prescription.data()['frequency']}',
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
                                                'تعليمات',
                                                style: ksubBoldLabelTextStyle,
                                              ),
                                              SizedBox(
                                                width: 50.0,
                                              ),
                                              InkWell(
                                                child: Text(
                                                  'انقر هنا للقراءة',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                          height: 250,
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            color: kGreyColor,
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                    'تعليمات عن الوصفة',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        kBoldLabelTextStyle,
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  color:
                                                                      klighterColor,
                                                                  thickness:
                                                                      0.9,
                                                                  endIndent: 20,
                                                                  indent: 20,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        prescription.data()['note_2'] ==
                                                                                ''
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
                                                style: ksubBoldLabelTextStyle,
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Text(
                                                '${prescription.data()['refill']}',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('/Doctors')
                                                  .doc(prescriberID)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                      child: CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors
                                                                      .transparent)));
                                                }
                                                DocumentSnapshot doc =
                                                    snapshot.data;
                                                String doctorName =
                                                    doc.data()['doctor-name'];
                                                String tempDoctorSpeciality =
                                                    doc.data()['doctor-speciality'];
                                                String doctorSpeciality;
                                                String experienceYears = doc
                                                    .data()['experience-years'];
                                                String doctorPhoneNumber =
                                                    doc.data()['phone-number'];

                                                if (tempDoctorSpeciality ==
                                                    'طبيب قلب') {
                                                  doctorSpeciality =
                                                      'cardiologist';
                                                } else if (tempDoctorSpeciality ==
                                                    'طبيب باطنية') {
                                                  doctorSpeciality =
                                                      'Internal medicine physicians';
                                                } else if (tempDoctorSpeciality ==
                                                    'طبيب أسرة') {
                                                  doctorSpeciality =
                                                      'family physician';
                                                } else {
                                                  doctorSpeciality =
                                                      'Psychologist';
                                                }

                                                return Row(
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
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: IconButton(
                                                        icon: Icon(
                                                            Icons.info_outline),
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: 200,
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
                                                                            'معلومات عن الطبيب',
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
                                                );
                                              }),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('/Pharmacist')
                                                  .doc(pharmacistID)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                      child: CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors
                                                                      .transparent)));
                                                }
                                                DocumentSnapshot doc =
                                                    snapshot.data;
                                                String pharmacistName = doc
                                                    .data()['pharmacist-name'];
                                                return Row(
                                                  children: [
                                                    Text(
                                                      'الصيدلي',
                                                      style:
                                                          ksubBoldLabelTextStyle,
                                                    ),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    Text(
                                                      'ص.  $pharmacistName',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                          Divider(
                                            color: klighterColor,
                                            thickness: 0.9,
                                            endIndent: 20,
                                            indent: 20,
                                          ),
                                          // buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // View and safe pdf
                                              RaisedButton(
                                                onPressed: () async {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        height: 115,
                                                        child: Column(
                                                          children: [
                                                            //Only view prescription without downloading, using pdf viewer
                                                            ListTile(
                                                              onTap: () async {
                                                                var doc = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Doctors')
                                                                    .doc(
                                                                        prescriberID)
                                                                    .get();

                                                                String
                                                                    doctorName =
                                                                    doc.data()[
                                                                        'doctor-name'];
                                                                String
                                                                    tempDoctorSpeciality =
                                                                    doc.data()[
                                                                        'doctor-speciality'];
                                                                String
                                                                    doctorSpeciality;

                                                                if (tempDoctorSpeciality ==
                                                                    'طبيب قلب') {
                                                                  doctorSpeciality =
                                                                      'cardiologist';
                                                                } else if (tempDoctorSpeciality ==
                                                                    'طبيب باطنية') {
                                                                  doctorSpeciality =
                                                                      'Internal medicine physicians';
                                                                } else if (tempDoctorSpeciality ==
                                                                    'طبيب أسرة') {
                                                                  doctorSpeciality =
                                                                      'family physician';
                                                                } else {
                                                                  doctorSpeciality =
                                                                      'Psychologist';
                                                                }

                                                                pdf = pw
                                                                    .Document();
                                                                writeToPdf(
                                                                  pdf: pdf,
                                                                  doctorSpeciality:
                                                                      doctorSpeciality,
                                                                  prescriptionNo:
                                                                      '${prescription.data()['prescription-id']}',
                                                                  hospitalPhoneNumber:
                                                                      hospitalPhoneNumber,
                                                                  doctorSignature:
                                                                      doctorName,
                                                                  allergies:
                                                                      allergies,
                                                                  hospitalName:
                                                                      hospitalName,
                                                                  doctorName:
                                                                      '',
                                                                  date: prescription
                                                                          .data()[
                                                                      'prescription-creation-date'],
                                                                  patientName:
                                                                      patientName,
                                                                  gender:
                                                                      gender,
                                                                  age: age,
                                                                  prescription:
                                                                      '${prescription.data()['scientificName']} -${prescription.data()['strength']}${prescription.data()['strength-unit']} -\n ${prescription.data()['pharmaceutical-form']} - ${prescription.data()['frequency']}',
                                                                  refill: prescription
                                                                      .data()[
                                                                          'refill']
                                                                      .toString(),
                                                                );
                                                                await viewPdf(
                                                                    pdf);
                                                                Directory
                                                                    directory =
                                                                    await getApplicationDocumentsDirectory();
                                                                String
                                                                    documentPath =
                                                                    directory
                                                                        .path;

                                                                String
                                                                    fullPath =
                                                                    documentPath +
                                                                        "/$filename";
                                                                print(
                                                                    ' full path name $fullPath');
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PdfPreviewScreen(
                                                                      path:
                                                                          fullPath,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              title: Text(
                                                                'عرض الوصفة الطبية بصيغة pdf',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kBlueColor,
                                                                  fontSize:
                                                                      20.0,
                                                                ),
                                                              ),
                                                              trailing: Icon(Icons
                                                                  .keyboard_arrow_left),
                                                            ),
                                                            ListTileDivider(
                                                              color: kGreyColor,
                                                            ),
                                                            // Download prescription in External storage at Files App
                                                            ListTile(
                                                              onTap: () async {
                                                                var doc = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Doctors')
                                                                    .doc(
                                                                        prescriberID)
                                                                    .get();

                                                                String
                                                                    doctorName =
                                                                    doc.data()[
                                                                        'doctor-name'];
                                                                String
                                                                    tempDoctorSpeciality =
                                                                    doc.data()[
                                                                        'doctor-speciality'];
                                                                String
                                                                    doctorSpeciality;

                                                                if (tempDoctorSpeciality ==
                                                                    'طبيب قلب') {
                                                                  doctorSpeciality =
                                                                      'cardiologist';
                                                                } else if (tempDoctorSpeciality ==
                                                                    'طبيب باطنية') {
                                                                  doctorSpeciality =
                                                                      'Internal medicine physicians';
                                                                } else if (tempDoctorSpeciality ==
                                                                    'طبيب أسرة') {
                                                                  doctorSpeciality =
                                                                      'family physician';
                                                                } else {
                                                                  doctorSpeciality =
                                                                      'Psychologist';
                                                                }
                                                                //create a pdf document
                                                                pw.Document
                                                                    pdf1 =
                                                                    new pw
                                                                        .Document();
                                                                // write to pdf document
                                                                writeToPdf(
                                                                  pdf: pdf1,
                                                                  doctorSpeciality:
                                                                      doctorSpeciality,
                                                                  prescriptionNo:
                                                                      '${prescription.data()['prescription-id']}',
                                                                  hospitalPhoneNumber:
                                                                      hospitalPhoneNumber,
                                                                  doctorSignature:
                                                                      doctorName,
                                                                  allergies:
                                                                      allergies,
                                                                  hospitalName:
                                                                      hospitalName,
                                                                  doctorName:
                                                                      '',
                                                                  date: prescription
                                                                          .data()[
                                                                      'prescription-creation-date'],
                                                                  patientName:
                                                                      patientName,
                                                                  gender:
                                                                      gender,
                                                                  age: age,
                                                                  prescription:
                                                                      '${prescription.data()['scientificName']} -${prescription.data()['strength']}${prescription.data()['strength-unit']} -\n ${prescription.data()['pharmaceutical-form']} - ${prescription.data()['frequency']}',
                                                                  refill: prescription
                                                                      .data()[
                                                                          'refill']
                                                                      .toString(),
                                                                );

                                                                setState(() {
                                                                  savePdfFile(
                                                                          'p-${prescription.data()['prescription-id']}.pdf',
                                                                          pdf1)
                                                                      .then((value) =>
                                                                          Flushbar(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                4.0,
                                                                            margin:
                                                                                EdgeInsets.all(8.0),
                                                                            duration:
                                                                                Duration(seconds: 4),
                                                                            messageText:
                                                                                Text(
                                                                              ' تم تحميل الوصفة بنجاح.',
                                                                              style: TextStyle(
                                                                                color: kBlueColor,
                                                                                fontFamily: 'Almarai',
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          )..show(
                                                                              context));
                                                                });

                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    downloadedButton =
                                                                        FlatButton(
                                                                      child: Text(
                                                                          'حسنا'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    );
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'أذهب الى \n Files >> Show internal storage >> your device >> Download',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                kBlueColor,
                                                                            fontFamily:
                                                                                'Almarai',
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center),
                                                                      titleTextStyle: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      actions: [
                                                                        downloadedButton,
                                                                      ],
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(25)),
                                                                      ),
                                                                      elevation:
                                                                          24.0,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              title: Text(
                                                                'تحميل الوصفة الطبية',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kBlueColor,
                                                                  fontSize:
                                                                      20.0,
                                                                ),
                                                              ),
                                                              trailing: Icon(Icons
                                                                  .keyboard_arrow_left),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                // onPressed: () async {
                                                //   writeToPdf();
                                                //   await savePdfFile(
                                                //       'example.pdf');

                                                color: klighterColor,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: kGreyColor,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text("عرض"),
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
                          }
                          return SizedBox();
                        }
                      });
                }
              }),
        )
      ]),
    );
  }
}
