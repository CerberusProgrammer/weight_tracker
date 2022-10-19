import 'dart:collection';

import 'package:weight_tracker/weight.dart';
import 'dart:convert';

void main() {
  List<Weight> weight = [];
  Weight w1 = Weight(117, DateTime.now());
  Weight w2 = Weight(100, DateTime.now());
  Weight w3 = Weight(95, DateTime.now());

  weight.add(w1);
  weight.add(w2);
  weight.add(w3);

  String json = jsonEncode(weight);
}
