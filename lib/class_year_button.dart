import 'package:flutter/material.dart';
import 'class_year_enums.dart';

Color activeColor = Color(0xFF800000);
Color inactiveColor = Color(0xFF80000);

class ClassYearButton extends StatefulWidget {
  final String classYear;
  ClassYearButton({@required this.classYear});
  @override
  _ClassYearButtonState createState() =>
      _ClassYearButtonState(classYear: classYear);
}

class _ClassYearButtonState extends State<ClassYearButton> {
  final String classYear;
  _ClassYearButtonState({@required this.classYear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: activeColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(classYear),
    );
  }
}
