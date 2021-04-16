import 'package:alwasef_app/Screens/all_doctor_screens/past_prescriptions_page.dart';
import 'package:alwasef_app/Screens/all_doctor_screens/update_prescription.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';
import 'package:flushbar/flushbar.dart';

class Prescriptions extends StatefulWidget {
  Prescriptions({this.uid});
  final String uid;
  @override
  _PrescriptionsState createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  //Variables
  String searchValue = '';

  String doctorName = '';
  String doctorSpeciality = '';
  String experienceYears = '';
  String doctorPhoneNumber = '';

  Widget noButton;
  Widget yesButton;

// get information from FireStore
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
        doctorSpeciality = 'internal physician';
      } else if (doc.data()['speciality'] == 'طبيب أسرة') {
        doctorSpeciality = 'family physician';
      } else {
        doctorSpeciality = 'psychologist';
      }
      print(doctorName);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getDoctorInfo();
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
                      //.where('status', isNotEqualTo: 'requested refill')
                      .where('prescriber-id',
                          isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.docs.length == 0) {
                      print('nooo');
                      return Center(
                        child: Text(
                          'لا يوجد وصفات طبية لهذا المريض.',
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Widget statusIcon;
                          DocumentSnapshot prescription =
                              snapshot.data.docs[index];
                          if (prescription.data()['status'] !=
                              'requested refill') {
                            String status = prescription.data()['status'];
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
                            } else if (status == 'inconsistent') {
                              statusIcon = Icon(Icons.warning_amber_outlined,
                                  color: Colors.red);
                            } else if (status == 'dispensed') {
                              statusIcon = Icon(
                                  Icons.assignment_turned_in_outlined,
                                  color: Colors.green);
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
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              yesButton =
                                                                  FlatButton(
                                                                      child: Text(
                                                                          'نعم'),
                                                                      onPressed:
                                                                          () async {
                                                                        UserManagement()
                                                                            .PastPrescriptionsSetUp(
                                                                          context,
                                                                          widget
                                                                              .uid,
                                                                          prescription
                                                                              .data()['prescriber-id']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['registerNumber']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['prescription-creation-date']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['start-date']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['end-date']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['scientificName']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['scientificNameArabic']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['tradeName']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['tradeNameArabic']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['strength']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['strength-unit']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['size']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['size-unit']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['pharmaceutical-form']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['administration-route']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['storage-conditions']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['price']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['dose'],
                                                                          prescription
                                                                              .data()['quantity'],
                                                                          prescription
                                                                              .data()['refill'],
                                                                          prescription
                                                                              .data()['dosing-expire'],
                                                                          prescription
                                                                              .data()['frequency'],
                                                                          prescription
                                                                              .data()['instruction-note']
                                                                              .toString(),
                                                                          prescription
                                                                              .data()['doctor-note']
                                                                              .toString(),
                                                                        );
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('/Patient')
                                                                            .doc(widget.uid)
                                                                            .collection('/Prescriptions')
                                                                            .doc(prescription.id)
                                                                            .delete();
                                                                        PastPrescriptions(
                                                                          uid: widget
                                                                              .uid,
                                                                        );
                                                                        Flushbar(
                                                                          backgroundColor:
                                                                              kLightColor,
                                                                          borderRadius:
                                                                              4.0,
                                                                          margin:
                                                                              EdgeInsets.all(8.0),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                          messageText:
                                                                              Text(
                                                                            ' تم حذف الوصفة بنجاح.',
                                                                            style:
                                                                                TextStyle(
                                                                              color: kBlueColor,
                                                                              fontFamily: 'Almarai',
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        )..show(context).then((r) =>
                                                                            Navigator.pop(context));
                                                                      });
                                                              noButton =
                                                                  FlatButton(
                                                                child:
                                                                    Text('لا'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              );

                                                              return AlertDialog(
                                                                title: Text(
                                                                    'هل أنت متأكد من حذف الوصفة؟',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kBlueColor,
                                                                      fontFamily:
                                                                          'Almarai',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                titleTextStyle: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                actions: [
                                                                  yesButton,
                                                                  noButton
                                                                ],
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25)),
                                                                ),
                                                                elevation: 24.0,
                                                              );
                                                            });
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
                            return SizedBox();
                          }
                        });
                  }),
            ),
          ],
        ));
  }
}
