import 'package:weight_tracker/weight.dart';
import 'dart:convert';
import 'dart:io';

class Data {
  static List<Weight> weight = [];
  static bool isFile = false;

  static void importData() async {
    File file = File('data.json');
    String contents;

    if (await file.exists()) {
      contents = await file.readAsString();

      final decodedJson = jsonDecode(contents) as List<dynamic>;

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
}
