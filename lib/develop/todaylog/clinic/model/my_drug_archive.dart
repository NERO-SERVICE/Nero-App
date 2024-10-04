import 'package:equatable/equatable.dart';

class MyDrugArchive extends Equatable {
  final int myArchiveId;
  final int archiveId;
  final String drugName;
  final String? target;
  final String? capacity;

  MyDrugArchive({
    required this.myArchiveId,
    required this.archiveId,
    required this.drugName,
    this.target,
    this.capacity,
  });

  factory MyDrugArchive.fromJson(Map<String, dynamic> json) {
    return MyDrugArchive(
      myArchiveId: json['myArchiveId'] ?? 1,
      archiveId: json['archiveId'] ?? 1,
      drugName: json['drugName'] ?? '',
      target: json['target'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myArchiveId': myArchiveId,
      'archiveId': archiveId,
      'drugName': drugName,
      'target': target,
      'capacity': capacity,
    };
  }

  @override
  List<Object?> get props => [myArchiveId, archiveId, drugName, target, capacity];
}