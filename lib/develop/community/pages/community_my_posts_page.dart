import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/widgets/post_item.dart';

class CommunityMyPostsPage extends StatefulWidget {
  @override
  _CommunityMyPostsPageState createState() => _CommunityMyPostsPageState();
}

class _CommunityMyPostsPageState extends State<CommunityMyPostsPage> {
  final CommunityController _controller = Get.find<CommunityController>();
  late final ScrollController _scrollController;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchMyPosts(refresh: true);
    });

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 500 &&
          !_controller.isLoadingMyPosts.value &&
          _controller.hasMoreMyPosts.value) {
        _controller.fetchMyPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'CommunityMyPostsPage',
      screenClass: 'CommunityMyPostsPage',
    );
    return Scaffold(
      appBar: CustomDetailAppBar(title: '내가 작성한 커뮤니티 글'),
      body: Obx(() {
        if (_controller.isLoadingMyPosts.value && _controller.myPosts.isEmpty) {
          return Center(child: CustomLoadingIndicator());
        }

        if (_controller.myPosts.isEmpty) {
          return Center(
            child: Text(
              '내가 작성한 게시물이 없습니다.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xffD9D9D9),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.fetchMyPosts(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _controller.myPosts.length + 1,
            itemBuilder: (context, index) {
              if (index == _controller.myPosts.length) {
                return _controller.hasMoreMyPosts.value
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CustomLoadingIndicator()),
                      )
                    : SizedBox.shrink();
              }

              final post = _controller.myPosts[index];
              return PostItem(
                post: post,
                onTap: () async {
                  await Get.to(() => CommunityDetailPage(postId: post.postId));
                },
                onLike: () {
                  _controller.toggleLikePost(post.postId);
                },
                onComment: () async {
                  await Get.to(() => CommunityDetailPage(postId: post.postId));
                },
                onEdit: () {},
                onDelete: () {},
                onReport: () {},
              );
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
