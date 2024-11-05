import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/home/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/home/community/pages/community_write_page.dart';
import 'package:nero_app/develop/home/community/widgets/post_item.dart';

class CommunityMainPage extends StatelessWidget {
  final CommunityController _controller = Get.find<CommunityController>();
  final ScrollController _scrollController = ScrollController();

  CommunityMainPage({Key? key}) : super(key: key) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !_controller.isLoadingPosts.value &&
          _controller.hasMorePosts.value) {
        _controller.fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDetailAppBar(title: '커뮤니티 마당'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(
                () {
              if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
                return Center(child: CustomLoadingIndicator());
              }

              if (_controller.posts.isEmpty) {
                return Center(
                    child: Text(
                      '게시물이 없습니다.',
                      style: TextStyle(color: Colors.white),
                    ));
              }

              return RefreshIndicator(
                onRefresh: () => _controller.fetchPosts(refresh: true),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _controller.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _controller.posts.length) {
                      final post = _controller.posts[index];
                      return PostItem(
                        post: post,
                        onTap: () async {
                          await Get.to(
                                  () => CommunityDetailPage(postId: post.postId));
                          _controller.fetchPosts(refresh: true);
                        },
                        onLike: () {
                          _controller.toggleLikePost(post.postId);
                        },
                        onComment: () async {
                          await Get.to(
                                  () => CommunityDetailPage(postId: post.postId));
                          _controller.fetchPosts(refresh: true);
                        },
                      );
                    } else {
                      return Obx(() {
                        if (_controller.hasMorePosts.value) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: CustomLoadingIndicator()),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      });
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => CommunityWritePage());
          _controller.fetchPosts(refresh: true);
        },
        tooltip: "커뮤니티 글 작성",
        backgroundColor: Color(0xffD0EE17).withOpacity(0.5),
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
