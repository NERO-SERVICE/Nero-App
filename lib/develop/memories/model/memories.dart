import 'package:equatable/equatable.dart';

class Memories extends Equatable {
  final int? memoryId;
  final int? userId;
  late final List<String>? items;

  Memories({
    this.memoryId,
    this.userId,
    this.items,
  });

  Memories.empty()
      : memoryId = null,
        userId = null,
        items = [];

  factory Memories.fromJson(Map<String, dynamic> json) {
    return Memories(
      memoryId: json['memoryId'],
      userId: json['userId'],
      items: json['items'] != null ? List<String>.from(json['items']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memoryId': memoryId,
      'userId': userId,
      'items': items,
    };
  }

  Memories copyWith({
    int? memoryId,
    int? userId,
    List<String>? items,
  }) {
    return Memories(
      memoryId: memoryId ?? this.memoryId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    memoryId,
    userId,
    items,
  ];
}
