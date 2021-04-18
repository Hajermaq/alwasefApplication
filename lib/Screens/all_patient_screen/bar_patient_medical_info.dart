import 'package:alwasef_app/Screens/all_patient_screen/tab_past_diagnoses_for_patient.dart';
import 'package:alwasef_app/Screens/all_patient_screen/tab_past_prescriptions_for_patient.dart';
import 'package:alwasef_app/Screens/all_patient_screen/tab_prescriptions_for_patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import 'tab_diagnoses_for_patient.dart';
import 'edit_medical_history_page.dart';
import 'fill_medical_history_page.dart';

class PatientMedicalInfo extends StatefulWidget {
  final String name;
  final String email;
  final String uid;
  PatientMedicalInfo({this.uid, this.name, this.email});
  @override
  _PatientMedicalInfoState createState() => _PatientMedicalInfoState();
}

class _PatientMedicalInfoState extends State<PatientMedicalInfo>
    with TickerProviderStateMixin {

  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: kLightColor),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          title: Text(
            'المعلومات الصحية ',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      color: klighterColor,
                      child: Column(
                        children: [
                          DefaultTabController(
                            length: 5,
                            child: TabBar(
                              controller: _tabController,
                              labelStyle: TextStyle(
                                  //up to your taste
                                  fontWeight: FontWeight.w700),
                              indicatorSize:
                                  TabBarIndicatorSize.label, //makes it better
                              labelColor: kBlueColor, //Google's sweet blue
                              unselectedLabelColor: kGreyColor, //niceish grey
                              isScrollable: true, //up to your taste
                              indicator: MD2Indicator(
                                  //it begins here
                                  indicatorHeight: 3,
                                  indicatorColor: kBlueColor,
                                  indicatorSize: MD2IndicatorSize
                                      .normal //3 different modes tiny-normal-full
                                  ),
                              tabs: <Widget>[
                                Tab(
                                  text: "الوصفات الطبية",
                                ),
                                Tab(
                                  text: "التشخيصات",
                                ),
                                Tab(
                                  text: "التاريخ الطبي",
                                ),
                                Tab(
                                  text: "الوصفات السابقة",
                                ),
                                Tab(
                                  text: "التشخيصات السابقة",
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DefaultTabController(
                              length: 5,
                              child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    PatientPrescriptions(
                                      uid: widget.uid,
                                    ),
                                    PatientDiagnoses(
                                      uid: widget.uid,
                                    ),
                                    Center(
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('/Patient')
                                              .doc(widget.uid)
                                              .collection('/Medical History')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          backgroundColor: kGreyColor,
                                                          valueColor: AlwaysStoppedAnimation(kBlueColor))
                                              );
                                            }
                                            if (snapshot.data.docs.length == 0) {
                                              return Column(
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    color: kGreyColor,
                                                    margin: EdgeInsets.fromLTRB(
                                                        10.0, 10.0, 10.0, 0),
                                                    child: ListTile(
                                                      leading:
                                                          Icon(Icons.animation),
                                                      title: Text(
                                                          'السجل الطبي للمريض',
                                                          style:
                                                              ksubBoldLabelTextStyle),
                                                      subtitle: Text(
                                                          'قم بتعبئة سجلك الطبي'),
                                                      trailing: IconButton(
                                                          icon: Icon(Icons
                                                              .insert_drive_file_outlined),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            FillMedicalHistoryPage(
                                                                              uid: widget.uid,
                                                                            )));
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    color: kGreyColor,
                                                    margin: EdgeInsets.fromLTRB(
                                                        10.0, 10.0, 10.0, 0),
                                                    child: ListTile(
                                                      leading:
                                                          Icon(Icons.animation),
                                                      title: Text(
                                                          'السجل الطبي للمريض',
                                                          style:
                                                              ksubBoldLabelTextStyle),
                                                      subtitle: Text(
                                                          'قم بتحديث سجلك الطبي بشكل دوري'),
                                                      trailing: IconButton(
                                                          icon: Icon(Icons
                                                              .edit_outlined),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EditMedicalHistoryPage(
                                                                              uid: widget.uid,
                                                                            )));
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }),
                                    ),
                                    PatientPastPrescriptions(
                                      uid: widget.uid,
                                    ),
                                    PatientPastDiagnoses(
                                      uid: widget.uid,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //tabs
              ],
            ),
          ),
        ),
      ),
    );
  }
}
