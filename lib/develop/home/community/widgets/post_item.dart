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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Color(0xffD9D9D9)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      post.nickname,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${post.createdAt.year}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Color(0xff959595),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  post.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
                SizedBox(height: 16),
                if (post.images.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage(post.images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: Padding(
                        padding: const EdgeInsets.all(16), // 터치 영역을 넓히기 위한 여백
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              post.isLiked
                                  ? 'assets/develop/heart-on.svg'
                                  : 'assets/develop/heart-off.svg',
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${post.likeCount}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onComment,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/develop/comment_icon.svg',
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${post.commentCount}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
