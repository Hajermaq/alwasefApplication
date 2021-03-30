import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  //SharedPreference pref;

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
      onDaySelected: (day, events, li){
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
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/Patient')
                    .doc(widget.uid)
                    .collection('/Prescriptions') //TODO: where status equals ...
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    Map<DateTime, List<dynamic>> allEventsMap = {};

                    snapshot.data.docs.forEach((doc){

                      String start = doc.data()['start-date'];
                      var startDate = DateTime.tryParse(start);
                      String prescriptionName = doc.data()['tradeNameArabic'];

                      if (allEventsMap.containsKey(startDate)){
                        allEventsMap[startDate].add(prescriptionName);
                      } else {
                        allEventsMap.addAll({
                          startDate: [prescriptionName]   });
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
            //...selectedDayEvents.map((event) => ListTile(title: Text('$event'))),
            // ListView.builder(
            //     itemCount: selectedDayEvents.length,
            //     itemBuilder: (context, index) {
            //       print(selectedDayEvents.length);
            //       return Container();
            //     })
            Builder(
              builder: (context) {
                if (selectedDayEvents.isNotEmpty) {
                  return Container(color: Colors.black);
                } else {
                  return Container(color: Colors.yellow);
                }
              }
            ),
            ListTile(title: Text('heloo'), leading: Icon(Icons.build_circle_outlined)),
          ]
        )
      ),
    );
  }
}
