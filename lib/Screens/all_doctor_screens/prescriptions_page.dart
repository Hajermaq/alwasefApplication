import 'package:alwasef_app/models/PrescriptionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'add_prescriptions.dart';

class Prescriptions extends StatelessWidget {
  Prescriptions({this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: klighterColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.note_add_outlined),
          backgroundColor: kBlueColor,
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPrescriptions(
                  uid: uid,
                ),
              ),
            );
            // showModalBottomSheet(
            //   isScrollControlled: true,
            //   context: context,
            //   builder: (context) => AddPrescriptions(),
            // );
          },
        ),
        body: Center(
          child: Consumer<PrescriptionData>(
              builder: (context, prescriptionData, index) {
            return ListView.builder(
                itemCount: prescriptionData.prescriptionCount,
                itemBuilder: (context, index) {
                  final prescription = prescriptionData.prescriptions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: kGreyColor,
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.build_circle_outlined,
                            size: 50,
                          ),
                          title: Text(
                            prescription.tradeName,
                            style: kBoldLabelTextStyle,
                          ),
                          // subtitle: Text(
                          //   '  $pharmaceuticalForm   -   $strength $strengthUnit ',
                          //   style: TextStyle(
                          //       color: Colors.black45,
                          //       fontSize: 14.0,
                          //       fontWeight: FontWeight.w500),
                          // ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'التاريخ',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  prescription.creationDate,
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: klighterColor,
                          thickness: 0.9,
                          endIndent: 20,
                          indent: 20,
                        ),
                        Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'بداية الوصفة',
                                    style: ksubBoldLabelTextStyle,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    '${prescription.startDate}',
                                    style: kValuesTextStyle,
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                indent: 20,
                                endIndent: 20.0,
                                color: kLightColor,
                                thickness: 1.5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'اعادة التعبئة',
                                    style: ksubBoldLabelTextStyle,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    '${prescription.refill}',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                indent: 20,
                                endIndent: 20.0,
                                color: kLightColor,
                                thickness: 1.5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    ' التكرار',
                                    style: ksubBoldLabelTextStyle,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    '${prescription.frequency}',
                                    style: kValuesTextStyle,
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                indent: 20,
                                endIndent: 20.0,
                                color: kLightColor,
                                thickness: 1.5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'السعر',
                                    style: ksubBoldLabelTextStyle,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    prescription.publicPrice,
                                    style: kValuesTextStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
        ));
  }
}
