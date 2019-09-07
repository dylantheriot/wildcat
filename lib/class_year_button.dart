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
        child: ConstrainedBox(constraints: BoxConstraints(
          minHeight: 300.0,
          minWidth: 100.0,
        ),child: Center(child: Text(classYear, style: TextStyle(fontSize: 30.0, color: Colors.white)))),
      );
  }
}



