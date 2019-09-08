import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'class_year_enums.dart';
import 'class_year_button.dart';
import 'globals.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());
// Color(0xFF800000)
Color activeColor = Color(0xFF500000);
Color inactiveColor = Color(0xFF707373);

FlutterBlue flutterBlue = FlutterBlue.instance;
BluetoothDevice bluetoothDevice;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      home: VoiceHome(),
      debugShowCheckedModeBanner: false,
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

  void checkWildcat(ClassYear currClassYear, String finalText) {
    //start
    if (currClassYear == ClassYear.freshman && finalText.contains("23")) {
      btStart();
    } else if (currClassYear == ClassYear.sophomore &&
        finalText.contains("22")) {
      btStart();
    } else if (currClassYear == ClassYear.junior && finalText.contains("21")) {
      btStart();
    } else if (currClassYear == ClassYear.senior && finalText.contains("20")) {
      btStart();
    } else {}
    //stop
    if (currClassYear == ClassYear.freshman &&
        (finalText == ("a") ||
            finalText.contains("hey") ||
            finalText.contains("aa"))) {
      btStop();
    } else if (currClassYear == ClassYear.sophomore &&
        finalText.contains("aaa")) {
      btStop();
    } else if ((currClassYear == ClassYear.junior ||
            currClassYear == ClassYear.senior) &&
        (finalText.contains("whoop") ||
            finalText.contains("route") ||
            finalText.contains("hoop") ||
            finalText.contains("woop"))) {
      btStop();
    } else {}
  }

  Future connectDevice(d) async {
    await d.connect();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setRecognitionResultHandler((String speech) {
      List<String> speechList = speech.split(" ");
      String finalText = speechList[speechList.length - 1];
      checkWildcat(gCurrentClassYear, finalText.toLowerCase());

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

  Future btStart() async {
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.serviceUuid.toString() ==
            "0000ffe0-0000-1000-8000-00805f9b34fb") {
          c.write([111]);
        }
      }
    });
  }

  Future btStop() async {
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.serviceUuid.toString() ==
            "0000ffe0-0000-1000-8000-00805f9b34fb") {
          c.write([103]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    backgroundColor: Color(0xFF998542),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF003C71),
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
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                          children: snapshot.data
                              .map((d) => GestureDetector(
                                    child: Container(
                                      width: 101.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage('assets/reveille.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      connectDevice(d);
                                    },
                                  ))
                              .toList(),
                        ),
                  ),
                  Container(
                    width: 150.0,
                    height: 120.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://brandguide.tamu.edu/assets/img/logos/tam-logo.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                          children: snapshot.data
                              .map((d) => GestureDetector(
                                    child: Container(
                                      width: 101.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/reveilleFlip.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      bluetoothDevice = d;
                                    },
                                  ))
                              .toList(),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
