import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int commentId;
  final String nickname;
  final DateTime createdAt;
  final String content;
  final int likeCount;
  final bool isLiked;
  final bool isAuthor;

  Comment({
    this.commentId = 0,
    this.nickname = '',
    required this.createdAt,
    this.content = '',
    this.likeCount = 0,
    this.isLiked = false,
    this.isAuthor = false,
  });

  Comment.empty()
      : commentId = 0,
        nickname = '',
        createdAt = DateTime.now(),
        content = '',
        likeCount = 0,
        isLiked = false,
        isAuthor = false;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'] ?? 0,
      nickname: json['user']?['nickname'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      content: json['content'] ?? '',
      likeCount: json['likes_count'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isAuthor: json['isAuthor'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'nickname': nickname,
      'created_at': createdAt.toIso8601String(),
      'content': content,
      'likes_count': likeCount,
      'isLiked': isLiked,
      'isAuthor': isAuthor,
    };
  }

  Comment copyWith({
    int? commentId,
    String? nickname,
    DateTime? createdAt,
    String? content,
    int? likeCount,
    bool? isLiked,
    bool? isAuthor,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isAuthor: isAuthor ?? this.isAuthor,
    );
  }

  @override
  List<Object?> get props => [
    commentId,
    nickname,
    createdAt,
    content,
    likeCount,
    isLiked,
    isAuthor,
  ];
}
