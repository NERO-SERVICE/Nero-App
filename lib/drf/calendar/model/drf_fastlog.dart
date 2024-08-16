import 'package:equatable/equatable.dart';

class DrfFastlog extends Equatable {
  final int id;
  final DateTime date;
  final String content;

  DrfFastlog({
    required this.id,
    required this.date,
    required this.content,
  });

  factory DrfFastlog.fromJson(Map<String, dynamic> json) {
    return DrfFastlog(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date']),
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'content': content,
    };
  }

  @override
  List<Object?> get props => [
    id,
    date,
    content,
  ];
}
