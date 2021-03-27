import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onTap;
  final Icon icon_1;

  ProfileListTile({this.onTap, this.title, this.icon_1, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kGreyColor,
        // borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: icon_1,
        title: Text(
          title,
          // textAlign: TextAlign.end,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(letterSpacing: 2.0),
        ),
        trailing: Icon(Icons.keyboard_arrow_left),
        onTap: onTap,
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  ProfileTextField(
      {this.onTap, this.onChanged, this.label, this.initialVal, this.readOnly});
  final Function onTap;
  final Function onChanged;
  final String label;
  final String initialVal;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Text(
          label,
          style: ksubBoldLabelTextStyle,
        ),
        title: Container(
          child: TextFormField(
            readOnly: readOnly,
            initialValue: initialVal,
            onTap: onTap,
            onChanged: onChanged,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white54,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(),
              ),
            ),
          ),
        ),
        trailing: Icon(Icons.edit_outlined),
      ),
    );
  }
}

class ListTileDivider extends StatelessWidget {
  ListTileDivider({this.color});

  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: color,
    );
  }
}
