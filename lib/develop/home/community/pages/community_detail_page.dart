import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';

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
          title: Text("게시물 수정" , style: TextStyle(color: Colors.white),),
          content: TextField(
            controller: _editController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "내용을 입력하세요",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("취소", style: TextStyle(color: Colors.white),),
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
              child: Text("수정", style: TextStyle(color: Colors.white),),
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
          title: Text("게시물 삭제", style: TextStyle(color: Colors.white),),
          content: Text("정말로 이 게시물을 삭제하시겠습니까?", style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("취소", style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () {
                _controller.deletePost(post.postId);
                Get.back();
                Get.back(); // 상세 페이지에서 돌아가기
              },
              child: Text("삭제", style: TextStyle(color: Colors.white),),
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
          title: Text("댓글 수정", style: TextStyle(color: Colors.white),),
          content: TextField(
            controller: _editCommentController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "댓글을 입력하세요",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("취소", style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () {
                String updatedContent = _editCommentController.text.trim();
                if (updatedContent.isNotEmpty) {
                  _controller.updateComment(
                    commentId: comment.commentId,
                    content: updatedContent,
                  );
                  Get.back();
                }
              },
              child: Text("수정", style: TextStyle(color: Colors.white),),
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
          title: Text("댓글 삭제", style: TextStyle(color: Colors.white),),
          content: Text("정말로 이 댓글을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("취소", style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () {
                _controller.deleteComment(comment.commentId);
                Get.back();
              },
              child: Text("삭제", style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  void _submitComment() {
    String content = _commentController.text.trim();
    if (content.isNotEmpty) {
      _controller.createComment(postId: widget.postId, content: content);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세', style: TextStyle(color: Colors.white),),
      ),
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
                      // 게시물 정보
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 닉네임 및 날짜
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  post.nickname,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${post.createdAt.year}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // 게시물 내용
                            Text(
                              post.content,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),

                            // 사진 (최대 3개)
                            if (post.images.isNotEmpty)
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.images.length > 3
                                      ? 3
                                      : post.images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image.network(
                                        post.images[index],
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/develop/default.png',
                                            width: 300,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),

                            SizedBox(height: 16),

                            // 좋아요 및 댓글 수
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _controller.toggleLikePost(post.postId);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        post.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 4),
                                      Text('${post.likeCount}'),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 4),
                                      Text('${post.commentCount}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            // 수정 및 삭제 버튼 (작성자만)
                            // 작성자 확인은 서버에서 처리하므로 여기서는 예시로 버튼 표시
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showEditPostDialog(post);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeletePostDialog(post);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Divider(),

                      // 댓글 목록
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              '댓글',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (_controller.isLoadingComments.value &&
                            _controller.comments.isEmpty) {
                          return Center(child: CustomLoadingIndicator());
                        }

                        if (_controller.comments.isEmpty) {
                          return Center(child: Text('댓글이 없습니다.', style: TextStyle(color: Colors.white),));
                        }

                        return ListView.builder(
                          controller: _commentScrollController,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _controller.comments.length + 1,
                          itemBuilder: (context, index) {
                            if (index < _controller.comments.length) {
                              final comment = _controller.comments[index];
                              return CommentItem(
                                comment: comment,
                                onLike: () {
                                  _controller
                                      .toggleLikeComment(comment.commentId);
                                },
                                onEdit: () {
                                  _showEditCommentDialog(comment);
                                },
                                onDelete: () {
                                  _showDeleteCommentDialog(comment);
                                },
                              );
                            } else {
                              return Obx(() {
                                if (_controller.hasMoreComments.value) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:
                                        Center(child: CustomLoadingIndicator()),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              });
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // 댓글 입력 필드
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: '댓글을 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submitComment,
                      child: Text('게시', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
