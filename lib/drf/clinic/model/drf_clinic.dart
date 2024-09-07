import 'package:equatable/equatable.dart';
import 'drf_drug.dart';

class DrfClinic extends Equatable {
  final int clinicId;
  final int owner;
  final String nickname;
  final DateTime recentDay;
  final DateTime nextDay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String? description;
  final List<DrfDrug> drugs;
  final double? clinicLatitude;
  final double? clinicLongitude;
  final String? locationLabel;

  DrfClinic({
    required this.clinicId,
    required this.owner,
    required this.nickname,
    required this.recentDay,
    required this.nextDay,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description,
    required this.drugs,
    this.clinicLatitude,
    this.clinicLongitude,
    this.locationLabel,
  });

  DrfClinic.empty()
      : clinicId = 0,
        owner = 1,
        nickname = '',
        recentDay = DateTime.now(),
        nextDay = DateTime.now(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        title = '',
        description = '',
        drugs = [],
        clinicLatitude = null,
        clinicLongitude = null,
        locationLabel = '';

  factory DrfClinic.fromJson(Map<String, dynamic> json) {
    return DrfClinic(
      clinicId: json['clinicId'] ?? 1,
      owner: json['owner'] ?? 1,
      nickname: json['nickname'] ?? '',
      recentDay: DateTime.parse(json['recentDay']),
      nextDay: DateTime.parse(json['nextDay']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'] ?? '',
      description: json['description'],
      drugs: (json['drugs'] as List<dynamic>)
          .map<DrfDrug>((item) => DrfDrug.fromJson(item))
          .toList(),
      clinicLatitude: json['clinicLatitude'] != null
          ? json['clinicLatitude'].toDouble()
          : null,
      clinicLongitude: json['clinicLongitude'] != null
          ? json['clinicLongitude'].toDouble()
          : null,
      locationLabel: json['locationLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'recentDay': recentDay.toIso8601String(),
      'nextDay': nextDay.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'drugs': drugs.map((e) => e.toJson()).toList(),
      'clinicLatitude': clinicLatitude,
      'clinicLongitude': clinicLongitude,
      'locationLabel': locationLabel ?? '',
    };
  }

  DrfClinic copyWith({
    int? clinicId,
    int? owner,
    String? nickname,
    DateTime? recentDay,
    DateTime? nextDay,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? description,
    List<DrfDrug>? drugs,
    double? clinicLatitude,
    double? clinicLongitude,
    String? locationLabel,
  }) {
    return DrfClinic(
      clinicId: clinicId ?? this.clinicId,
      owner: owner ?? this.owner,
      nickname: nickname ?? this.nickname,
      recentDay: recentDay ?? this.recentDay,
      nextDay: nextDay ?? this.nextDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      drugs: drugs ?? this.drugs,
      clinicLatitude: clinicLatitude ?? this.clinicLatitude,
      clinicLongitude: clinicLongitude ?? this.clinicLongitude,
      locationLabel: locationLabel ?? this.locationLabel,
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
    title,
    description,
    drugs,
    clinicLatitude,
    clinicLongitude,
    locationLabel,
  ];
}
