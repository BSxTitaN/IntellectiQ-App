import 'package:flutter/material.dart';
import 'package:intellectiq/screens/home/home.dart';

import 'design/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Geist",
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.mainAppColor),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}