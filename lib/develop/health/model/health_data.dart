class StepCount {
  final int? id;
  final DateTime date;
  final int steps;

  StepCount({
    this.id,
    required this.date,
    required this.steps,
  });

  factory StepCount.fromJson(Map<String, dynamic> json) {
    return StepCount(
      id: json['id'],
      date: DateTime.parse(json['date']),
      steps: json['steps'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'steps': steps,
    };
  }
}
