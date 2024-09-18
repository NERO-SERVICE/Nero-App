import 'package:equatable/equatable.dart';

class Fastmemo extends Equatable {
  final int id;
  final DateTime date;
  final String content;
  final bool isChecked;

  Fastmemo({
    required this.id,
    required this.date,
    required this.content,
    this.isChecked = false,
  });

  factory Fastmemo.fromJson(Map<String, dynamic> json) {
    return Fastmemo(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date']),
      content: json['content'] ?? '',
      isChecked: json['is_checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'content': content,
      'is_checked': isChecked,
    };
  }

  Fastmemo copyWith({
    int? id,
    DateTime? date,
    String? content,
    bool? isChecked,
  }) {
    return Fastmemo(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    content,
    isChecked,
  ];
}