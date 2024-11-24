import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/community_best_posts_page.dart'; // 전체 게시물 페이지

class HomePopularCommunityPostsPage extends StatelessWidget {
  final CommunityController _controller = Get.find<CommunityController>();

  HomePopularCommunityPostsPage({
    Key? key,
  }) : super(key: key);

  String _shortenTitle(String title) {
    if (title.length > 25) {
      return '${title.substring(0, 25)}...';
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.fetchRecentPosts();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '인기 게시물',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => CommunityBestPostsPage());
                },
                child: Text(
                  '더보기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD0EE17),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (_controller.isLoadingRecentPosts.value &&
              _controller.recentPosts.isEmpty) {
            return Center(child: CustomLoadingIndicator());
          } else if (_controller.recentPosts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '게시물이 없습니다.',
                style: TextStyle(color: AppColors.inactiveTextColor),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _controller.recentPosts.length,
              itemBuilder: (context, index) {
                final post = _controller.recentPosts[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => CommunityDetailPage(postId: post.postId));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 32.0),
                    child: Text(
                      _shortenTitle(post.content),
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ],
    );
  }
}