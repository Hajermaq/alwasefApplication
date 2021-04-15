import 'package:alwasef_app/Screens/all_doctor_screens/PDF_screen.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:age/age.dart';


class PrescriptionsCalendar2 extends StatefulWidget {
  final String uid;
  PrescriptionsCalendar2({this.uid});
  @override
  _PrescriptionsCalendar2State createState() => _PrescriptionsCalendar2State();
}

class _PrescriptionsCalendar2State extends State<PrescriptionsCalendar2> {

  CalendarController _calendarController;
  final dateFormat = DateFormat('yyyy-MM-dd');
  List<dynamic> selectedDayEvents = [];
  //pdf variables
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
  //prescription prescriber info
  String doctorName = '';
  String doctorSpeciality = '';
  String experienceYears = '';
  String doctorPhoneNumber = '';

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

  getDoctorInfo(String doctorID) async {
    await FirebaseFirestore.instance
        .collection('/Doctors')
        .doc(doctorID)
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

  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
    getPatientInfo();
    getHospitalInfo();
  }
  @override
  void dispose(){
    _calendarController.dispose();
    super.dispose();
  }

  Widget theCalendar(Map<DateTime, List<dynamic>> events){
    return TableCalendar(
      locale: 'ar',
      events: events,
      //events: ,//{DateTime.now(): ['Asprin','vitamic C']},
      startingDayOfWeek: StartingDayOfWeek.sunday,
      weekendDays: [DateTime.friday, DateTime.saturday,],
      calendarController: _calendarController,
      calendarStyle: CalendarStyle(
        canEventMarkersOverflow: true, ///???
        todayColor: Colors.redAccent,
        selectedColor:  kBlueColor,
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.black),
        eventDayStyle: TextStyle(color: Colors.black),
        //markersColor: Colors.green,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonShowsNext: false,
        titleTextStyle: TextStyle(
            fontSize: 20.0,
            color: Colors.black
        ),
        formatButtonDecoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onDaySelected: (day, events, li) {
        print(events);
        setState(() {
          selectedDayEvents = events;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.grey,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(6.0),
                bottomLeft: Radius.circular(6.0),
              ),
            ),
            title: Text('تابع تقدمك',
              style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
            ),
          ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/Patient')
                        .doc(widget.uid)
                        .collection('/Prescriptions')
                        .where('status', isEqualTo: 'dispensed')
                        .snapshots(),
                    builder: (context, snapshot) {
                      Map<DateTime, List<dynamic>> allEventsMap = {};
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } if (snapshot.data.docs.length == 0){
                        return theCalendar(allEventsMap);
                      } else {
                        snapshot.data.docs.forEach((doc){
                          List <dynamic> prescriptionAllInfo = [];
                          //map keys
                          String start = doc.data()['start-date'];
                          var startDate = DateTime.tryParse(start);
                          //map values as list
                          String prescriberID = doc.data()['prescriber-id'];
                          String prescriptionID = doc.id;
                          String creationDate = doc.data()['prescription-creation-date'];
                          String scientificName = doc.data()['scientificName'];
                          String strength = doc.data()['strength'];
                          String strengthUnit = doc.data()['strength-unit'];
                          String pharmaceuticalForm = doc.data()['pharmaceutical-form'];
                          String frequency = doc.data()['frequency'];
                          int refill = doc.data()['refill'];
                          String notes = doc.data()['instruction-note'];

                          //add to list
                          prescriptionAllInfo.add(prescriberID); //0
                          prescriptionAllInfo.add(prescriptionID); //1
                          prescriptionAllInfo.add(creationDate); //2
                          prescriptionAllInfo.add(scientificName); //3
                          prescriptionAllInfo.add(strength); //4
                          prescriptionAllInfo.add(strengthUnit); //5
                          prescriptionAllInfo.add(pharmaceuticalForm); //6
                          prescriptionAllInfo.add(frequency); //7
                          prescriptionAllInfo.add(refill); //8
                          prescriptionAllInfo.add(notes); //9

                          if (allEventsMap.containsKey(startDate)){
                            allEventsMap[startDate].add(prescriptionAllInfo);
                          } else {
                            allEventsMap.addAll({
                              startDate: [prescriptionAllInfo]   });
                          }
                        });

                        return theCalendar(allEventsMap);
                      }
                    }
                ),
                Divider(
                  height: 20,
                  thickness: 3,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    children: [
                      Text('وصفاتك التي تبدأ اليوم: ',
                        textAlign: TextAlign.right,
                        style: TextStyle (color: Colors.black45, fontSize: 22.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ...selectedDayEvents.map((event) {
                  getDoctorInfo(event[0]);
                  String prescriptionID = event[1];
                  String creationDate = event[2];
                  String scientificName = event[3];
                  String strength = event[4];
                  String strengthUnit = event[5];
                  String pharmaceuticalForm = event[6];
                  String frequency = event[7];
                  int refill = event[8];
                  String notes = event[9];
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: kGreyColor,
                        child: Column(
                          children: [
                            ListTile(
                                leading: Icon(Icons.animation),
                                title: Text(event[3], style: TextStyle(color: Colors.black)),
                                subtitle: Text(event[7], style: TextStyle(color: Colors.black)),
                                trailing: GestureDetector(
                                    child: Icon(
                                      Icons.announcement_outlined,
                                      color: Colors.black54,
                                    ),
                                    onTap: () {
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
                                                            prescriptionID,
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
                                                          date: creationDate,
                                                          patientName:
                                                            patientName,
                                                          gender:
                                                            gender,
                                                          age:
                                                            age,
                                                          prescription:
                                                          '$scientificName -$strength $strengthUnit -\n $pharmaceuticalForm - $frequency',
                                                          refill: refill.toString(),
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
                                                          prescriptionID,
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
                                                          date: creationDate,
                                                          patientName:
                                                          patientName,
                                                          gender:
                                                          gender,
                                                          age:
                                                          age,
                                                          prescription:
                                                          '$scientificName -$strength $strengthUnit -\n $pharmaceuticalForm - $frequency',
                                                          refill: '$refill',
                                                        );
                                                        setState(
                                                                () {
                                                              savePdfFile(
                                                                  'p-$prescriptionID.pdf',
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
                                    }
                                )
                            ),
                            Divider(
                              color: klighterColor,
                              thickness: 0.9,
                              endIndent: 20,
                              indent: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 20, 15),
                              child: Row(
                                children: [
                                  Text('تعليمات: ',
                                      textAlign: TextAlign.right,
                                      style: ksubBoldLabelTextStyle
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text('$notes',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold,)
                                  ),
                                ],
                              ),
                            ),
                            //SizedBox(height: 8),
                          ],
                        ),
                      )
                  );
                }),
              ]
          )
        )
      ),
    );
  }
}
