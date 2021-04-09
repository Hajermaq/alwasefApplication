import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import 'PDF_screen.dart';
import 'add_prescriptions.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Prescriptions extends StatefulWidget {
  Prescriptions({this.uid});
  final String uid;
  @override
  _PrescriptionsState createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  //Variables
  pw.Document pdf;
  String newPath = "";
  String filename = 'hey';
  String searchValue = '';

  String patientName = '';
  String doctorName = '';
  String doctorSpeciality = '';
  String experienceYears = '';
  String doctorPhoneNumber = '';
  String hospitalName = '';
  String hospitalPhoneNumber = '';
  String age = '';
  String gender = '';
  String allergies = '';

  //Functions

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
        age = medicalHistory.data()['age'].toString();
        String g = medicalHistory.data()['gender'];
        if (g.contains('أنثى')) {
          gender = 'Female';
        } else {
          gender = 'Male';
        }
        List allergiesList = medicalHistory.data()['allergies'];

        for (String i in allergiesList) {
          allergies += i;
          allergies += ' ';
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

  getDoctorInfo() async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      doctorName = doc.data()['doctor-name'];
      experienceYears = doc.data()['experience-years'];
      doctorPhoneNumber = doc.data()['phone-number'];
      if (doc.data()['speciality'] == 'طبيب قلب') {
        doctorSpeciality = 'cardiologist';
      } else if (doc.data()['speciality'] == 'طبيب باطنية') {
        doctorSpeciality = 'Internal medicine physicians';
      } else if (doc.data()['speciality'] == 'طبيب أسرة') {
        doctorSpeciality = 'family physician';
      } else {
        doctorSpeciality = 'Psychologist';
      }
      print(doctorName);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getPatientInfo();
    getHospitalInfo();
    getDoctorInfo();
  }

  //Function related to pdf generation
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
    String allargies,
    //patient data
    String prescription,
    String refill,
    // footer
    String doctorSignature,
  }) async {
    var data = await rootBundle.load("assets/fonts/Almarai-Regular.ttf");
    var myFont = pw.Font.ttf(data);
    var myStyle = TextStyle(fontFamily: myFont.toString());

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
                              'Prescrioption  Form',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                letterSpacing: 2.0,
                                font: myFont,
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
                            font: myFont,
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
                              font: myFont,
                              fontSize: 20.0,
                            ),
                          ),
                          pw.Text(
                            'Prescription no:$prescriptionNo',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              font: myFont,
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
                              font: myFont,
                              fontSize: 20.0,
                            ),
                          ),
                          pw.Text(
                            'date: $date',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              font: myFont,
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
                        pw.Text(
                          'Patient Name: $patientName ',
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 18.0,
                          ),
                        ),
                        pw.Text(
                          'Age : $age',
                          style: pw.TextStyle(
                            font: myFont,
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
                            font: myFont,
                            fontSize: 18.0,
                          ),
                        ),
                        pw.Text(
                          '',
                          style: pw.TextStyle(
                            font: myFont,
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
                          'Patient Allergies: $allargies',
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 18.0,
                          ),
                        ),
                        pw.Text(
                          '',
                          style: pw.TextStyle(
                            font: myFont,
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
                          font: myFont,
                          fontSize: 100.0,
                        ),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Paragraph(
                        text: prescription,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Paragraph(
                        text: '    Refill: $refill',
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 90),
                    pw.Divider(),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Paragraph(
                        text: "doctor's signature: Dr.$doctorSignature",
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Future<String> viewPdf(pw.Document pdf) async {
    //using this path so thet the path is not visible by the user
    Directory directory = await getApplicationDocumentsDirectory();
    if (await directory.exists()) {
      print('im inside function ${directory.path}');
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
          // /storage/sdcard0/0/Android/data/hajermaq.alwasef_app/files
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

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: klighterColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            ListTile(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPrescriptions(
                  uid: widget.uid,
                ),
              ),
            );
          },
          child: Icon(Icons.note_add_outlined),
          backgroundColor: kBlueColor,
        ),
        body: Column(
          children: [
            FilledRoundTextFields(
              hintMessage: 'ابحث عن الوصفة',
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
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text(
                          'لا يوجد وصفات طبية لهذا المريض.',
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            Widget statusIcon;
                            DocumentSnapshot prescription =
                                snapshot.data.docs[index];
                            String status = prescription.data()['status'];
                            //search by
                            String tradeName = prescription.data()['tradeName'];
                            String dose =
                                prescription.data()['dose'].toString();

                            if(status == 'pending'){
                              statusIcon = Icon(Icons.hourglass_top_outlined, color: kBlueColor,);
                            } else if (status == 'updated') {
                              statusIcon = Icon(Icons.update, color: kBlueColor,);
                            } else if (status == 'inconsistent') {
                            statusIcon = Icon(Icons.warning_amber_outlined, color: Colors.red);
                            } else if (status == 'dispensed') {
                            statusIcon = Icon(Icons.assignment_turned_in_outlined, color: Colors.green);
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
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: kGreyColor,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                                    endIndent:
                                                                        20,
                                                                    indent: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
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
                                            // Column(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceEvenly,
                                            //   children: [
                                            //     prescription.data()['note_2'] ==
                                            //             ''
                                            //         ? Padding(
                                            //             padding:
                                            //                 const EdgeInsets
                                            //                         .only(
                                            //                     right: 80.0),
                                            //             child: Column(
                                            //               children: [
                                            //                 Row(
                                            //                   children: [
                                            //                     Text(
                                            //                       '( 1 )',
                                            //                       style:
                                            //                           ksubBoldLabelTextStyle,
                                            //                     ),
                                            //                     SizedBox(
                                            //                       width: 15.0,
                                            //                     ),
                                            //                     Expanded(
                                            //                       child: Text(
                                            //                         '${prescription.data()['instruction-note']}',
                                            //                         style:
                                            //                             TextStyle(
                                            //                           color: Colors
                                            //                               .black45,
                                            //                           fontSize:
                                            //                               15.0,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .bold,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //                 SizedBox(
                                            //                   height: 10,
                                            //                 ),
                                            //                 Row(
                                            //                   children: [
                                            //                     Text(
                                            //                       '( 2 )',
                                            //                       style:
                                            //                           ksubBoldLabelTextStyle,
                                            //                     ),
                                            //                     SizedBox(
                                            //                       width: 15.0,
                                            //                     ),
                                            //                     Expanded(
                                            //                       child: Text(
                                            //                         '${prescription.data()['note_1']}',
                                            //                         style:
                                            //                             TextStyle(
                                            //                           color: Colors
                                            //                               .black45,
                                            //                           fontSize:
                                            //                               15.0,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .bold,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           )
                                            //         : Column(
                                            //             children: [
                                            //               Row(
                                            //                 children: [
                                            //                   Text(
                                            //                     '( 1 )',
                                            //                     style:
                                            //                         ksubBoldLabelTextStyle,
                                            //                   ),
                                            //                   SizedBox(
                                            //                     width: 15.0,
                                            //                   ),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       '${prescription.data()['instruction-note']}',
                                            //                       style:
                                            //                           TextStyle(
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         fontSize:
                                            //                             15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               SizedBox(
                                            //                 height: 10,
                                            //               ),
                                            //               Row(
                                            //                 children: [
                                            //                   Text(
                                            //                     '( 2 )',
                                            //                     style:
                                            //                         ksubBoldLabelTextStyle,
                                            //                   ),
                                            //                   SizedBox(
                                            //                     width: 15.0,
                                            //                   ),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       '${prescription.data()['note_1']}',
                                            //                       style:
                                            //                           TextStyle(
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         fontSize:
                                            //                             15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               SizedBox(
                                            //                 height: 10,
                                            //               ),
                                            //               Row(
                                            //                 children: [
                                            //                   Text(
                                            //                     '( 3 )',
                                            //                     style:
                                            //                         ksubBoldLabelTextStyle,
                                            //                   ),
                                            //                   SizedBox(
                                            //                     width: 15.0,
                                            //                   ),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       '${prescription.data()['note_2']}',
                                            //                       style:
                                            //                           TextStyle(
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         fontSize:
                                            //                             15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //             ],
                                            //           ),
                                            //   ],
                                            // ),
                                            Divider(
                                              color: klighterColor,
                                              thickness: 0.9,
                                              endIndent: 20,
                                              indent: 20,
                                            ),
                                            SizedBox(
                                              height: 10,
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
                                                        color: Colors.black45,
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
                                                          builder: (context) {
                                                            return Container(
                                                              height: 200,
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                ),
                                                                color:
                                                                    kGreyColor,
                                                                child: Column(
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
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          15.0),
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
                                            ),
                                            Divider(
                                              color: klighterColor,
                                              thickness: 0.9,
                                              endIndent: 20,
                                              indent: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    //Update
                                                    RaisedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UpdatePrescription(
                                                              documentID:
                                                                  prescription
                                                                      .id,
                                                              uid: widget.uid,
                                                            ),
                                                          ),
                                                        );
                                                      },
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
                                                      child: Text("تعديل"),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    //Delete
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        UserManagement()
                                                            .PastPrescriptionsSetUp(
                                                          context,
                                                          widget.uid,
                                                          prescription
                                                              .data()[
                                                                  'prescriber-id']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'registerNumber']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'prescription-creation-date']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'start-date']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'end-date']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'scientificName']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'scientificNameArabic']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'tradeName']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'tradeNameArabic']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'strength']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'strength-unit']
                                                              .toString(),
                                                          prescription
                                                              .data()['size']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'size-unit']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'pharmaceutical-form']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'administration-route']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'storage-conditions']
                                                              .toString(),
                                                          prescription
                                                              .data()['price']
                                                              .toString(),
                                                          prescription
                                                              .data()['dose'],
                                                          prescription.data()[
                                                              'quantity'],
                                                          prescription
                                                              .data()['refill'],
                                                          prescription.data()[
                                                              'dosing-expire'],
                                                          prescription.data()[
                                                              'frequency'],
                                                          prescription
                                                              .data()[
                                                                  'instruction-note']
                                                              .toString(),
                                                          prescription
                                                              .data()[
                                                                  'doctor-note']
                                                              .toString(),
                                                        );
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                '/Patient')
                                                            .doc(widget.uid)
                                                            .collection(
                                                                '/Prescriptions')
                                                            .doc(
                                                                prescription.id)
                                                            .delete();
                                                        PastPrescriptions(
                                                          uid: widget.uid,
                                                        );
                                                      },
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
                                                      child: Text("حذف"),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    // View
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
                                                                      pdf = pw
                                                                          .Document();
                                                                      writeToPdf(
                                                                        pdf:
                                                                            pdf,
                                                                        doctorSpeciality:
                                                                            doctorSpeciality,
                                                                        prescriptionNo:
                                                                            '${prescription.data()['prescription-id']}',
                                                                        hospitalPhoneNumber:
                                                                            hospitalPhoneNumber,
                                                                        doctorSignature:
                                                                            doctorName,
                                                                        allargies:
                                                                            allergies,
                                                                        hospitalName:
                                                                            hospitalName,
                                                                        doctorName:
                                                                            '',
                                                                        date: prescription
                                                                            .data()['prescription-creation-date'],
                                                                        patientName:
                                                                            patientName,
                                                                        gender:
                                                                            gender,
                                                                        age:
                                                                            age,
                                                                        prescription:
                                                                            '${prescription.data()['scientificName']} -${prescription.data()['strength']}${prescription.data()['strength-unit']} -\n ${prescription.data()['pharmaceutical-form']} - ${prescription.data()['frequency']}',
                                                                        refill: prescription
                                                                            .data()['refill']
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
                                                                          builder: (context) =>
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
                                                                    onTap: () {
                                                                      //create a pdf document
                                                                      pw.Document
                                                                          pdf1 =
                                                                          new pw
                                                                              .Document();
                                                                      // write to pdf document
                                                                      writeToPdf(
                                                                        pdf:
                                                                            pdf1,
                                                                        doctorSpeciality:
                                                                            doctorSpeciality,
                                                                        prescriptionNo:
                                                                            '${prescription.data()['prescription-id']}',
                                                                        hospitalPhoneNumber:
                                                                            hospitalPhoneNumber,
                                                                        doctorSignature:
                                                                            doctorName,
                                                                        allargies:
                                                                            allergies,
                                                                        hospitalName:
                                                                            hospitalName,
                                                                        doctorName:
                                                                            '',
                                                                        date: prescription
                                                                            .data()['prescription-creation-date'],
                                                                        patientName:
                                                                            patientName,
                                                                        gender:
                                                                            gender,
                                                                        age:
                                                                            age,
                                                                        prescription:
                                                                            '${prescription.data()['scientificName']} -${prescription.data()['strength']}${prescription.data()['strength-unit']} -\n ${prescription.data()['pharmaceutical-form']} - ${prescription.data()['frequency']}',
                                                                        refill: prescription
                                                                            .data()['refill']
                                                                            .toString(),
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        savePdfFile(
                                                                            'p-${prescription.data()['prescription-id']}.pdf',
                                                                            pdf1);
                                                                      });
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
                          });
                    }
                    return SizedBox();
                  }),
            ),
          ],
        ));
  }
}
