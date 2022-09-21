import 'package:flutter/material.dart';
import 'home.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Weight Tracker',
    theme: ThemeData.dark(useMaterial3: true),
    home: const Home(),
  ));
}
