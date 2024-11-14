import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/appbar/community_app_bar.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/community_write_page.dart';
import 'package:nero_app/develop/community/pages/report/report_dialog.dart';
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
                    onReport: () => _showReportDialog(post.postId),
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
