import 'dart:async';
import 'package:flutter/material.dart';
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
              position = pos.toString();
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I-SenTrack"),
      ),
      body: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(position)
      ])),
    );
  }
}
