class MenstruationCycle {
  final int? id;
  final int owner;
  final DateTime startDate;
  final DateTime endDate;
  final int? cycleLength;
  final String? notes;

  MenstruationCycle({
    this.id,
    required this.owner,
    required this.startDate,
    required this.endDate,
    this.cycleLength,
    this.notes,
  });

  factory MenstruationCycle.fromJson(Map<String, dynamic> json) {
    return MenstruationCycle(
      id: json['id'],
      owner: json['owner'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      cycleLength: json['cycleLength'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'notes': notes,
    };
  }
}
