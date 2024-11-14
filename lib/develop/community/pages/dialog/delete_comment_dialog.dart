import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import '../../models/comment.dart';

class DeleteCommentDialog extends StatelessWidget {
  final Comment comment;

  const DeleteCommentDialog({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommunityController _controller = Get.find<CommunityController>();

    void _deleteComment() {
      _controller.deleteComment(comment.commentId);
      Navigator.pop(context);
    }
    //
    // return AlertDialog(
    //   backgroundColor: Color(0xff333333),
    //   title: Text("댓글 삭제", style: TextStyle(color: Colors.white)),
    //   content: Text(
    //     "정말로 이 댓글을 삭제하시겠습니까?",
    //     style: TextStyle(color: Color(0xffD9D9D9)),
    //   ),
    //   actions: [
    //     TextButton(
    //       onPressed: () => Navigator.pop(context),
    //       child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
    //     ),
    //     TextButton(
    //       onPressed: _deleteComment,
    //       child: Text("삭제", style: TextStyle(color: Color(0xffD8D8D8))),
    //     ),
    //   ],
    // );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.backgroundAppBarColor,
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "이 댓글을 삭제하시겠습니까?",
                      style: TextStyle(color: Color(0xffD9D9D9)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "취소",
              style: TextStyle(color: Color(0xffD9D9D9)),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              minimumSize: Size(80, 40),
            ),
          ),
          TextButton(
            onPressed: _deleteComment,
            child: Text(
              "예",
              style: TextStyle(color: Color(0xFFFF5A5A)),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              minimumSize: Size(80, 40),
            ),
          ),
        ],
      ),
    );
  }
}