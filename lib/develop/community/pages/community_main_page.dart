import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_app_bar.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/community_write_page.dart';
import 'package:nero_app/develop/community/widgets/post_item.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final CommunityController _controller = Get.find<CommunityController>();
  late final ScrollController _scrollController;

  String _selectedReportType = ''; // 클래스 멤버 변수로 선언

  @override
  void initState() {
    super.initState();
    // 페이지 초기 접근 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchAllPosts(refresh: true);
    });

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
  }

  // 게시물 수정 다이얼로그
  void _showEditPostDialog(int postId) {
    final TextEditingController _editController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.dialogBackgroundColor,
          title: Text("게시물 수정"),
          content: TextField(
            controller: _editController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "내용을 입력하세요",
              filled: true,
              fillColor: AppColors.hintTextColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: AppColors.hintTextColor)),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updatePost(postId: postId, content: updatedContent);
                  Navigator.pop(context);
                }
              },
              child: Text("수정 완료", style: TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // 게시물 삭제 다이얼로그
  void _showDeletePostDialog(int postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.dialogBackgroundColor,
          title: Text("게시물 삭제", style: TextStyle(color: Colors.white)),
          content: Text("정말로 이 게시물을 삭제하시겠습니까?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _controller.deletePost(postId);
                Navigator.pop(context);
                Get.snackbar("알림", "삭제가 완료되었습니다.", snackPosition: SnackPosition.BOTTOM);
              },
              child: Text("삭제", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
                      await Get.to(() => CommunityDetailPage(postId: post.postId));
                      _scrollController.jumpTo(_controller.scrollOffsetMain.value);
                    },
                    onLike: () => _controller.toggleLikePost(post.postId),
                    onComment: () async {
                      await Get.to(() => CommunityDetailPage(postId: post.postId));
                      _scrollController.jumpTo(_controller.scrollOffsetMain.value);
                    },
                    onEdit: () => _showEditPostDialog(post.postId),
                    onDelete: () => _showDeletePostDialog(post.postId),
                    onReport: () => _showReportDialog(context, post.postId),
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
