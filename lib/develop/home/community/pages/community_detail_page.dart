import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_community_divider.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  void initState() {
    super.initState();
    _controller.fetchPostDetail(widget.postId);

    _commentScrollController.addListener(() {
      if (_commentScrollController.position.pixels >=
          _commentScrollController.position.maxScrollExtent - 300 &&
          !_controller.isLoadingComments.value &&
          _controller.hasMoreComments.value) {
        _controller.fetchComments(widget.postId);
      }
    });
  }

  @override
  void dispose() {
    _commentScrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _showEditPostDialog(Post post) {
    final TextEditingController _editController =
    TextEditingController(text: post.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333), // 배경 색상 조정
          title: Text("게시물 수정", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _editController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "내용을 입력하세요",
              hintStyle: TextStyle(color: Color(0xffD9D9D9)), // 힌트 텍스트 색상 조정
              filled: true,
              fillColor: Color(0xff555555), // 입력창 배경 색상 조정
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.white), // 입력 텍스트 색상
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updatePost(
                    postId: post.postId,
                    content: updatedContent,
                  );
                  Get.back();
                }
              },
              child: Text("수정", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  void _showDeletePostDialog(Post post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333), // 배경 색상 조정
          title: Text("게시물 삭제", style: TextStyle(color: Colors.white)),
          content: Text("정말로 이 게시물을 삭제하시겠습니까?", style: TextStyle(color: Color(0xffD9D9D9))),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                _controller.deletePost(post.postId);
                Get.back(); // 다이얼로그 닫기
                Get.back(); // CommunityMainPage로 돌아가기
                _controller.fetchAllPosts(refresh: true); // 목록 갱신
              },
              child: Text("삭제", style: TextStyle(color: Color(0xffD8D8D8))),
            ),
          ],
        );
      },
    );
  }

  void _showEditCommentDialog(Comment comment) {
    final TextEditingController _editCommentController = TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff333333), // 배경 색상 조정
          title: Text("댓글 수정", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _editCommentController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "댓글을 입력하세요",
              hintStyle: TextStyle(color: Color(0xffD9D9D9)), // 힌트 텍스트 색상 조정
              filled: true,
              fillColor: Color(0xff555555), // 입력창 배경 색상 조정
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.white), // 입력 텍스트 색상
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editCommentController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updateComment(comment.commentId, updatedContent);
                  Get.back();
                }
              },
              child: Text("수정", style: TextStyle(color: Color(0xffD8D8D8))),
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
          backgroundColor: Color(0xff333333), // 배경 색상 조정
          title: Text("댓글 삭제", style: TextStyle(color: Colors.white)),
          content: Text("정말로 이 댓글을 삭제하시겠습니까?", style: TextStyle(color: Color(0xffD9D9D9))),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            ),
            TextButton(
              onPressed: () {
                _controller.deleteComment(comment.commentId);
                Get.back();
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
        backgroundColor: Colors.grey[200],
      );
    } else {
      return const CircleAvatar(
        radius: 16,
        backgroundImage: AssetImage('assets/develop/default_profile.png'),
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      color: Color(0xffFFFFFF),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${post.createdAt.year}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Color(0xff959595),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditPostDialog(post);
                                } else if (value == 'delete') {
                                  _showDeletePostDialog(post);
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('수정', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('삭제', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                              color: Color(0xffD9D9D9),
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
                            itemCount: post.images.length > 3 ? 3 : post.images.length,
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
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 300,
                                        height: 300,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
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
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                        if (_controller.isLoadingComments.value && _controller.comments.isEmpty) {
                          return Center(child: CustomLoadingIndicator());
                        }

                        if (_controller.comments.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(child: Text('댓글이 없습니다.', style: TextStyle(color: Colors.white))),
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
                              onLike: () => _controller.toggleLikeComment(comment.commentId),
                              onEdit: () => _showEditCommentDialog(comment),
                              onDelete: () => _showDeleteCommentDialog(comment),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 21),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submitComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffD8D8D8).withOpacity(0.4),
                        shape: CircleBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    );
  }
}
