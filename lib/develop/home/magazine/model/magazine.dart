import 'package:equatable/equatable.dart';

class Magazine extends Equatable {
  final int magazineId;
  final String title;
  final String? description;
  final List<String> imageUrls;
  final int writer;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;

  Magazine({
    this.magazineId = 0,
    this.title = '',
    this.description,
    this.imageUrls = const [],
    this.writer = 0,
    this.nickname = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Magazine.empty()
      : magazineId = 0,
        title = '',
        description = null,
        imageUrls = [],
        writer = 0,
        nickname = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      magazineId: json['magazineId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      writer: json['writer'] ?? 0,
      nickname: json['nickname'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'magazineId': magazineId,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'writer': writer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Magazine copyWith({
    String? title,
    String? description,
    int? writer,
    List<String>? imageUrls,
    String? nickname,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Magazine(
      magazineId: magazineId,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    magazineId,
    title,
    description,
    imageUrls,
    writer,
    nickname,
    createdAt,
    updatedAt,
  ];
}
