import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicalHistoryHeadLine extends StatelessWidget {
  MedicalHistoryHeadLine({this.label, this.onTap, this.wantIcon});
  final String label;
  final Function onTap;
  final bool wantIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onTap,
            child: wantIcon == false
                ? SizedBox()
                : Icon(
                    Icons.add,
                  ),
          )
        ],
      ),
    );
  }
}

class MedicalHistoyListTile extends StatelessWidget {
  MedicalHistoyListTile({this.dataText, this.titleText});
  final String titleText;
  final String dataText;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        titleText,
        style: TextStyle(color: Colors.black),
      ),
      trailing: Text(
        dataText,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
