import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/widgets/post_item.dart';

class CommunityLikedPostsPage extends StatefulWidget {
  @override
  _CommunityLikedPostsPageState createState() =>
      _CommunityLikedPostsPageState();
}

class _CommunityLikedPostsPageState extends State<CommunityLikedPostsPage> {
  final CommunityController _controller = Get.find<CommunityController>();
  late final ScrollController _scrollController;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchLikedPosts(refresh: true);
    });

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 500 &&
          !_controller.isLoadingLikedPosts.value &&
          _controller.hasMoreLikedPosts.value) {
        _controller.fetchLikedPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'CommunityLikedPostsPage',
      screenClass: 'CommunityLikedPostsPage',
    );
    return Scaffold(
      appBar: CustomDetailAppBar(title: '좋아요 누른 게시물'),
      body: Obx(() {
        if (_controller.isLoadingLikedPosts.value &&
            _controller.likedPosts.isEmpty) {
          return Center(child: CustomLoadingIndicator());
        }

        if (_controller.likedPosts.isEmpty) {
          return Center(
            child: Text(
              '좋아요 한 게시물이 없습니다.',
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
          onRefresh: () => _controller.fetchLikedPosts(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _controller.likedPosts.length + 1,
            itemBuilder: (context, index) {
              if (index == _controller.likedPosts.length) {
                return _controller.hasMoreLikedPosts.value
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CustomLoadingIndicator()),
                      )
                    : SizedBox.shrink();
              }

              final post = _controller.likedPosts[index];
              return PostItem(
                post: post,
                onTap: () async {
                  await Get.to(() => CommunityDetailPage(postId: post.postId));
                },
                onLike: () {},
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
