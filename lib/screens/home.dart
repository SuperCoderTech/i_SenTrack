import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:supercoder/utils/utilities.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  Timer? timer;
  String position = "-";

  String _luxString = 'Unknown';
  late Light _light;
  late StreamSubscription _subscription;

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    setState(() {
      _luxString = "$luxValue";
    });
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) => getLocationCoOrdinates().then((pos) => setState(() {
              position = pos!.latitude!.toStringAsFixed(4) +
                  " " +
                  pos!.longitude!.toStringAsFixed(4);
            })));
  }

  Color getColor() {
    try {
      if (int.parse(_luxString) < 30) return Colors.black;
    } catch (err) {}
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFa71e4a),
        title: const Text("I-SenTrack"),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: getColor()),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  CircleAvatar(
                      backgroundColor:
                          isPortrait ? const Color(0xFFf05624) : Colors.black26,
                      radius: 110,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_work,
                              size: 100,
                            ),
                            Text(getLocation(),
                                style: const TextStyle(
                                    color: Color(0xFFa71e4a),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700)),
                          ])),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  Text("Enter location Name"),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Submitß"),
                                                onPressed: () {},
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child:
                            Icon(Icons.add_location_alt, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15),
                          primary: Color(0xFFa71e4a), // <-- Button color
                          onPrimary: Colors.red, // <-- Splash color
                        ),
                      ))
                ]),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Text(_luxString,
                    style: const TextStyle(
                        color: Color(0xFFa71e4a),
                        fontSize: 22,
                        fontWeight: FontWeight.w700))
              ])),
    );
  }

  String getLocation() {
    return position;
  }
}
