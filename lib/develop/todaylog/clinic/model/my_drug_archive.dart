import 'package:equatable/equatable.dart';

class MyDrugArchive extends Equatable {
  final int myArchiveId;
  final int owner;
  final int archiveId;
  final String drugName;
  final String? target;
  final String? capacity;

  MyDrugArchive({
    required this.myArchiveId,
    required this.owner,
    required this.archiveId,
    required this.drugName,
    this.target,
    this.capacity,
  });

  MyDrugArchive.empty()
      : myArchiveId = 1,
        owner = 1,
        archiveId = 1,
        drugName = '',
        target = null,
        capacity = null;

  factory MyDrugArchive.fromJson(Map<String, dynamic> json) {
    return MyDrugArchive(
      myArchiveId: json['myArchiveId'] ?? 1,
      owner: json['owner'] ?? 1,
      archiveId: json['archiveId'] ?? 1,
      drugName: json['drugName'] ?? '',
      target: json['target'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myArchiveId': myArchiveId,
      'owner': owner,
      'archiveId': archiveId,
      'drugName': drugName,
      'target': target,
      'capacity': capacity,
    };
  }

  @override
  List<Object?> get props => [myArchiveId, owner, archiveId, drugName, target, capacity];
}
