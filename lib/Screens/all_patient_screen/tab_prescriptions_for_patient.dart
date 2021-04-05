
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String name = ' ';

  getName() async {
    await FirebaseFirestore.instance
        .collection('/Patient')
        .doc(widget.uid)
        .get()
        .then((doc) {
      name = doc.data()['patient-name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getName();
    });
    return Scaffold(
        backgroundColor: klighterColor,
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
                      .snapshots(), //TODO: where status equals dispensed (after creating pharmacicst)
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } if (snapshot.data.docs.length == 0) {
                      return Center(child: Text('ليس لديك أي وصفات حتى الان', style: TextStyle(color: Colors.black)));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot prescription =
                            snapshot.data.docs[index];
                            String status = prescription.data()['status'];
                            String prescriberID = prescription.data()[
                            'prescriber-id'];
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
                                              mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                              children: [
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
                                                prescription.data()['status'] == 'pending' //TODO: if status is dispensed show this button
                                                    ? GestureDetector(
                                                  child: Icon(
                                                    Icons.post_add,
                                                    color: Colors.black54,
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            fullscreenDialog: true,
                                                            builder: (context) =>
                                                                CreateReportPage(
                                                                  uid: widget.uid,
                                                                  name: name,
                                                                  prescriptionID: prescription.id,
                                                                  prescriptionPrescriberID: prescriberID,
                                                                )));
                                                  },
                                                )
                                                    : SizedBox(),
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
                  }),
            )
          ]
        ),
    );
  }
}