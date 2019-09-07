import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'class_year_enums.dart';
import 'class_year_button.dart';
import 'globals.dart';

void main() => runApp(MyApp());
// Color(0xFF800000)
Color activeColor = Colors.blue;
Color inactiveColor = Colors.red;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(),
      theme: ThemeData.dark(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;

  String resultText = "";

  Color freshManColor = activeColor;
  Color sophomoreColor = inactiveColor;
  Color juniorColor = inactiveColor;
  Color seniorColor = inactiveColor;

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void checkWildcat(ClassYear x, String finalText) {
    if (x == ClassYear.freshman && finalText == "23") {
      print("FRESHMAN");
    } else if (x == ClassYear.sophomore && finalText == "22") {
      print("SOHOMORE");
    } else if (x == ClassYear.junior && finalText == "21") {
      print("JUNIOR");
    } else if (x == ClassYear.senior && finalText == "20") {
      print("SENIOR");
    } else {
      print("NOBODY");
    }
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setRecognitionResultHandler((String speech) {
      List<String> speechList = speech.split(" ");
      String finalText = speechList[speechList.length - 1];
      checkWildcat(ClassYear.freshman, finalText);
      if (finalText == "stop") {
        _speechRecognition.stop();
      }

      setState(() => (resultText = finalText));
    });

    _speechRecognition.setRecognitionCompleteHandler(() => _speechRecognition
        .listen(locale: "en_US")
        .then((result) => print("yo")));
  }

  void updateColor(ClassYear year) {
    if (year == ClassYear.freshman) {
      freshManColor = activeColor;
      sophomoreColor = inactiveColor;
      juniorColor = inactiveColor;
      seniorColor = inactiveColor;
    } else if (year == ClassYear.sophomore) {
      freshManColor = inactiveColor;
      sophomoreColor = activeColor;
      juniorColor = inactiveColor;
      seniorColor = inactiveColor;
    } else if (year == ClassYear.junior) {
      freshManColor = inactiveColor;
      sophomoreColor = inactiveColor;
      juniorColor = activeColor;
      seniorColor = inactiveColor;
    } else if (year == ClassYear.senior) {
      freshManColor = inactiveColor;
      sophomoreColor = inactiveColor;
      juniorColor = inactiveColor;
      seniorColor = activeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateColor(ClassYear.freshman);
                          });
                          gCurrentClassYear = ClassYear.freshman;
                        },
                        child: ClassYearButton(
                          classYear: 'Freshman',
                          colour: freshManColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateColor(ClassYear.sophomore);
                          });
                          gCurrentClassYear = ClassYear.sophomore;
                        },
                        child: ClassYearButton(
                          classYear: 'Sophomore',
                          colour: sophomoreColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateColor(ClassYear.junior);
                          });
                          gCurrentClassYear = ClassYear.junior;
                        },
                        child: ClassYearButton(
                          classYear: 'Junior',
                          colour: juniorColor,
                        ),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateColor(ClassYear.senior);
                          });
                          gCurrentClassYear = ClassYear.senior;
                        },
                            child: ClassYearButton(
                              classYear: 'Senior',
                              colour: seniorColor,
                            ))),
                  ],
                ),
              ),
              Container(
                  child: Image.network(
                      'https://brandguide.tamu.edu/assets/img/logos/tam-logo.png')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    child: Icon(Icons.mic),
                    onPressed: () {
                      _speechRecognition
                          .listen(locale: "en_US")
                          .then((result) => print("yo"));
                    },
                    backgroundColor: Colors.pink,
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent[100],
                  borderRadius: BorderRadius.circular(6.0),
                ),
                margin: EdgeInsets.all(30.0),
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                child: Center(
                  child: Text(
                    resultText,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
