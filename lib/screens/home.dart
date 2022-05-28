import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:supercoder/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  Timer? timer;
  String position = "-";
  String locationName = "Unknown Location";

  String _luxString = 'Unknown';
  late Light _light;
  late StreamSubscription _subscription;

  String themeName = "light";

  TextEditingController controller = TextEditingController();

  Animation<Color?>? animation;
  AnimationController? anicontroller;

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    setState(() {
      _luxString = "$luxValue";
      changeTheme();
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
    anicontroller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = ColorTween(begin: Colors.white38, end: Colors.black87)
        .animate(anicontroller!)
      ..addListener(() {});
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) => getLocationCoOrdinates().then((pos) => setState(() {
              position = pos!.latitude!.toStringAsFixed(4) +
                  " " +
                  pos!.longitude!.toStringAsFixed(4);
              print(position);
              prefs.then((SharedPreferences prefs) {
                String val = prefs.getString(position) ?? "Unknown Location";
                setState(() {
                  print(position + " " + val);
                  locationName = val;
                });
                return val;
              });
            })));
  }

  changeTheme() {
    try {
      if (int.parse(_luxString) < 30) {
        setState(() {
          themeName = "dark";
          anicontroller?.forward();
        });
      } else {
        setState(() {
          themeName = "light";
          anicontroller?.reverse();
        });
      }
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFa71e4a),
        title: const Text("I-SenTrack"),
        actions: [
          IconButton(
            icon:
                Icon(themeName == "dark" ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: animation?.value),
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(locationName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
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
                                              child: TextFormField(
                                                controller: controller,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Submitß"),
                                                onPressed: () {
                                                  print(controller.text);
                                                  setState(() {
                                                    locationName =
                                                        controller.text;
                                                  });
                                                  saveInSharedPreference(
                                                      position,
                                                      controller.text);
                                                  Navigator.pop(context);
                                                },
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
                // Text(_luxString,
                //     style: const TextStyle(
                //         color: Color(0xFFa71e4a),
                //         fontSize: 22,
                //         fontWeight: FontWeight.w700))
              ])),
    );
  }
}
