import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/home/community/pages/community_app_bar.dart';
import 'package:nero_app/develop/home/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/home/community/pages/community_write_page.dart';
import 'package:nero_app/develop/home/community/widgets/post_item.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final CommunityController _controller = Get.find<CommunityController>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _controller.scrollOffsetMain.value,
    );

    _scrollController.addListener(() {
      _controller.scrollOffsetMain.value = _scrollController.offset;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500 &&
          !_controller.isLoadingPosts.value &&
          _controller.hasMorePosts.value) {
        _controller.fetchAllPosts();
      }
    });

    _controller.fetchAllPosts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommunityAppBar(title: '커뮤니티 마당'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(() {
            if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
              return Center(child: CustomLoadingIndicator());
            }

            if (_controller.posts.isEmpty) {
              return Center(child: Text('게시물이 없습니다.', style: TextStyle(color: Colors.white)));
            }

            return RefreshIndicator(
              onRefresh: () => _controller.fetchAllPosts(refresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _controller.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == _controller.posts.length) {
                    return _controller.hasMorePosts.value
                        ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CustomLoadingIndicator()),
                    )
                        : SizedBox.shrink();
                  }

                  final post = _controller.posts[index];
                  return PostItem(
                    post: post,
                    onTap: () async {
                      // 페이지로 이동하고 돌아온 후 위치를 복원
                      await Get.to(() => CommunityDetailPage(postId: post.postId));
                      // 현재 페이지 위치 유지
                      _scrollController.jumpTo(_controller.scrollOffsetMain.value);
                    },
                    onLike: () => _controller.toggleLikePost(post.postId),
                    onComment: () async {
                      await Get.to(() => CommunityDetailPage(postId: post.postId));
                      _scrollController.jumpTo(_controller.scrollOffsetMain.value);
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => CommunityWritePage());
          _controller.fetchAllPosts(refresh: true);
        },
        tooltip: "커뮤니티 글 작성",
        backgroundColor: Color(0xffD0EE17).withOpacity(0.5),
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
