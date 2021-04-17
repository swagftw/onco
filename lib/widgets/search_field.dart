import 'package:flutter/material.dart';
import 'package:onco/style.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        child: TextFormField(
          enabled: false,
          style: bodyStyle,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search courses...",
            prefixIcon: Icon(
              Icons.search,
              size: 24,
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 1.4)),
          ),
        ),
      ),
    );
  }
}
