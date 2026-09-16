import 'package:flutter/material.dart';
import 'package:qs_device_info/qs_device_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Text('Device type: ${QsDeviceInfo.getDeviceType()}'),
        ),
      ),
    );
  }
}
