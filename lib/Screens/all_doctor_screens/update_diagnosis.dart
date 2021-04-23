// import ''/AndroidStudioProjects/alwasef_app/lib/models/prescription_model.dart';
import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateDiagnosis extends StatefulWidget {
  UpdateDiagnosis(
      {this.uid,
      this.documentID,
      this.medicalDiagnosis,
      this.diagnosisDescription,
      this.medicalAdvice,
      this.creationDate,
      this.endDate,
      this.startDate});

  final String uid;
  final String documentID;
  String medicalDiagnosis = '';
  String diagnosisDescription = '';
  String medicalAdvice = '';
  String startDate = '';
  String endDate = '';
  final String creationDate;

  static final String id = 'add_diagnosis_screen';
  @override
  _UpdateDiagnosisState createState() => _UpdateDiagnosisState();
}

class _UpdateDiagnosisState extends State<UpdateDiagnosis> {
  //Data from Api with default value

  String prescriberId = FirebaseAuth.instance.currentUser.uid;
  // formatted date
  static final DateTime now = DateTime.now();
  final String creationDate = formatter.format(now);
  //Data from TextFields
  String medicalDiagnosis;
  String diagnosisDescription;
  String medicalAdvice;
  //Random Variables
  String stringFromTF;
  final maxLines = 5;
  // the creation on the prescription date
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // start date
  String startDate;
  // end date
  String endDate;
  //Form requirements
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  //Lists

  //Methods

  @override
  Widget build(BuildContext context) {
    print(widget.medicalAdvice);
    print(widget.documentID);
    print(widget.uid);
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: kLightColor,
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Form(
            key: _key,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Container(
                              child: Text(
                                'تعديل التشخيص الطبي',
                                style: TextStyle(
                                  color: kGreyColor,
                                  fontSize: 33.0,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Card(
                            color: kGreyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      validator: Validation().validateMessage,
                                      decoration: InputDecoration(
                                        labelText: 'التشخيص الصحي',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                            Icons.medical_services_outlined),
                                      ),
                                      onSaved: (value) {
                                        medicalDiagnosis = value;
                                      },
                                      initialValue: widget.medicalDiagnosis,
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
                                    child: TextFormField(
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        labelText: 'وصف التشخيص',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: Validation().validateMessage,
                                      onSaved: (value) {
                                        setState(() {
                                          diagnosisDescription = value;
                                        });
                                      },
                                      initialValue: widget.diagnosisDescription,

                                      //controller: hospCtrl,
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
                                    child: TextFormField(
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        labelText: 'النصيحة الطبية',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: Validation().validateMessage,
                                      onSaved: (value) {
                                        setState(() {
                                          medicalAdvice = value;
                                        });
                                      },
                                      initialValue: widget.medicalAdvice,

                                      //controller: hospCtrl,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 100.0, vertical: 20.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: RaisedButton(
                                        textColor: Colors.white54,
                                        color: Colors.white,
                                        child: Text(
                                          'تعديل',
                                          style: TextStyle(
                                            color: kGreyColor,
                                            // fontFamily: 'Montserrat',
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_key.currentState.validate()) {
                                            _key.currentState.save();
                                            UserManagement(
                                                    currentPatient_uid:
                                                        widget.uid,
                                                    documentId:
                                                        widget.documentID)
                                                .diagnosisUpdate(
                                              medicalAdvice:
                                                  widget.medicalAdvice,
                                              medicalDiagnosis:
                                                  widget.medicalDiagnosis,
                                              diagnosisDescription:
                                                  widget.diagnosisDescription,
                                              context: context,
                                              prescriberId: FirebaseAuth
                                                  .instance.currentUser.uid,
                                              patientId: widget.uid,
                                              creationDate: creationDate,
                                            );
                                            Flushbar(
                                              backgroundColor: Colors.white,
                                              borderRadius: 4.0,
                                              margin: EdgeInsets.all(8.0),
                                              duration: Duration(seconds: 4),
                                              messageText: Text(
                                                ' تم تعديل التشخيص الطبي بنجاح.',
                                                style: TextStyle(
                                                  color: kBlueColor,
                                                  fontFamily: 'Almarai',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )..show(context).then(
                                                (r) => Navigator.pop(context));
                                          } else {
                                            // there is an error
                                            setState(() {
                                              autovalidateMode =
                                                  AutovalidateMode.always;
                                            });
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
