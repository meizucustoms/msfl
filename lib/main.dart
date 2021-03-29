import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPowered = false;
  double _coldBrightness = 150;
  double _warmBrightness = 150;

  Future<File> _writeContents(String contents) async {
    final file = File('/proc/msfl');
    return file.writeAsString('$contents');
  }

  void _updateKernelBrightness(double cold, double warm) {
    if (cold < 20 || warm < 20) {
      cold = 0;
      warm = 0;
    }

    String toWrite = cold.round().toString() + ',' + warm.round().toString();
    _writeContents(toWrite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.bolt), Text("MS Flashlight")]),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Power on flashlight:',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isPowered = !_isPowered;
                  if (_isPowered)
                    _updateKernelBrightness(_coldBrightness, _warmBrightness);
                  else
                    _updateKernelBrightness(0, 0);
                });
              },
              icon: Icon(
                Icons.bolt,
                color: _isPowered ? Colors.blue : Colors.grey,
              ),
              iconSize: 200,
            ),
            SizedBox(
              height: 50,
            ),
            Text("Cold brightness:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: _coldBrightness,
                  min: 0,
                  max: 300,
                  label: _coldBrightness.round().toString() + " mA",
                  onChanged: (double value) {
                    setState(() {
                      _coldBrightness = value;
                      if (_isPowered) {
                        _updateKernelBrightness(
                            _coldBrightness, _warmBrightness);
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(_coldBrightness.round().toString() + " mA"),
              ],
            ),
            _coldBrightness < 10
                ? Text(
                    "Note: cold brightness is <10mA, you'll don't see the cold light.",
                    style: TextStyle(color: Colors.grey))
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Text("Warm brightness:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: _warmBrightness,
                  min: 0,
                  max: 300,
                  label: _warmBrightness.round().toString() + " mA",
                  onChanged: (double value) {
                    setState(() {
                      _warmBrightness = value;
                      if (_isPowered) {
                        _updateKernelBrightness(
                            _coldBrightness, _warmBrightness);
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(_warmBrightness.round().toString() + " mA"),
              ],
            ),
            _warmBrightness < 10
                ? Text(
                    "Note: warm brightness is <10mA, you'll don't see the warm light.",
                    style: TextStyle(color: Colors.grey))
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _coldBrightness = 20;
                        _warmBrightness = 20;
                        _updateKernelBrightness(
                            _coldBrightness, _warmBrightness);
                      });
                    },
                    child: Text("MIN")),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _coldBrightness = 300;
                        _warmBrightness = 300;
                        _updateKernelBrightness(
                            _coldBrightness, _warmBrightness);
                      });
                    },
                    child: Text("MAX"))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
    );
  }
}
