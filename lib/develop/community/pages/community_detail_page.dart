import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_community_divider.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/community/pages/community_main_page.dart';
import 'package:nero_app/develop/community/pages/dialog/delete_comment_dialog.dart';
import 'package:nero_app/develop/community/pages/dialog/delete_post_dialog.dart';
import 'package:nero_app/develop/community/pages/dialog/edit_comment_dialog.dart';
import 'package:nero_app/develop/community/pages/dialog/edit_post_dialog.dart';
import 'package:nero_app/develop/community/pages/dialog/report_dialog.dart';
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

  final FocusNode _commentFocusNode = FocusNode(); // 키보드 자동 올라옴 방지
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  late Worker _blockWorker;

  @override
  void initState() {
    super.initState();
    _controller.fetchPostDetail(widget.postId);

    // isBlocked 및 blockedType 감지하여 DetailPage 종료 또는 메인 페이지로 이동
    _blockWorker = ever(_controller.isBlocked, (bool blocked) {
      if (blocked) {
        if (_controller.blockedType.value == 'post') {
          Navigator.pop(context);
        } else if (_controller.blockedType.value == 'comment') {
        }
        // 차단 후 플래그 초기화
        _controller.isBlocked.value = false;
        _controller.blockedType.value = '';
      }
    });
  }

  @override
  void dispose() {
    _blockWorker.dispose();
    _commentScrollController.dispose();
    _commentController.dispose();

    if (Get.previousRoute == '/CommunityMainPage') {
      _controller.scrollOffsetMain.value = _commentScrollController.offset;
    } else if (Get.previousRoute == '/CommunitySearchPage') {
      _controller.scrollOffsetSearch.value = _commentScrollController.offset;
    }

    super.dispose();
  }

  // 화면을 탭했을 때 키보드를 해제하는 함수
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showCenterActionDialog() {
    final Post post = _controller.currentPost.value;
    final bool isAuthor = post.isAuthor;

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      elevation: 0,
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
                if (isAuthor) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.inactiveButtonColor,
                      fixedSize: Size(150, 40),
                      elevation: 0,
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
                      elevation: 0,
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
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.inactiveButtonColor,
                    fixedSize: Size(150, 40),
                    elevation: 0,
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

  void _showReportDialog(int? postId, int? commentId) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return ReportDialog(
          postId: postId,
          commentId: commentId,
        );
      },
    );

    if (result == 'blocked_post') {
      Navigator.pop(context);
    }
  }

  void _showEditPostDialog() {
    final postContent = _controller.currentPost.value.content;
    showDialog(
      context: context,
      builder: (context) {
        return EditPostDialog(
          postId: widget.postId,
          initialContent: postContent,
        );
      },
    );
  }

  void _showDeletePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DeletePostDialog(postId: widget.postId);
      },
    );
  }

  void _showEditCommentDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (context) {
        return EditCommentDialog(comment: comment);
      },
    );
  }

  void _showDeleteCommentDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteCommentDialog(comment: comment);
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
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(post.profileImageUrl!),
        backgroundColor: AppColors.primaryTextColor,
      );
    } else {
      return const CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('assets/develop/default_profile.png'),
        backgroundColor: AppColors.primaryTextColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'CommunityDetailPage',
      screenClass: 'CommunityDetailPage',
    );

    double imageWidth = MediaQuery.of(context).size.width - 64;

    return GestureDetector(
      onTap: _dismissKeyboard, // 화면 외부를 탭했을 때 키보드 해제
      child: Scaffold(
        appBar: CustomDetailAppBar(title: '게시물'),
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
                                  children: [
                                    _buildProfileImage(post),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.nickname,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xffFFFFFF),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '${post.createdTimeAgo}',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Color(0xff959595),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/develop/more.svg',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              onPressed: _showCenterActionDialog,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
                            height: imageWidth, // Use the dynamic imageWidth
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: post.images.length > 3 ? 3 : post.images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.0,
                                    left: index == 0 ? 32.0 : 0, // Maintain left padding for the first image
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: post.images[index],
                                      width: imageWidth,
                                      height: imageWidth,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: imageWidth,
                                          height: imageWidth,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        'assets/develop/default.png',
                                        width: imageWidth,
                                        height: imageWidth,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 6),
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
                              SizedBox(width: 16),
                              if (post.type != null)
                                Row(
                                  children: [
                                    Text(
                                      '#${_controller.translateTypeToKorean(post.type)}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.hashtagTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
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
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
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
