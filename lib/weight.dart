class Weight {
  double weight;
  DateTime date;

  static late double MAX;
  static late double MIN;
  static late double actualWeight;

  Weight(this.weight, this.date);

  setWeight(double weight) => this.weight = weight;
  double getWeight() => weight;

  setDate(DateTime date) => this.date = date;
  DateTime getDate() => date;

  Map toJson() => {
        'weight': weight,
        'date': date.toString(),
      };
}
