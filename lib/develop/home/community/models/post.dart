import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int postId;
  final String content;
  final List<String> images;
  final String nickname;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool isLiked;

  Post({
    required this.postId,
    required this.content,
    required this.images,
    required this.nickname,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] ?? 0,
      content: json['content'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((image) => image['image'] as String)
          .toList() ??
          [],
      nickname: json['user'] != null ? json['user']['nickname'] ?? '' : '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      likeCount: json['likes_count'] ?? 0,
      commentCount: json['comments_count'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  factory Post.empty() {
    return Post(
      postId: 0,
      content: '',
      images: [],
      nickname: '',
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      isLiked: false,
    );
  }

  Post copyWith({
    int? postId,
    String? content,
    List<String>? images,
    String? nickname,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
  }) {
    return Post(
      postId: postId ?? this.postId,
      content: content ?? this.content,
      images: images ?? this.images,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    postId,
    content,
    images,
    nickname,
    createdAt,
    likeCount,
    commentCount,
    isLiked,
  ];
}
