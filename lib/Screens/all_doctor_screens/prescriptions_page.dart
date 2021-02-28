import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';

class Prescriptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: klighterColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add_outlined),
        backgroundColor: kBlueColor,
        onPressed: () {
          // Navigator.pop(context);
          Navigator.pushNamed(context, AddPrescriptions.id);
          // showModalBottomSheet(
          //   isScrollControlled: true,
          //   context: context,
          //   builder: (context) => AddPrescriptions(),
          // );
        },
      ),
      body: Center(child: ListView.builder(itemBuilder: (context, index) {
        return Card(
            color: Color(0xffE9EFF9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            child: ListTile());
      })),
    );
  }
}
