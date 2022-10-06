class Weight {
  double weight;
  DateTime date;

  static late final double MAX;
  static late final double MIN;

  Weight(this.weight, this.date);

  setWeight(double weight) => this.weight = weight;
  double getWeight() => weight;
}
