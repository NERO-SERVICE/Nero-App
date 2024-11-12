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
  late final ScrollController _scrollController;

  CommunitySearchPage({Key? key}) : super(key: key) {
    // 스크롤 컨트롤러 초기화 및 위치 설정
    _scrollController = ScrollController(
      initialScrollOffset: _controller.scrollOffsetSearch.value,
    );

    _scrollController.addListener(() {
      // 스크롤 위치를 컨트롤러에 저장
      _controller.scrollOffsetSearch.value = _scrollController.offset;

      // 스크롤 위치가 끝에 도달했을 때 추가 데이터 로드
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500 &&
          !_controller.isLoadingPosts.value &&
          _controller.hasMorePosts.value) {
        _controller.fetchFilteredPosts();
      }
    });

    // 초기 데이터 로드
    _controller.fetchFilteredPosts(refresh: true);
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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(() {
            if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
              // 처음 로딩 중일 때만 로딩 인디케이터를 중앙에 표시
              return Center(child: CustomLoadingIndicator());
            }

            if (_controller.posts.isEmpty) {
              return Center(
                child:
                    Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.white)),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: _controller.posts.length + 1, // 추가 아이템 하나는 로딩 인디케이터용
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
                      return SizedBox.shrink(); // 더 이상 로딩할 게시물이 없는 경우 빈 위젯 반환
                    }
                  });
                }

                final post = _controller.posts[index];
                return PostItem(
                  post: post,
                  onTap: () async {
                    await Get.to(
                        () => CommunityDetailPage(postId: post.postId));
                    _controller.fetchFilteredPosts(refresh: true);
                  },
                  onLike: () => _controller.toggleLikePost(post.postId),
                  onComment: () async {
                    await Get.to(
                        () => CommunityDetailPage(postId: post.postId));
                    _controller.fetchFilteredPosts(refresh: true);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
