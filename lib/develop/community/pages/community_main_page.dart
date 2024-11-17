import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/appbar/community_app_bar.dart';
import 'package:nero_app/develop/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/community/pages/dialog/report_dialog.dart';
import 'package:nero_app/develop/community/widgets/post_item.dart';
import 'package:nero_app/main.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> with RouteAware {
  final CommunityController _controller = Get.find<CommunityController>();
  late final ScrollController _scrollController;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver에 등록
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    // RouteObserver에서 해제
    routeObserver.unsubscribe(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    if (_controller.posts.isEmpty) {
      _controller.fetchAllPosts(refresh: true);
    } else {
      _scrollController.jumpTo(_controller.scrollOffsetMain.value);
    }
  }

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
              child:
                  Text("취소", style: TextStyle(color: AppColors.hintTextColor)),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updatePost(
                      postId: postId, content: updatedContent);
                  Navigator.pop(context);
                }
              },
              child: Text("수정 완료",
                  style: TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  void _showDeletePostDialog(int postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.dialogBackgroundColor,
          title: Text("게시물 삭제", style: TextStyle(color: Colors.white)),
          content: Text("정말로 이 게시물을 삭제하시겠습니까?",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _controller.deletePost(postId);
                Navigator.pop(context);
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
      appBar: CommunityAppBar(title: '커뮤니티'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(() {
            if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
              return Center(child: CustomLoadingIndicator());
            }

            if (_controller.posts.isEmpty) {
              return Center(
                child: Text(
                  '게시물이 없습니다.',
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
                      await Get.to(
                          () => CommunityDetailPage(postId: post.postId));
                      _scrollController
                          .jumpTo(_controller.scrollOffsetMain.value);
                    },
                    onLike: () => _controller.toggleLikePost(post.postId),
                    onComment: () async {
                      await Get.to(
                          () => CommunityDetailPage(postId: post.postId));
                      _scrollController
                          .jumpTo(_controller.scrollOffsetMain.value);
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
    );
  }
}
