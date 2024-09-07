import 'package:equatable/equatable.dart';

class DrfDrugArchive extends Equatable {
  final int id;
  final String drugName;
  final String? target;
  final String? capacity;

  DrfDrugArchive({
    required this.id,
    required this.drugName,
    this.target,
    this.capacity,
  });

  DrfDrugArchive.empty()
      : id = 1,
        drugName = '',
        target = null,
        capacity = null;

  factory DrfDrugArchive.fromJson(Map<String, dynamic> json) {
    return DrfDrugArchive(
      id: json['id'] ?? 1,
      drugName: json['drugName'] ?? '',
      target: json['target'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drugName': drugName,
      'target': target,
      'capacity': capacity,
    };
  }

  @override
  List<Object?> get props => [id, drugName, target, capacity];
}
