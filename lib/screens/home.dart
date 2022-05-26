import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:supercoder/utils/utilities.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  String position = "-";

  @override
  void initState() {
    super.initState();
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
          decoration: BoxDecoration(color: Colors.white38),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            const CircleAvatar(backgroundColor: Color(0xFFf05624), radius: 110),
            Text(position, style: const TextStyle(color: isPortrait ? Color(0xFFa71e4a) : Colors.black, fontSize: 22, fontWeight: FontWeight.w700))
          ])),
    );
  }
}
