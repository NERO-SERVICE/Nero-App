import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';

class DeletePostDialog extends StatelessWidget {
  final int postId;

  const DeletePostDialog({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommunityController _controller = Get.find<CommunityController>();

    void _deletePost() {
      _controller.deletePost(postId);
      Navigator.pop(context);
      Navigator.pop(context); // CommunityMainPage로
    }

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
                      "이 게시물을 삭제하시겠습니까?",
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
            onPressed: _deletePost,
            child: Text("예", style: TextStyle(color: Color(0xFFFF5A5A))),
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
