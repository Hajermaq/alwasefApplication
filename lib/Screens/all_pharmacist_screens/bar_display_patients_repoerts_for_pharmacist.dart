import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class DisplayReportsPh extends StatefulWidget {
  @override
  _DisplayReportsPhState createState() => _DisplayReportsPhState();
}

class _DisplayReportsPhState extends State<DisplayReportsPh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text('تقاريرjjjjjj المرضى',
            style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
          ),
        ),
        body: Center(
          child: GestureDetector(
            onTap: (){
              print('ggg');
              return Container(color: Colors.green);
            },
            child: Container(
              color: Colors.black,
            ),
          ),
        )
    );

  }
}
