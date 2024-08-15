import 'package:equatable/equatable.dart';

class DrfSelfRecord extends Equatable {
  final int id;
  final DateTime createdAt;
  final String content;

  DrfSelfRecord({
    required this.id,
    required this.createdAt,
    required this.content,
  });

  factory DrfSelfRecord.fromJson(Map<String, dynamic> json) {
    return DrfSelfRecord(
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'content': content,
    };
  }

  @override
  List<Object?> get props => [id, createdAt, content];
}
