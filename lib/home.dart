import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrx_charts/mrx_charts.dart';

import 'package:weight_tracker/data.dart';
import 'package:weight_tracker/weight.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List<Text> texts = [];
  final weight = TextEditingController();

  late final MAX;
  late final MIN;

  double lowerWeight = 200;
  double higherWeight = 0;

  List<ListTile> makeListTile() {
    List<ListTile> list = [];
    for (int i = 0; i < texts.length; i++) {
      list.add(
        ListTile(
          title: texts[i],
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('History'),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: ListView(
                          children: makeListTile(),
                        ),
                      ),
                    ),
                  );
                },
              ));
            },
          )
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 100, top: 20, left: 20, right: 20),
        child: Chart(
          layers: layers(),
          padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
            bottom: 12.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('What\'s your weight?'),
                  content: Padding(
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (weight.text.isEmpty) {
                          Navigator.of(context).pop();
                          return;
                        }

                        if (double.parse(weight.text) < 40 ||
                            double.parse(weight.text) > 150) {
                          Navigator.of(context).pop();
                          return;
                        }

                        if (texts.length == 5) {
                          texts.removeAt(0);
                        }

                        double w = double.parse(weight.text);

                        if (lowerWeight > w) {
                          lowerWeight = w;
                        }

                        if (higherWeight < w) {
                          higherWeight = w;
                        }

                        setState(() {
                          if (texts.isEmpty) {
                            texts.add(Text(weight.text));
                            texts.add(Text(weight.text));
                          } else {
                            texts.add(Text(weight.text));
                          }

                          Weight w1 = Weight(w, DateTime.now());
                          Data.weight.add(w1);
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Add your weight',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<ChartLayer> layers() {
    final from = DateTime(2021, 4);
    final to = DateTime(2021, 8);

    DateTime now = DateTime.now();

    final frequency =
        (to.millisecondsSinceEpoch - from.millisecondsSinceEpoch) /
            (texts.length - 1);

    return [
      ChartHighlightLayer(
        shape: () => ChartHighlightLineShape<ChartLineDataItem>(
          backgroundColor: const Color.fromARGB(255, 58, 58, 58),
          currentPos: (item) => item.currentValuePos,
          radius: const BorderRadius.all(Radius.circular(8.0)),
          width: 60.0,
        ),
      ),
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: frequency,
            max: to.millisecondsSinceEpoch.toDouble(),
            min: from.millisecondsSinceEpoch.toDouble(),
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: 10.0,
            max: 150,
            min: 40,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) =>
            DateTime(now.year, now.month, now.day).toString().substring(0, 10),
        labelY: (value) => value.toInt().toString(),
      ),
      ChartLineLayer(
        items: List.generate(
          texts.length,
          (index) => ChartLineDataItem(
            x: (index * frequency) + from.millisecondsSinceEpoch,
            value: double.parse(texts[index].data.toString()),
          ),
        ),
        settings: const ChartLineSettings(
          color: Color(0xFF8043F9),
          thickness: 4.0,
        ),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipLineShape<ChartLineDataItem>(
          backgroundColor: Colors.white,
          circleBackgroundColor: Colors.white,
          circleBorderColor: const Color(0xFF331B6D),
          circleSize: 4.0,
          circleBorderThickness: 2.0,
          currentPos: (item) => item.currentValuePos,
          onTextValue: (item) => '${item.value.toString()} kg',
          marginBottom: 6.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          radius: 6.0,
          textStyle: const TextStyle(
            color: Color(0xFF8043F9),
            letterSpacing: 0.2,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
  }
}
