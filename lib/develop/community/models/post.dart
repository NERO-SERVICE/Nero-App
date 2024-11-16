import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int postId;
  final String content;
  final List<String> images;
  final String nickname;
  final String? profileImageUrl;
  final String createdTimeAgo;
  final int likeCount;
  late final int commentCount;
  final bool isLiked;
  final bool isAuthor;

  Post({
    required this.postId,
    required this.content,
    required this.images,
    required this.nickname,
    this.profileImageUrl,
    required this.createdTimeAgo,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.isAuthor,
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
      profileImageUrl: json['user'] != null && json['user']['profile_image'] != null
          ? json['user']['profile_image']['image_url'] as String
          : null,
      createdTimeAgo: json['created_time_ago'] ?? '',
      likeCount: json['likes_count'] ?? 0,
      commentCount: json['comments_count'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isAuthor: json['isAuthor'] ?? false,
    );
  }

  factory Post.empty() {
    return Post(
      postId: 0,
      content: '',
      images: [],
      nickname: '',
      profileImageUrl: '',
      createdTimeAgo: '',
      likeCount: 0,
      commentCount: 0,
      isLiked: false,
      isAuthor: false,
    );
  }

  Post copyWith({
    int? postId,
    String? content,
    List<String>? images,
    String? nickname,
    String? profileImageUrl,
    String? createdTimeAgo,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isAuthor,
  }) {
    return Post(
      postId: postId ?? this.postId,
      content: content ?? this.content,
      images: images ?? this.images,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdTimeAgo: createdTimeAgo ?? this.createdTimeAgo,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isAuthor: isAuthor ?? this.isAuthor,
    );
  }

  @override
  List<Object?> get props => [
    postId,
    content,
    images,
    nickname,
    profileImageUrl,
    createdTimeAgo,
    likeCount,
    commentCount,
    isLiked,
    isAuthor,
  ];
}
