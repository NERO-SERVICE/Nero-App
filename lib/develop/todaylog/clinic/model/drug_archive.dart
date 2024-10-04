import 'package:equatable/equatable.dart';

class DrugArchive extends Equatable {
  final int archiveId;
  final String drugName;
  final String? target;
  final String? capacity;

  DrugArchive({
    required this.archiveId,
    required this.drugName,
    this.target,
    this.capacity,
  });

  DrugArchive.empty()
      : archiveId = 1,
        drugName = '',
        target = null,
        capacity = null;

  factory DrugArchive.fromJson(Map<String, dynamic> json) {
    return DrugArchive(
      archiveId: json['archiveId'] ?? 1,
      drugName: json['drugName'] ?? '',
      target: json['target'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'archiveId': archiveId,
      'drugName': drugName,
      'target': target,
      'capacity': capacity,
    };
  }

  @override
  List<Object?> get props => [archiveId, drugName, target, capacity];
}
