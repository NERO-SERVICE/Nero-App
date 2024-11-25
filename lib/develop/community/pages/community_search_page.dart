import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/appbar/community_search_app_bar.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/dialog/report_dialog.dart';
import 'package:nero_app/develop/community/widgets/post_item.dart';

class CommunitySearchPage extends StatefulWidget {
  @override
  _CommunitySearchPageState createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends State<CommunitySearchPage> {
  final CommunityController _controller = Get.find<CommunityController>();
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchFilteredPosts(refresh: true);
    });

    _scrollController = ScrollController(
      initialScrollOffset: _controller.scrollOffsetSearch.value,
    );

    _scrollController.addListener(() {
      _controller.scrollOffsetSearch.value = _scrollController.offset;

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 500 &&
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
    } else {
      // 검색어가 비어있으면 게시물 목록을 클리어
      _controller.clearSearch();
    }
  }

  void _showReportDialog(int? postId) {
    showDialog(
      context: context,
      builder: (context) {
        return ReportDialog(
          postId: postId,
          commentId: null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'CommunitySearchPage',
      screenClass: 'CommunitySearchPage',
    );
    return Scaffold(
      appBar: CommunitySearchAppBar(
        searchController: _searchController,
        onSearch: _searchPosts,
        onBack: () {
          // 검색어가 없거나 결과가 없을 경우에도 상태 복구
          if (_controller.searchQuery.isEmpty || _controller.posts.isEmpty) {
            _controller.fetchAllPosts(refresh: true);
          }
          Navigator.of(context).pop();
        },
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(() {
            if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
              return Center(child: CustomLoadingIndicator());
            }

            if (_controller.searchQuery.isEmpty) {
              // 검색어가 입력되지 않은 상태일 때 메시지 표시
              return Center(
                child: Text(
                  '검색어를 입력해주세요.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xffD9D9D9),
                    ),
                ),
              );
            }

            if (_controller.posts.isEmpty) {
              return Center(
                child: Text(
                  '검색 결과가 없습니다.',
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
              onRefresh: () => _controller.fetchFilteredPosts(refresh: true),
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
                      await Get.to(
                          () => CommunityDetailPage(postId: post.postId));
                      _scrollController
                          .jumpTo(_controller.scrollOffsetSearch.value);
                    },
                    onLike: () => _controller.toggleLikePost(post.postId),
                    onComment: () async {
                      await Get.to(
                          () => CommunityDetailPage(postId: post.postId));
                      _scrollController
                          .jumpTo(_controller.scrollOffsetSearch.value);
                    },
                    onEdit: () {
                      print('게시물 수정: ${post.postId}');
                    },
                    onDelete: () {
                      print('게시물 삭제: ${post.postId}');
                    },
                    onReport: () => _showReportDialog(post.postId),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
