import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_community_divider.dart';
import '../models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.onLike,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
  }) : super(key: key);

  void _showEditDeleteReportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          padding: EdgeInsets.all(16),
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
                  fixedSize: Size(150, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
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
                  fixedSize: Size(150, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
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
                  fixedSize: Size(150, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onReport();
                },
                child: Text(
                  "신고",
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          comment.nickname,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${comment.createdAt.year}-${comment.createdAt.month.toString().padLeft(2, '0')}-${comment.createdAt.day.toString().padLeft(2, '0')}',
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
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () => _showEditDeleteReportModal(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      comment.content,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          comment.isLiked
                              ? 'assets/develop/heart-on.svg'
                              : 'assets/develop/heart-off.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${comment.likeCount}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        CustomCommunityDivider(),
      ],
    );
  }
}
