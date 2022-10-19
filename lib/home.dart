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

  double lowerWeight = 200;
  double higherWeight = 0;

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
          ),
          PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: const Text('Clean History'),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: const Text('Reset Goal'),
                      onTap: () {},
                    ),
                  ]),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, right: 20, bottom: 85, left: 20),
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

                        if (double.parse(weight.text) < Weight.MIN ||
                            double.parse(weight.text) > Weight.MAX) {
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
                            double w = Weight.actualWeight;
                            texts.add(Text(w.toString()));
                            DateTime now = DateTime.now();
                            Weight w1 = Weight(
                                w, DateTime(now.year, now.month, now.day));
                            Data.weight.add(w1);

                            texts.add(Text(weight.text));
                          } else {
                            texts.add(Text(weight.text));
                          }
                        });

                        DateTime now = DateTime.now();
                        Weight w1 =
                            Weight(w, DateTime(now.year, now.month, now.day));
                        Data.weight.add(w1);

                        Data.exportData();

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

  void cleanHistory() {}

  void resetGoal() {}

  List<ListTile> makeListTile() {
    List<ListTile> list = [];

    for (int i = 0; i < Data.weight.length; i++) {
      list.add(
        ListTile(
          title: Text('${Data.weight[i].weight} kg'),
          subtitle: Text(
              '${Data.weight[i].date.year}/${Data.weight[i].date.month}/${Data.weight[i].date.day}'),
        ),
      );
    }

    return list;
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
          backgroundColor: const Color.fromARGB(255, 194, 194, 194),
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
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: 10.0,
            max: Weight.MAX,
            min: Weight.MIN,
            textStyle: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) =>
            DateTime(now.month, now.day).toString().substring(0, 10),
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
          color: Color.fromRGBO(255, 193, 7, 1),
          thickness: 4.0,
        ),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipLineShape<ChartLineDataItem>(
          backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
          circleBackgroundColor: Colors.white,
          circleBorderColor: const Color.fromARGB(255, 0, 0, 0),
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
            color: Color.fromARGB(255, 255, 255, 255),
            letterSpacing: 0.2,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
  }
}
