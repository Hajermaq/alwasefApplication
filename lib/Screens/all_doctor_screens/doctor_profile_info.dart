import 'package:flutter/material.dart';

class DoctorProfileInfo extends StatefulWidget {
  @override
  _DoctorProfileInfoState createState() => _DoctorProfileInfoState();
}

class _DoctorProfileInfoState extends State<DoctorProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                  child: Card(
                    color: Colors.red,
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
