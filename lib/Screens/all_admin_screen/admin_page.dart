import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        child: TabBar(
          tabs: [
            Tab(text: 'Doctor'),
            Tab(text: 'Pharmacist'),
            Tab(text: 'Patient'),
          ],
        ),
      ),
    );
  }
}
