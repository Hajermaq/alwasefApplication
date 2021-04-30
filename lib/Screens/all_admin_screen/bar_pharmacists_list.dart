import 'package:alwasef_app/Screens/all_admin_screen/pharmacist_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/profile_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class HospitalPharmacist extends StatefulWidget {
  static const String id = 'hospital_pharmacist_screen';
  @override
  _HospitalPharmacistState createState() => _HospitalPharmacistState();
}

class _HospitalPharmacistState extends State<HospitalPharmacist> {
  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: kLightColor,
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
          'قائمة الصيادلة ',
          style: GoogleFonts.almarai(
            color: kBlueColor,
            fontSize: 28.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FilledRoundTextFields(
                fillColor: kGreyColor,
                color: kScaffoldBackGroundColor,
                hintMessage: 'ابحث',
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                }),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('/Pharmacist')
                        .where('hospital-uid',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                              backgroundColor: kGreyColor,
                              valueColor: AlwaysStoppedAnimation(kBlueColor)),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document =
                                snapshot.data.docs[index];
                            String name = document.data()['pharmacist-name'];
                            if (name
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase()) ||
                                name
                                    .toUpperCase()
                                    .contains(searchValue.toUpperCase())) {
                              return Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 0),
                                    color: Color(0xfff0f2f7),
                                    child: ListTile(
                                      title: Text(
                                        '${document.data()['pharmacist-name']}',
                                        // textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: kBlueColor, fontSize: 25.0),
                                      ),
                                      subtitle: Text(
                                        '${document.data()['email']}',
                                        // textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: kBlueColor, fontSize: 20.0),
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_left),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PharmacistManagement(
                                              pharmacist_id:
                                                  document.data()['uid'],
                                              speciality:
                                                  document.data()['speciality'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  ListTileDivider(
                                    color: kLightColor,
                                  ),
                                ],
                              );
                            }
                            return SizedBox();
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
