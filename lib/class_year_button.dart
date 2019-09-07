import 'package:flutter/material.dart';

class ClassYearButton extends StatelessWidget {
  final Color colour;
  final String classYear;

  ClassYearButton({@required this.colour, @required this.classYear});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
    color: colour,
    borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(classYear),
      );
  }
}



