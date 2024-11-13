import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/community_search_app_bar.dart';
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

  void _showReportDialog(BuildContext context, int? postId) {
    final TextEditingController _reportController = TextEditingController();
    _selectedReportType = ''; // Initialize as empty

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333),
          title: Text("신고/차단", style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildReportOption("게시물 신고", "post_report", setState),
                  _buildReportOption("게시물 차단", "post_block", setState),
                  _buildReportOption("작성자 신고", "author_report", setState),
                  SizedBox(height: 10),
                  TextField(
                    controller: _reportController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "상세 설명 (선택)",
                      filled: true,
                      fillColor: Color(0xff555555),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                if (_selectedReportType.isNotEmpty) {
                  _controller.reportContent(
                    reportType: _selectedReportType,
                    postId: postId,
                    description: _reportController.text,
                  );
                  Navigator.pop(context);
                  _reportController.clear(); // Clear the TextField
                } else {
                  // Optionally, show a message prompting the user to select a report type
                  print('Please select a report type');
                }
              },
              child: Text("전송하기", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  // 신고 옵션 버튼을 생성하는 위젯
  Widget _buildReportOption(String title, String value, StateSetter setState) {
    bool isSelected = _selectedReportType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportType = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xffD0EE17).withOpacity(0.2)
              : Color(0xff1C1B1B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xffD0EE17) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
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
                    _showReportDialog(context, post.postId); // 신고 다이얼로그 호출
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
