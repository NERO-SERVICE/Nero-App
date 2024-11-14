import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/appbar/community_search_app_bar.dart';
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

  String _selectedReportType = ''; // 클래스 멤버 변수로 선언

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
              return Center(child: CustomLoadingIndicator());
            }

            if (_controller.posts.isEmpty) {
              return Center(
                child: Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.white)),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: _controller.posts.length + 1,
              itemBuilder: (context, index) {
                if (index == _controller.posts.length) {
                  if (_controller.hasMorePosts.value) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CustomLoadingIndicator()),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }

                final post = _controller.posts[index];
                return PostItem(
                  post: post,
                  onTap: () async {
                    // 페이지 이동 후 결과로 스크롤 위치를 받아 복원
                    final offset = await Get.to(() => CommunityDetailPage(postId: post.postId));
                    if (offset != null) {
                      _scrollController.jumpTo(offset); // 스크롤 위치 복원
                    }
                    _controller.fetchFilteredPosts(refresh: true);
                  },
                  onLike: () => _controller.toggleLikePost(post.postId),
                  onComment: () async {
                    final offset = await Get.to(() => CommunityDetailPage(postId: post.postId));
                    if (offset != null) {
                      _scrollController.jumpTo(offset);
                    }
                    _controller.fetchFilteredPosts(refresh: true);
                  },
                  onEdit: () {
                    print('게시물 수정: ${post.postId}');
                  },
                  onDelete: () {
                    print('게시물 삭제: ${post.postId}');
                  },
                  onReport: () {
                    _showReportDialog(post.postId);
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
