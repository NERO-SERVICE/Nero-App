import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_complete_button.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';

import 'report_option.dart';

class ReportDialog extends StatefulWidget {
  final int? postId;
  final int? commentId;

  const ReportDialog({Key? key, this.postId, this.commentId}) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final CommunityController _controller = Get.find<CommunityController>();
  final TextEditingController _reportController = TextEditingController();
  String _selectedReportType = '';

  // Define report options based on whether it's a post or a comment
  List<Map<String, String>> get reportOptions {
    if (widget.commentId == null) {
      return [
        {"title": "게시물 신고", "value": "post_report"},
        {"title": "게시물 차단", "value": "post_block"},
        {"title": "작성자 신고", "value": "author_report"},
      ];
    } else {
      return [
        {"title": "댓글 신고", "value": "comment_report"},
        {"title": "댓글 차단", "value": "comment_block"},
        {"title": "작성자 신고", "value": "author_report"},
      ];
    }
  }

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
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
                    // Centered Title
                    Center(
                      child: Text(
                        "신고하기",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Instruction Text
                    Text(
                      widget.commentId == null
                          ? "신고 유형을 선택하고,\n필요시 상세 설명을 추가해주세요."
                          : "신고 유형을 선택하고,\n필요시 상세 설명을 추가해주세요.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Report Options
                    Column(
                      children: reportOptions.map((option) {
                        bool isSelected =
                            _selectedReportType == option['value'];
                        return ReportOption(
                          title: option['title']!,
                          value: option['value']!,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedReportType = option['value']!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "상세 설명(*선택)",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _reportController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "ex. 욕설 및 비하",
                        hintStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.hintTextColor,
                        ),
                        filled: true,
                        fillColor: Color(0xff555555),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.titleColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomCompleteButton(
                        onPressed: _selectedReportType.isNotEmpty
                            ? () {
                          _controller.reportContent(
                            reportType: _selectedReportType,
                            postId: widget.postId,
                            commentId: widget.commentId,
                            description: _reportController.text,
                          );
                          Navigator.pop(context);
                        }
                            : null,
                        text: '전송하기',
                        isEnabled: _selectedReportType.isNotEmpty,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Close Button Positioned at Top-Right
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.titleColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}