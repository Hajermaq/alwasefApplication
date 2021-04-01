import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import 'PDF_screen.dart';
import 'add_prescriptions.dart';
import 'dart:io';
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
  final pdf = pw.Document();
  bool loading = false;
  writeToPdf() async {
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('hey'),
                ),
                pw.Paragraph(
                  text: 'heeeeeeeeeeeeeee',
                ),
                pw.Paragraph(
                  text: 'heeeeeeeeeeeeeee',
                ),
                pw.Paragraph(
                  text: 'heeeeeeeeeeeeeee',
                ),
                pw.Paragraph(
                  text: 'heeeeeeeeeeeeeee',
                ),
              ],
            );
          }),
    );
  }

  // @override
  // void initState() {
  //   writeToPdf();
  // }

  Future<bool> savePdfFile(String filename) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _reguestPremission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          print(directory.path);
          String newPath = "";
          // /storage/emulated/0/Android/data/hajermaq.alwasef_app/files
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
          // newPath = " /storage/emulated/0/Android/RPSApp";
          directory = Directory(newPath);
          print(directory.path);
          File file = File(directory.path + "/$filename");
          file.writeAsBytes(await pdf.save());

          // if (await file.exists()) {
          //
          // } else {}
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
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

  downloadPdf() async {
    setState(() {
      loading = true;
    });
    bool downloaded = await savePdfFile('hehe.pdf');
    if (downloaded) {
      print('File Downloaded');
    } else {
      print('Problem Downloading File');
    }
    setState(() {
      loading = false;
    });
  }

  // Future savePdfold() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   String documentPath = documentDirectory.path;
  //   print(documentPath);
  //   File file = File('$documentPath/example.pdf');
  //   file.writeAsBytesSync(await pdf.save());
  // }

  String searchValue = '';
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
          child: Icon(Icons.note_add_outlined),
          backgroundColor: kBlueColor,
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
            // showModalBottomSheet(
            //   isScrollControlled: true,
            //   context: context,
            //   builder: (context) => AddPrescriptions(),
            // );
          },
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
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot prescription =
                                snapshot.data.docs[index];
                            String status = prescription.data()['status'];
                            //search by
                            String tradeName = prescription.data()['tradeName'];
                            String dose =
                                prescription.data()['dose'].toString();
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
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: buildBottomSheet);
                                },
                                child: Card(
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
                                          icon: status == 'pending'
                                              ? Icon(
                                                  Icons.hourglass_top_outlined,
                                                  color: kBlueColor,
                                                )
                                              : Icon(
                                                  Icons.update,
                                                  color: kBlueColor,
                                                ),
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
                                                    'الجرعة',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${prescription.data()['dose']} ${prescription.data()['dose-unit']}',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    ' التكرار',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${'${prescription.data()['frequency']}'}',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'التعليمات',
                                                    style:
                                                        ksubBoldLabelTextStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '${prescription.data()['instruction-note']}',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
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
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    kGreyColor,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text("Edit"),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () async {
                                                          String status =
                                                              'deleted';
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
                                                            prescription.data()[
                                                                'refill'],
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
                                                              .doc(prescription
                                                                  .id)
                                                              .delete();
                                                          PastPrescriptions(
                                                            uid: widget.uid,
                                                          );
                                                        },
                                                        color: klighterColor,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    kGreyColor,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text("Delete"),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () async {
                                                          writeToPdf();
                                                          await savePdfFile(
                                                              'example.pdf');

                                                          // Directory
                                                          //     documentDirectory =
                                                          //     await getApplicationDocumentsDirectory();
                                                          // String documentPath =
                                                          //     documentDirectory
                                                          //         .path;
                                                          // String fullPath =
                                                          //     "$documentPath/example.pdf";
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //     builder: (context) =>
                                                          //         PdfPreviewScreen(
                                                          //       path: fullPath,
                                                          //     ),
                                                          //   ),
                                                          // );
                                                        },
                                                        color: klighterColor,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    kGreyColor,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text("View"),
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
