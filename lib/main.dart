import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'class_year_enums.dart';
import 'class_year_button.dart';
import 'globals.dart';

void main() => runApp(MyApp());

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
                    Expanded(child: ClassYearButton(classYear: 'Freshman',)),
                    Expanded(child: ClassYearButton(classYear: 'Sophomore',)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(child: ClassYearButton(classYear: 'Junior')),
                    Expanded(child: ClassYearButton(classYear: 'Senior',)),
                  ],
                ),
              ),
              Container(
                child: Image.network('https://brandguide.tamu.edu/assets/img/logos/tam-logo.png')),
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
