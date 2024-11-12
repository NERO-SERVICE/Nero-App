import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/home/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/home/community/pages/community_search_app_bar.dart';
import 'package:nero_app/develop/home/community/widgets/post_item.dart';

class CommunitySearchPage extends StatelessWidget {
  final CommunityController _controller = Get.find<CommunityController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  CommunitySearchPage({Key? key}) : super(key: key) {
    _scrollController.addListener(() {
      // 스크롤이 바닥에 닿기 직전이면서 로딩 중이 아니고, 추가 게시물이 있는 경우에만 불러오기
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !_controller.isLoadingPosts.value &&
          _controller.hasMorePosts.value) {
        _controller.fetchFilteredPosts();
      }
    });
  }

  void _searchPosts() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _controller.setSearchQuery(query);
      _controller.fetchFilteredPosts(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommunitySearchAppBar(
        searchController: _searchController,
        onSearch: _searchPosts,
        onBack: () {
          _controller.fetchAllPosts(refresh: true);
          Navigator.of(context).pop();
        },
      ),
      body: Obx(() {
        if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
          // 처음 로딩 중일 때만 로딩 인디케이터를 중앙에 표시
          return Center(child: CustomLoadingIndicator());
        }

        if (_controller.posts.isEmpty) {
          return Center(
            child: Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: _controller.posts.length + 1,  // 추가 아이템 하나는 로딩 인디케이터용
          itemBuilder: (context, index) {
            if (index == _controller.posts.length) {
              // 게시물이 더 있을 경우만 하단 로딩 인디케이터 표시
              return Obx(() {
                if (_controller.hasMorePosts.value) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: CustomLoadingIndicator()),
                  );
                } else {
                  return SizedBox.shrink();  // 더 이상 로딩할 게시물이 없는 경우 빈 위젯 반환
                }
              });
            }

            final post = _controller.posts[index];
            return PostItem(
              post: post,
              onTap: () async {
                await Get.to(() => CommunityDetailPage(postId: post.postId));
                _controller.fetchFilteredPosts(refresh: true);
              },
              onLike: () => _controller.toggleLikePost(post.postId),
              onComment: () async {
                await Get.to(() => CommunityDetailPage(postId: post.postId));
                _controller.fetchFilteredPosts(refresh: true);
              },
            );
          },
        );
      }),
    );
  }
}
