import 'package:flutter/material.dart';
import 'home.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: 'Weight Tracker',
    theme: ThemeData.dark(),
    home: const Home(),
  ));
}
