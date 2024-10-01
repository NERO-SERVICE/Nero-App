import 'package:equatable/equatable.dart';

class QuestionSubtype extends Equatable {
  final int id;
  final String subtypeCode;
  final String subtypeName;

  QuestionSubtype({
    required this.id,
    required this.subtypeCode,
    required this.subtypeName,
  });

  factory QuestionSubtype.fromJson(Map<String, dynamic> json) {
    return QuestionSubtype(
      id: json['id'] ?? 0,
      subtypeCode: json['subtype_code'] ?? '',
      subtypeName: json['subtype_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subtype_code': subtypeCode,
      'subtype_name': subtypeName,
    };
  }

  @override
  List<Object?> get props => [id, subtypeCode, subtypeName];
}
