import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';

class EditPostDialog extends StatefulWidget {
  final int postId;
  final String initialContent;

  const EditPostDialog({
    Key? key,
    required this.postId,
    required this.initialContent,
  }) : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  final CommunityController _controller = Get.find<CommunityController>();
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _submitEdit() {
    String updatedContent = _editController.text.trim();
    if (updatedContent.isNotEmpty) {
      _controller.updatePost(
        postId: widget.postId,
        content: updatedContent,
      );
      Navigator.pop(context);
    } else {
      Get.snackbar("경고", "내용을 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "게시물 수정",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _editController,
                      maxLines: 5,
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
                  ],
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("취소", style: TextStyle(color: Color(0xffD9D9D9))),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              minimumSize: Size(80, 40),
            ),
          ),
          TextButton(
            onPressed: _submitEdit,
            child: Text("완료", style: TextStyle(color: Color(0xffD0EE17))),
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
