import 'package:equatable/equatable.dart';

class News extends Equatable {
  final int id;
  final String title;
  final String link;
  final DateTime createdAt;

  News({
    required this.id,
    required this.title,
    required this.link,
    required this.createdAt,
  });

  News.empty()
      : id = 0,
        title = '',
        link = '',
        createdAt = DateTime.now();

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    link,
    createdAt,
  ];
}
