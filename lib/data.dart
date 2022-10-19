import 'dart:collection';

import 'package:weight_tracker/weight.dart';
import 'dart:convert';
import 'dart:io';

class Data {
  static List<Weight> weight = [];
  static bool isFile = false;

  static void importData() async {
    File file = File('data.json');
    File fu = File('user.json');
    String contents;
    String info;

    if (await file.exists()) {
      contents = await file.readAsString();
      info = await fu.readAsString();

      final decodedJson = jsonDecode(contents) as List<dynamic>;

      if (info.isEmpty) {
      } else {
        final userInfo = jsonDecode(info) as List<dynamic>;

        Weight.MAX = double.parse(userInfo[0]);
        Weight.MIN = double.parse(userInfo[1]);
      }

      for (int i = 0; i < decodedJson.length; i++) {
        Weight w = Weight.fromJson(decodedJson[i]);
        weight.add(w);
      }

      isFile = true;
    }
  }

  static void exportData() async {
    String json = jsonEncode(weight);

    var file = File('data.json');

    if (await file.exists()) {
      await File('data.json').writeAsString(json);
    } else {
      await File('data.json').writeAsString(json);
    }
  }

  static void exportUserData() async {
    Map<String, double> max = HashMap<String, double>();
    Map<String, double> min = HashMap<String, double>();
    max.addAll({'MAX': Weight.MAX});
    min.addAll({'MIN': Weight.MIN});

    String mx = jsonEncode(max);
    String mi = jsonEncode(min);

    var file = File('user.json');

    if (await file.exists()) {
      await File('data.json').writeAsString(mx + mi);
    } else {
      await File('data.json').writeAsString(mx + mi);
    }
  }
}
