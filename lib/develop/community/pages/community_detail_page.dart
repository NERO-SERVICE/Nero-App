import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_community_divider.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/community_controller.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../widgets/comment_item.dart';

class CommunityDetailPage extends StatefulWidget {
  final int postId;

  const CommunityDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  final CommunityController _controller = Get.find<CommunityController>();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _commentScrollController = ScrollController();
  final TextEditingController _reportController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  String _selectedReportType = '';
  final FocusNode _commentFocusNode = FocusNode(); // 키보드 자동 올라옴 방지

  @override
  void initState() {
    super.initState();
    _controller.fetchPostDetail(widget.postId);
  }

  @override
  void dispose() {
    _commentScrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // 화면을 탭했을 때 키보드를 해제하는 함수
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showCenterActionDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            decoration: BoxDecoration(
              color: AppColors.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.inactiveButtonColor,
                    fixedSize: Size(150, 40),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditPostDialog();
                  },
                  child: Text(
                    "수정",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.inactiveButtonColor,
                    fixedSize: Size(150, 40),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeletePostDialog();
                  },
                  child: Text(
                    "삭제",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFFFF5A5A),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.inactiveButtonColor,
                    fixedSize: Size(150, 40),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showReportDialog(widget.postId, null);
                  },
                  child: Text(
                    "신고/차단",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditPostDialog() {
    _editController.text = _controller.currentPost.value.content;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333),
          title: Text("게시물 수정", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _editController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "내용을 입력하세요",
              hintStyle: TextStyle(color: Color(0xffD9D9D9)),
              filled: true,
              fillColor: Color(0xff555555),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updatePost(
                    postId: widget.postId,
                    content: updatedContent,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("수정 완료", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  void _showDeletePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333),
          title: Text("게시물 삭제", style: TextStyle(color: Colors.white)),
          content: Text(
            "정말로 이 게시물을 삭제하시겠습니까?",
            style: TextStyle(
              color: Color(0xffD9D9D9),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                _controller.deletePost(widget.postId);
                Navigator.pop(context);
                Get.snackbar("알림", "삭제를 완료했습니다.");
              },
              child: Text("예", style: TextStyle(color: Color(0xFFFF5A5A))),
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

  // 신고 다이얼로그
  void _showReportDialog(int? postId, int? commentId) {
    _selectedReportType = ''; // 신고 타입 초기화
    _reportController.clear(); // 상세 설명 초기화

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
                  _buildReportOption("댓글 신고", "comment_report", setState),
                  _buildReportOption("댓글 차단", "comment_block", setState),
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
                    commentId: commentId,
                    description: _reportController.text,
                  );
                  Navigator.pop(context);
                } else {
                  // 신고 타입을 선택하지 않은 경우 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("신고 유형을 선택해주세요.")),
                  );
                }
              },
              child: Text("전송하기", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  void _showEditCommentDialog(Comment comment) {
    final TextEditingController _editCommentController =
        TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333),
          title: Text("댓글 수정", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _editCommentController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "댓글을 입력하세요",
              hintStyle: TextStyle(color: Color(0xffD9D9D9)),
              filled: true,
              fillColor: Color(0xff555555),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editCommentController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updateComment(comment.commentId, updatedContent);
                  Navigator.pop(context);
                }
              },
              child: Text("수정 완료", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCommentDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333),
          title: Text("댓글 삭제", style: TextStyle(color: Colors.white)),
          content: Text("정말로 이 댓글을 삭제하시겠습니까?",
              style: TextStyle(color: Color(0xffD9D9D9))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                _controller.deleteComment(comment.commentId);
                Navigator.pop(context);
              },
              child: Text("삭제", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  void _submitComment() {
    String content = _commentController.text.trim();
    if (content.isNotEmpty) {
      _controller.createComment(widget.postId, content).then((_) {
        _controller.fetchComments(widget.postId); // 댓글 목록 갱신
        _commentController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  Widget _buildProfileImage(Post post) {
    if (post.profileImageUrl != null && post.profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: CachedNetworkImageProvider(post.profileImageUrl!),
        backgroundColor: AppColors.primaryTextColor,
      );
    } else {
      return const CircleAvatar(
        radius: 16,
        backgroundImage: AssetImage('assets/develop/default_profile.png'),
        backgroundColor: AppColors.primaryTextColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard, // 화면 외부를 탭했을 때 키보드 해제
      child: Scaffold(
        appBar: CustomDetailAppBar(title: '커뮤니티 마당'),
        body: Obx(
          () {
            if (_controller.isLoadingPostDetail.value) {
              return Center(child: CustomLoadingIndicator());
            }

            final Post post = _controller.currentPost.value;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildProfileImage(post),
                                    SizedBox(width: 12),
                                    Text(
                                      post.nickname,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.titleColor,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${post.createdTimeAgo}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: AppColors.hintTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert,
                                  color: AppColors.titleColor),
                              onPressed: _showCenterActionDialog,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              post.content,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (post.images.isNotEmpty)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: post.images.length > 3
                                  ? 3
                                  : post.images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.0,
                                    left: index == 0 ? 32.0 : 0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: post.images[index],
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 300,
                                          height: 300,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/develop/default.png',
                                        width: 300,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _controller.toggleLikePost(post.postId);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      post.isLiked
                                          ? 'assets/develop/heart-on.svg'
                                          : 'assets/develop/heart-off.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${post.likeCount}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xffD9D9D9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/develop/comment_icon.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${post.commentCount}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xffD9D9D9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        CustomCommunityDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Row(
                            children: [
                              Text(
                                '댓글',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomCommunityDivider(),
                        Obx(() {
                          if (_controller.isLoadingComments.value &&
                              _controller.comments.isEmpty) {
                            return Center(child: CustomLoadingIndicator());
                          }

                          if (_controller.comments.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                  child: Text('댓글이 없습니다.',
                                      style: TextStyle(color: Colors.white))),
                            );
                          }

                          return ListView.builder(
                            controller: _commentScrollController,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _controller.comments.length,
                            itemBuilder: (context, index) {
                              final comment = _controller.comments[index];
                              return CommentItem(
                                comment: comment,
                                onLike: () => _controller
                                    .toggleLikeComment(comment.commentId),
                                onEdit: () => _showEditCommentDialog(comment),
                                onDelete: () =>
                                    _showDeleteCommentDialog(comment),
                                onReport: () =>
                                    _showReportDialog(null, comment.commentId),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 24, left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          child: TextField(
                            controller: _commentController,
                            focusNode: _commentFocusNode,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xffFFFFFF),
                            ),
                            cursorColor: Color(0xffD9D9D9),
                            decoration: InputDecoration(
                              hintText: '댓글을 입력하세요',
                              hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xffD9D9D9),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              filled: true,
                              fillColor: Color(0xffD8D8D8).withOpacity(0.4),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 21),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _commentFocusNode.unfocus(); // 전송 후 키보드 닫기
                          _submitComment();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffD8D8D8).withOpacity(0.4),
                          shape: CircleBorder(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/develop/send.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
