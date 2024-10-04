import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final List<String> imageUrls;
  final int writer;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    this.id = 0,
    this.title = '',
    this.description,
    this.imageUrls = const [],
    this.writer = 0,
    this.nickname = '',
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationModel.empty()
      : id = 0,
        title = '',
        description = null,
        imageUrls = [],
        writer = 0,
        nickname = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [], // 서버에서 제공하는 이미지 URL 리스트
      writer: json['writer'] ?? 0,
      nickname: json['nickname'] ?? '', // 서버에서 nickname 필드 제공
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'writer': writer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? title,
    String? description,
    int? writer,
    List<String>? imageUrls,
    String? nickname,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id,
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
    id,
    title,
    description,
    imageUrls,
    writer,
    nickname,
    createdAt,
    updatedAt,
  ];
}
