import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:supercoder/utils/utilities.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        (Timer t) => determinePosition().then((pos) => setState(() {
              position = pos.latitude.toStringAsFixed(3) + ", " + pos.longitude.toStringAsFixed(3);
            })));
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text("I-SenTrack"),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.white38),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(backgroundColor: isPortrait ? const Color(0xFFf05624) : Colors.black26, radius: 110),
            const SizedBox(height: 10),
            Text(position, style: const TextStyle(color: Color(0xFFa71e4a), fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(_luxString, style: const TextStyle(color: Color(0xFFa71e4a), fontSize: 22, fontWeight: FontWeight.w700))
          ])),
    );
  }
}
