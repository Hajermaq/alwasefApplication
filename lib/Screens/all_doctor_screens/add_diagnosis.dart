import 'package:alwasef_app/Screens/login_and_registration/textfield_validation.dart';
import 'package:alwasef_app/components/text_field_1.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:alwasef_app/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class AddDiagnosis extends StatefulWidget {
  AddDiagnosis({this.uid});
  final String uid;
  static final String id = 'add_diagnosis_screen';
  @override
  _AddDiagnosisState createState() => _AddDiagnosisState();
}

class _AddDiagnosisState extends State<AddDiagnosis> {
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
                                'أضف تشخيص جديد',
                                style: TextStyle(
                                  color: kGreyColor,
                                  fontSize: 40.0,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                  TextField_1(
                                    textInputType: TextInputType.text,
                                    validator: Validation().validateMessage,
                                    onSaved: (value) {
                                      medicalDiagnosis = value;
                                    },
                                    labelText: 'التشخيص الصحي',
                                  ),
                                  Divider(
                                    color: klighterColor,
                                    thickness: 0.9,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    height: maxLines * 24.0,
                                    child: TextField_1(
                                      labelText: 'تعليمات للمريض',
                                      validator: Validation().validateMessage,
                                      onSaved: (String value) {
                                        setState(() {
                                          diagnosisDescription = value;
                                        });
                                      },
                                      maxLines: maxLines,
                                    ),
                                  ),
                                  Divider(
                                    color: klighterColor,
                                    thickness: 0.9,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    height: maxLines * 24.0,
                                    child: TextField_1(
                                      labelText: 'النصيحة الطبية',
                                      validator: Validation().validateMessage,
                                      onSaved: (String value) {
                                        setState(() {
                                          medicalAdvice = value;
                                        });
                                      },
                                      maxLines: maxLines,
                                    ),
                                  ),
                                ],
                              ),
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
                                color: kGreyColor,
                                child: Text(
                                  'إرسال',
                                  style: TextStyle(
                                    color: Colors.white,
                                    // fontFamily: 'Montserrat',
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                onPressed: () {
                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();
                                    UserManagement().newDiagnosisSetUp(
                                        context,
                                        widget.uid,
                                        prescriberId,
                                        creationDate,
                                        medicalDiagnosis,
                                        diagnosisDescription,
                                        medicalAdvice);
                                    Flushbar(
                                      backgroundColor: Colors.white,
                                      borderRadius: 4.0,
                                      margin: EdgeInsets.all(8.0),
                                      duration: Duration(seconds: 4),
                                      messageText: Text(
                                        ' تم إضافة تشخيص جديدة لهذا المريض',
                                        style: TextStyle(
                                          color: kBlueColor,
                                          fontFamily: 'Almarai',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )..show(context)
                                        .then((r) => Navigator.pop(context));
                                  } else {
                                    // there is an error
                                    setState(() {
                                      autovalidateMode =
                                          AutovalidateMode.always;
                                    });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
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
