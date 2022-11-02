import 'dart:collection';

import 'package:weight_tracker/user.dart';
import 'package:weight_tracker/weight.dart';
import 'dart:convert';
import 'dart:io';

class Data {
  static List<Weight> weight = [];
  static bool isFile = false;
  static bool importedData = false;

  void loadData() {
    bool weightData = importWeightData();
    bool userData = importUserData();

    if (weightData && userData) {
      importedData = true;
    }

    Weight.MAX = User.actualWeight + 10;
    Weight.MIN = User.actualWeight - 10;
  }

  bool importUserData() {
    File file = File('user.json');

    if (!file.existsSync()) {
      return false;
    }

    String content = file.readAsStringSync();
    final decoded = jsonDecode(content) as List<dynamic>;

    for (var element in decoded) {
      Weight w = Weight.fromJson(element);
      weight.add(w);
    }

    return true;
  }

  bool importWeightData() {
    File file = File('weight.json');

    if (!file.existsSync()) {
      return false;
    }

    String content = file.readAsStringSync();
    final decoded = jsonDecode(content) as List<dynamic>;

    for (var element in decoded) {
      Weight w = Weight.fromJson(element);
      weight.add(w);
    }

    User.actualWeight = weight[weight.length - 1].weight;

    return true;
  }

  static void exportData() {
    File('data.json').writeAsStringSync(jsonEncode(weight));
  }

  static void exportUserData() {
    Map<String, double> max = HashMap<String, double>();
    Map<String, double> min = HashMap<String, double>();
    max.addAll({'MAX': Weight.MAX});
    min.addAll({'MIN': Weight.MIN});

    String mx = jsonEncode(max);
    String mi = jsonEncode(min);

    var file = File('user.json');

    if (file.existsSync()) {
      File('data.json').writeAsStringSync(mx + mi);
    } else {
      File('data.json').writeAsStringSync(mx + mi);
    }
  }
}
