import 'package:equatable/equatable.dart';

class DrfDrugArchive extends Equatable {
  final int archiveId;
  final String drugName;
  final String? target;
  final String? capacity;

  DrfDrugArchive({
    required this.archiveId,
    required this.drugName,
    this.target,
    this.capacity,
  });

  DrfDrugArchive.empty()
      : archiveId = 1,
        drugName = '',
        target = null,
        capacity = null;

  factory DrfDrugArchive.fromJson(Map<String, dynamic> json) {
    return DrfDrugArchive(
      archiveId: json['archiveId'] ?? 1,
      drugName: json['drugName'] ?? '',
      target: json['target'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'archiveId': archiveId,  // id 대신 archiveId 사용
      'drugName': drugName,
      'target': target,
      'capacity': capacity,
    };
  }

  @override
  List<Object?> get props => [archiveId, drugName, target, capacity];
}
