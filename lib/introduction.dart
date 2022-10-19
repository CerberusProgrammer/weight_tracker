import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:weight_tracker/weight.dart';

class Introduction {
  static final weight = TextEditingController();
  static final goal = TextEditingController();

  static List<PageViewModel> init() {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return [
      PageViewModel(
        title: "Welcome to Weight Tracker",
        body: "We want a change into your life.",
        decoration: pageDecoration,
      ),
      PageViewModel(
          title: "Please, add your weight",
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.bottomCenter,
          ),
          reverse: true,
          bodyWidget: Center(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: weight,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      suffix: Text('kg'),
                      icon: Icon(Icons.monitor_weight_outlined),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
          ))),
      PageViewModel(
        title: "Set you goal",
        decoration: pageDecoration.copyWith(
          bodyAlignment: Alignment.bottomCenter,
        ),
        bodyWidget: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: goal,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Goal',
                    suffix: Text('kg'),
                    icon: Icon(Icons.monitor_weight_outlined),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
