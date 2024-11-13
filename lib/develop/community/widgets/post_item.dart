import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_community_divider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const PostItem({
    Key? key,
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onComment,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
  }) : super(key: key);

  Widget _buildProfileImage() {
    if (post.profileImageUrl != null && post.profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: CachedNetworkImageProvider(post.profileImageUrl!),
        backgroundColor: Colors.grey[200],
      );
    } else {
      return const CircleAvatar(
        radius: 16,
        backgroundImage: AssetImage('assets/develop/default_profile.png'),
        backgroundColor: Colors.grey,
      );
    }
  }

  void _showEditDeleteReportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.inactiveButtonColor,
                  fixedSize: Size(150, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                child: Text(
                  "삭제",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFFF5A5A),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.inactiveButtonColor,
                  fixedSize: Size(150, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onReport();
                },
                child: Text(
                  "신고",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCommunityDivider(),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildProfileImage(),
                    SizedBox(width: 8),
                    Text(
                      post.nickname,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                    SizedBox(width: 8),
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
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => _showEditDeleteReportModal(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 56, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: post.images[0],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: SvgPicture.asset(
                          'assets/develop/nero-small-logo.svg',
                          width: 50,
                          height: 50,
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
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              post.isLiked
                                  ? 'assets/develop/heart-on.svg'
                                  : 'assets/develop/heart-off.svg',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${post.likeCount}',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffD9D9D9),
                              ),
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
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${post.commentCount}',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffD9D9D9),
                              ),
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