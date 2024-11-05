import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostItem({
    Key? key,
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff3C3C3C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일 이미지
              if (post.images.isNotEmpty)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(post.images[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    color: Color(0xff1C1C1C),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/develop/nero-small-logo.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              // 게시물 정보
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 닉네임 및 날짜
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post.nickname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${post.createdAt.year}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // 게시물 내용
                      Text(
                        post.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),

                      // 좋아요 및 댓글 수
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onLike,
                            child: Row(
                              children: [
                                Icon(
                                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${post.likeCount}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: onComment,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${post.commentCount}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}