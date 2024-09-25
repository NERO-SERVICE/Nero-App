class Mail {
  final int? owner;
  final DateTime createdAt;
  final String suggestion;

  Mail({
    this.owner,
    required this.createdAt,
    required this.suggestion,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      owner: json['owner'],
      createdAt: DateTime.parse(json['createdAt']),
      suggestion: json['suggestion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'suggestion': suggestion,
    };
  }
}
