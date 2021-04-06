import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:some_calendar/some_calendar.dart';
//import 'package:calendar_flutter/calendar_event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class PrescriptionsCalendar2 extends StatefulWidget {
  final String uid;
  PrescriptionsCalendar2({this.uid});
  @override
  _PrescriptionsCalendar2State createState() => _PrescriptionsCalendar2State();
}

class _PrescriptionsCalendar2State extends State<PrescriptionsCalendar2> {

  CalendarController _calendarController;
  final dateFormat = DateFormat('yyyy-MM-dd');
  List<dynamic> selectedDayEvents = [];

  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
  }
  @override
  void dispose(){
    _calendarController.dispose();
    super.dispose();
  }

  Widget theCalendar(Map<DateTime, List<dynamic>> events){
    return TableCalendar(
      locale: 'ar',
      events: events,
      //events: ,//{DateTime.now(): ['Asprin','vitamic C']},
      startingDayOfWeek: StartingDayOfWeek.sunday,
      weekendDays: [DateTime.friday, DateTime.saturday,],
      calendarController: _calendarController,
      calendarStyle: CalendarStyle(
        canEventMarkersOverflow: true, ///???
        todayColor: Colors.redAccent,
        selectedColor:  kBlueColor,
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.black),
        eventDayStyle: TextStyle(color: Colors.black),
        //markersColor: Colors.green,
        //markersMaxAmount: 4,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonShowsNext: false,
        titleTextStyle: TextStyle(
            fontSize: 20.0,
            color: Colors.black
        ),
        formatButtonDecoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onDaySelected: (day, events, li) {
        print(events);
        setState(() {
          selectedDayEvents = events;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
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
            title: Text('تابع تقدمك',
              style: GoogleFonts.almarai(color: kBlueColor, fontSize: 28.0),
            ),
          ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/Patient')
                        .doc(widget.uid)
                        .collection('/Prescriptions') //TODO: where status equals dispensed
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {

                        Map<DateTime, List<dynamic>> allEventsMap = {};
                        snapshot.data.docs.forEach((doc){
                          List <dynamic> prescriptionAllInfo = [];
                          //map keys
                          String start = doc.data()['start-date'];
                          var startDate = DateTime.tryParse(start);
                          //map values
                          String prescriptionID = doc.id;
                          String tradeName = doc.data()['tradeNameArabic'];
                          String frequency = doc.data()['frequency'];
                          //add to list
                          prescriptionAllInfo.add(prescriptionID);
                          prescriptionAllInfo.add(tradeName);
                          prescriptionAllInfo.add(frequency);

                          if (allEventsMap.containsKey(startDate)){
                            allEventsMap[startDate].add(prescriptionAllInfo);
                          } else {
                            allEventsMap.addAll({
                              startDate: [prescriptionAllInfo]   });
                          }
                        });

                        return theCalendar(allEventsMap);
                      }
                    }
                ),
                Divider(
                  height: 20,
                  thickness: 3,
                ),
                Text('وصفاتك اليوم', style: TextStyle (color: Colors.black),),
                // ...me.forEach((id, info) {
                //   return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Card(
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15.0),
                //         ),
                //         color: kGreyColor,
                //         child: ListTile(
                //           title: Text(info[0], style: TextStyle(color: Colors.black)),
                //           subtitle: Text(info[1], style: TextStyle(color: Colors.black)),
                //
                //         ),
                //       )
                //   );
                //
                // }),
                // ...me.forEach((id, info) {
                //   return Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Card(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //       ),
                //       color: kGreyColor,
                //       child: ListTile(
                //         title: Text(info[0], style: TextStyle(color: Colors.black)),
                //         subtitle: Text(info[1], style: TextStyle(color: Colors.black)),
                //       ),
                //     ),
                //   );
                // }),
                // ...selectedDayEvents.map((event) {
                //   return Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Card(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //       ),
                //       color: kGreyColor,
                //       child: ListTile(
                //         title: Text(name, style: TextStyle(color: Colors.black)),
                //         subtitle: Text(frequency, style: TextStyle(color: Colors.black)),
                //
                //       ),
                //     )
                //   );
                //
                // }),
                ...selectedDayEvents.map((event) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kGreyColor,
                      // child: Column(
                      //   children: [
                      //     Text(event[0], style: TextStyle(color: Colors.black)),
                      //     Text(event[1], style: TextStyle(color: Colors.black)),
                      //     Text(event[2], style: TextStyle(color: Colors.black)),
                      //   ]
                      // )
                      child: ListTile(
                        leading: Icon(Icons.post_add),
                        title: Text(event[1], style: TextStyle(color: Colors.black)),
                        subtitle: Text(event[2], style: TextStyle(color: Colors.black)),
                        trailing: GestureDetector(
                            child: Icon(
                              Icons.post_add,
                              color: Colors.black54,
                            ),
                            onTap: () {
                              //display prescription using event[2]
                            }
                        )
                      ),
                    )
                ),),
              ]
          )
        )
      ),
    );
  }
}
