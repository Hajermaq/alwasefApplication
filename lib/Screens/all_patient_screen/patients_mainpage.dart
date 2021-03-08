import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alwasef_app/Screens/services/provider_management.dart';
import 'package:alwasef_app/components/filled_round_text_field.dart';
import 'package:alwasef_app/components/round_text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import '../../constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:alwasef_app/Screens/services/user_management.dart';
import 'fill_medical_history_screen.dart';



class PatientMainPage extends StatefulWidget {
  static const String id = 'patient_screen';
  final UserManagement user = UserManagement();
  // final String name;
  // final String email;
  // PatientMainPage({this.name, this.email});
  @override
  _PatientMainPageState createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {

  CalendarController _calendarController = CalendarController();
  final authM = FirebaseAuth.instance;
  final fireM = FirebaseFirestore.instance;

  // @override
  // void setState(fn) {
  //   // TODO:
  //   super.setState(fn);
  // }
  Widget createCalendar(){
    return TableCalendar(
        calendarStyle: CalendarStyle(
          todayColor: kRedColor,
          selectedColor: kTextFieldborderColor,
        ),
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarController: _calendarController);
  }

  Widget addReport(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40.0,),
          Text('اختر الوصفة التي تريد التقرير عنها:',
            style: TextStyle(
              fontSize: 20.0,
              color: kRedColor, ),
          ),
          SizedBox(
            height: 30,
            width: 1000,
            child: FlatButton(
              child: Text('اخــتـر'),
              color: kTextFieldborderColor,
              onPressed: (){},
            ),
          ),
          Text('هل أتممت الوصفة الطبية؟',
            style: TextStyle(
              fontSize: 20.0,
              color: kRedColor, ),
          ),
          TextField(
            maxLines: 2, decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),),
          Text('هل التزمت بالوصفة الطبية؟',
            style: TextStyle(
              fontSize: 20.0,
              color: kRedColor, ),
          ),
          TextField(
            maxLines: 2, decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),),
          Text('هل ظهرت عليك أعراض جانبية، اذكرها:',
            style: TextStyle(
              fontSize: 20.0,
              color: kRedColor, ),
          ),
          TextField(
            maxLines: 5, decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),),
          Text('ملاحظات أخرى:',
            style: TextStyle(
              fontSize: 20.0,
              color: kRedColor, ),
          ),
          TextField(
            maxLines: 5, decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),),
          FlatButton(
            child: Text('حفظ'),
            color: kRedColor,
            onPressed: (){},
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xffE4E8F4),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: ScrollNavigation(
            barStyle: NavigationBarStyle(
              background: Color(0xffBBC6E3),
              activeColor: kScaffoldBackGroundColor,
              verticalPadding: 15.0,
            ),
            identiferStyle: NavigationIdentiferStyle(
              color: kScaffoldBackGroundColor,
            ),
            pages: [
              //reports page
              Scaffold(
                appBar: AppBar(
                  backgroundColor: kGreyColor,
                  leading: GestureDetector(
                    onTap: (){
                      //creatReport()
                    },
                    child:Icon(Icons.add),
                  ),
                  title: Text(
                    'قدم تقريرا عن مدى مناسبة الوصفة لك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      color: kButtonTextColor,
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: kButtonTextColor,
                    child: Icon(Icons.add),
                    onPressed: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => addReport());
                    }
                ),
                body:  ListView(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: Card(
                          color: kGreyColor,
                          child: Text(' تقرير 1 '),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Card(
                          color: kGreyColor,
                          child: Text(' تقرير 2 '),
                        ),
                      ),
                    ]
                ),
              ),


              //calendar Page
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                    child: Card(
                      color: kGreyColor,
                      child: Text(
                        'تابع تقدمك ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: kButtonTextColor,
                        ),
                      ),
                    ),
                  ),
                  createCalendar(),

                  Expanded(

                    child: Card(
                      child: Text('الوصفة 1'),
                      color: kScaffoldBackGroundColor,
                      //margin: EdgeInsets.all(12.4),
                    ),
                  ),
                ],
              ),


              //Profile Page
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                        color: klighterColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundColor: kLightColor,
                                child: Icon(
                                  Icons.person,
                                  color: kBlueColor,
                                  size: 50,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ha',
                                    //widget.name,
                                    style: TextStyle(
                                        color: kBlueColor, fontSize: 30.0),
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  Text(
                                    '0545133660',
                                    style: TextStyle(
                                        color: kBlueColor, fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          color: klighterColor,
                          child: Column(
                            children: [
                              DefaultTabController(
                                length: 3,
                                child: TabBar(
                                  labelStyle: TextStyle(
                                    //up to your taste
                                      fontWeight: FontWeight.w700),
                                  indicatorSize:
                                  TabBarIndicatorSize.label, //makes it better
                                  labelColor: kBlueColor, //Google's sweet blue
                                  unselectedLabelColor: kGreyColor, //niceish grey
                                  isScrollable: true, //up to your taste
                                  indicator: MD2Indicator(
                                    //it begins here
                                      indicatorHeight: 3,
                                      indicatorColor: kBlueColor,
                                      indicatorSize: MD2IndicatorSize
                                          .normal //3 different modes tiny-normal-full
                                  ),
                                  tabs: <Widget>[
                                    Tab(
                                      text: "السجل الطبي",
                                    ),
                                    Tab(
                                      text: "التشخيصات",
                                    ),
                                    Tab(
                                      text: "الوصفات الطبية",
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: DefaultTabController(
                                  length: 3,
                                  child: TabBarView(children: [
                                    //TODO: snapshot from database weather fill or show medicall history


                                    Row(
                                      children:[
                                      Text(
                                        'اضغط هنا لمعاينة السجل الصحي',
                                        style: TextStyle(
                                          color: kScaffoldBackGroundColor)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined),
                                        onPressed: (){
                                          Navigator.pushNamed(context, FillMedicalHistoryPage.id);
                                      },),
                                      ]
                                    ),


                                    Center(
                                      child: Text(
                                        'b',
                                        style: TextStyle(fontSize: 500.0),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'c',
                                        style: TextStyle(fontSize: 500.0),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //tabs
                  ],
                ),
              ),



            ], //end of pages

            items: [
              ScrollNavigationItem(
                  icon: Icon(Icons.article_outlined)
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.calendar_today_sharp),
              ),
              ScrollNavigationItem(
                icon: Icon(Icons.account_circle_outlined),
              ),
            ], // end of items
          ),
        ),
      ),
    );

  }

}
