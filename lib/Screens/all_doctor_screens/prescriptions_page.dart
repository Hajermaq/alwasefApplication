import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';

class Prescriptions extends StatelessWidget {
  Prescriptions({this.uid});
  String uid;
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
                  uid: uid,
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
        body: Center(
          child: Consumer<PrescriptionData>(
              builder: (context, prescriptionData, index) {
            return ListView.builder(
                itemCount: prescriptionData.prescriptionCount,
                itemBuilder: (context, index) {
                  final prescription = prescriptionData.prescriptions[index];
                  return Card(
                      color: Color(0xffE9EFF9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: ListTile(
                        title: Text(
                          prescription.tradeName,
                          style: kValuesTextStyle,
                        ),
                        subtitle: Text('${prescription.refill}'),
                      ));
                });
          }),
        ));
  }
}
