import 'package:equatable/equatable.dart';
import 'drug.dart';
import 'drug_archive.dart';
import 'my_drug_archive.dart';

class Clinic extends Equatable {
  final int clinicId;
  final int owner;
  final String nickname;
  final DateTime recentDay;
  final DateTime nextDay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final List<Drug> drugs;

  Clinic({
    required this.clinicId,
    required this.owner,
    required this.nickname,
    required this.recentDay,
    required this.nextDay,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    required this.drugs,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinicId: json['clinicId'] ?? 1,
      owner: json['owner'] ?? 1,
      nickname: json['nickname'] ?? '',
      recentDay: DateTime.parse(json['recentDay']),
      nextDay: DateTime.parse(json['nextDay']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      description: json['description'],
      drugs: (json['drugs'] as List<dynamic>?)
          ?.map<Drug>((item) => Drug.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicId': clinicId,
      'owner': owner,
      'nickname': nickname,
      'recentDay': recentDay.toIso8601String(),
      'nextDay': nextDay.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'description': description,
      'drugs': drugs.map((e) => e.toJson()).toList(),
    };
  }

  Clinic copyWith({
    int? clinicId,
    int? owner,
    String? nickname,
    DateTime? recentDay,
    DateTime? nextDay,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    List<Drug>? drugs,
  }) {
    return Clinic(
      clinicId: clinicId ?? this.clinicId,
      owner: owner ?? this.owner,
      nickname: nickname ?? this.nickname,
      recentDay: recentDay ?? this.recentDay,
      nextDay: nextDay ?? this.nextDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      drugs: drugs ?? this.drugs,
    );
  }

  @override
  List<Object?> get props => [
    clinicId,
    owner,
    nickname,
    recentDay,
    nextDay,
    createdAt,
    updatedAt,
    description,
    drugs,
  ];
}
