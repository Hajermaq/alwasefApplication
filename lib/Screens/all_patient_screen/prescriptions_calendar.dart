
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:some_calendar/some_calendar.dart';
//import 'package:calendar_flutter/calendar_event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class PrescriptionsCalendar extends StatefulWidget {
  final String uid;
  PrescriptionsCalendar({this.uid});
  @override
  _PrescriptionsCalendarState createState() => _PrescriptionsCalendarState();
}

class _PrescriptionsCalendarState extends State<PrescriptionsCalendar> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _eventsName;
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

  //TODO: snapshot from database weather fill or show medicall history
  //onPressed: (){
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             EditMedicalHistoryPage(
  //               uid: CurrentUser,
  //             )
  //     )
  // );
  // Navigator.pushNamed(context, FillMedicalHistoryPage.id);



  //table calendar package
  //(prescriptionsDateInfo Map<DateTime, List<dynamic>>)
  // Widget calendar(){
    // Map<DateTime, List<Event>> events;
    // events= {
    //   DateTime.now(): [
    //     Event(
    //       date: DateTime.now(),
    //       title: 'event1',
    //       icon: Icon(Icons.ac_unit_sharp),
    //       dot: Container(
    //         margin: EdgeInsets.symmetric(horizontal: 1.0),
    //         color: Colors.red,
    //         height: 5.0,
    //         width: 5.0,
    //       ),
    //     ),
    //   ]
    // };
    // DateTime startDate, DateTime endDate, String medicineName
    // Map<DateTime, List<dynamic>> events;
    // for(int i=0; i <= endDate.difference(startDate).inDays; i++){
    //   events.addAll({startDate.add(Duration(days: i)): [medicineName]});
    // }

    // return TableCalendar(
    //   locale: 'ar',
    //   //events: ,//{DateTime.now(): ['Asprin','vitamic C']},
    //   startingDayOfWeek: StartingDayOfWeek.sunday,
    //   weekendDays: [DateTime.friday, DateTime.saturday,],
    //   calendarController: _calendarController,
    //   calendarStyle: CalendarStyle(
    //     canEventMarkersOverflow: true, ///???
    //     todayColor: Colors.redAccent,
    //     selectedColor:  kBlueColor,
    //     weekdayStyle: TextStyle(color: Colors.black),
    //     weekendStyle: TextStyle(color: Colors.black),
    //   ),
    //   headerStyle: HeaderStyle(
    //     centerHeaderTitle: true,
    //     formatButtonShowsNext: false,
    //     titleTextStyle: TextStyle(
    //         fontSize: 20.0,
    //         color: Colors.black
    //     ),
    //     formatButtonDecoration: BoxDecoration(
    //       color: Colors.redAccent,
    //       borderRadius: BorderRadius.circular(20.0),
    //     ),
    //   ),
    //   onDaySelected: (day, events, li){
    //     print(day);
    //     print(events);
    //     print(li);
    //     print(DateTime.parse('2021-03-02'));
    //   },
    //   // builders: CalendarBuilders(
    //   //   dayBuilder: (context, day, events){
    //   //
    //   //   }
    //   // ),
    // );
  // }
  //calendar event package
  // void calendar2(){
  //   List<CalendarEvent> eventsList = List<CalendarEvent>();
  //
  //   CalendarEvent event = CalendarEvent();
  //   event.title = "Meeting";
  //   event.startTime = DateTime(2020,07,01);
  //   event.endTime = DateTime(2020,07,10);
  //   event.bgColor = Colors.redAccent;
  //   eventsList.add(event);
  //
  //   event = CalendarEvent();
  //   event.title = "Meeting2";
  //   event.startTime = DateTime(2020,07,06);
  //   event.endTime = DateTime(2020,07,15);
  //   event.bgColor = Colors.teal;
  //   eventsList.add(event);
  //   CalendarEvent.setListAndUpdateMap(eventsList);
  // }


  Widget ttoo(){
    return Scaffold(
      backgroundColor: kGreyColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/Patient')
              .doc(widget.uid)
              .collection('/Prescriptions')
              .where('status', isEqualTo: 'dispensed')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              String startDate;
              String endDate;
              snapshot.data.docs.forEach((doc){
                startDate = doc.data()['creation'];
                endDate = doc.data()['dosage'];
              });
              return Column(
                children: [
                  //calendar(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      height: 20,
                      thickness: 8,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder( //seperated listview
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data.docs.length == 0) {
                              return Text('ليس لديك أي وصفات طبية حاليا');
                            } else {
                              DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    10.0, 10.0, 10.0, 0),
                                color: Color(0xfff0f2f7),
                                child:  ListTile(
                                  //TODO: drug icon
                                  leading: Icon(Icons.animation),
                                  title: Text('hello'),
                                  subtitle: Text('dssofjisu'),
                                  // title:  Text(documentSnapshot.data()['scientificName']),
                                  // subtitle: Text(documentSnapshot.data()['dosage']),
                                  // subtitle: Text(documentSnapshot.data()['frequency']),
                                  //subtitle: Text('endDate.difference(startDate).inDays'),
                                ),
                              );
                            }
                          }
                      ),
                    ),
                  ),
                ],
              );
            }
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kGreyColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/Patient')
              .doc(widget.uid)
              .collection('/Prescriptions')
              .where('status', isEqualTo: 'مصروفة')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              DateTime selectedDay;
              DateTime startDate;
              DateTime endDate;
              String tradeName;
              Map<DateTime, List<dynamic>> events;
              List<DateTime> listD;
              snapshot.data.docs.forEach((doc){
                // startDate = DateTime.parse(doc.data()['start-date']);
                // endDate = DateTime.parse(doc.data()['end-date']);
                // tradeName = doc.data()['tradename'];
                // // for(int i=0; i <= endDate.difference(startDate).inDays; i++){
                // //   events.addAll({startDate.add(Duration(days: i)): [tradeName]});
                // // }
                // // for(int i=0; i <= endDate.difference(startDate).inDays; i++){
                // //   listD.add(startDate.add(Duration(days: i)));
                // // }
                // print(startDate);
                // print(tradeName);
              });

              return Column(
                children: [
                  TableCalendar(
                    locale: 'ar',
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
                      selectedDay = day;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      height: 20,
                      thickness: 8,
                    ),
                  ),
                  Text('الوصفات :', style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder( //seperated listview
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data.docs.length == 0) {
                              return Text('ليس لديك أي وصفات طبية حاليا');
                            } else {
                              DocumentSnapshot docSnapshot = snapshot.data.docs[index];
                              var startDate = DateTime.parse(docSnapshot.data()['start-date']);
                              var endDate = DateTime.parse(docSnapshot.data()['start-date']);
                              if (selectedDay.isAfter(startDate) & selectedDay.isBefore(endDate)){
                                var tradename = docSnapshot.data()['tradename'];
                                var frequency = docSnapshot.data()['frequency'];
                                var dose = docSnapshot.data()['dose']; }
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    10.0, 10.0, 10.0, 0),
                                color: Color(0xfff0f2f7),
                                child:  ListTile(
                                  //TODO: drug icon
                                  leading: Icon(Icons.animation),
                                  title: Text('hello'),
                                  subtitle: Text('dssofjisu'),
                                  // title:  Text(docSnapshot.data()['scientificName']),
                                  // subtitle: Text(docSnapshot.data()['dosage']),
                                  // subtitle: Text(docSnapshot.data()['frequency']),
                                  // subtitle: Text('endDate.difference(startDate).inDays'),
                                ),
                              );
                            }
                          }
                      ),
                    ),
                  ),
                ],
              );
            }
          }
      )
    );
  }
}
