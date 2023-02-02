import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // use `const` keyword for stateless widgets where possible
  // this will improve performance as the widget will be created once and stored in memory
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xekhai\'s Battery Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Xekhai\'s Battery Check'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('batteryCheck.xekhai/batteryCheck');

// the string that will hold the battery level information
  String _batteryLevel = 'Let\'s Get started!';

  // the threshold at which the alert will be shown
  int _threshold = 60;

  // timer to get the battery level periodically
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // start the timer to monitor the battery level and display an alert if the battery level falls below a certain threshold
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getBatteryLevel();
    });
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Current Battery level: $result % .';
      if (result <= _threshold) {
        // cancel the timer if the battery level goes below the threshold
        _timer.cancel();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning: Battery level below given threshold'),
              content: Text('Battery level is below $_threshold% \n'
                  'Current Battery Level: $result%'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(_batteryLevel),
            FilledButton(
                onPressed: () {
                  _getBatteryLevel();
                },
                child: Text("Check Battery"))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
