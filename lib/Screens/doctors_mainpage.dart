import 'package:alwasef_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:alwasef_app/constants.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class DoctorMainPage extends StatefulWidget {
  static const String id = 'doctor_main_screen';
  @override
  _DoctorMainPageState createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  //requirements for the search
  TextEditingController editingController = TextEditingController();
  //list of 9999 items
  final duplicateItems = List<String>.generate(100, (i) => " $i رقم ");
  // empty list
  var items = List<String>();

  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    items.addAll(duplicateItems);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void filterSearchResult(String query) {
    //created an empty list
    List<String> dummySearchList = List<String>();
    // added the duplicatedItems <fixed>
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> sugguestedItems = List<String>();
      //loop through the duppySearchList and find a match in search bar
      // if found a match add the item in a new list >> sugguestedItems
      dummySearchList.forEach((item) {
        if (item.contains(query) || item.contains(query.toLowerCase())) {
          sugguestedItems.add(item);
        }
      });
      // then notify the framework that there has been a change which is
      // 1. we cleared the items list
      // 2. instead we add the matched results
      setState(() {
        items.clear();
        items.addAll(sugguestedItems);
      });
      // if there is no match we skip
      return;
    } //end of if
    else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            Container(
              child: Text('Home Page'),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: TextField(
                        textAlign: TextAlign.end,
                        onChanged: (value) {
                          filterSearchResult(value);
                        },
                        controller: editingController,
                        decoration: InputDecoration(
                          hintText: 'ابحث',
                          hintStyle: kTextFieldHintStyle,
                          suffixIcon: Icon(
                            Icons.search,
                            color: kLightColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kLightGreenColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kLightGreenColor,
                            ),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        // 99 items
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(
                                right: 30.0,
                              ),
                              child: Text(
                                '${items[index]}',
                                textAlign: TextAlign.end,
                              ),
                            ),
                            onTap: () {
                              print('item clicked');
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
            Container(
              child: Text('Home Page'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text('Home'),
            activeColor: kLightGreenColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search_outlined),
            title: Text('Search'),
            activeColor: kLightGreenColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.account_circle_outlined),
            title: Text('Account'),
            activeColor: kLightGreenColor,
          ),
        ],
      ),
    );
  }
}
