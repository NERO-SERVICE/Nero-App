import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.onLike,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  void _showEditDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text(
                  '수정',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  '삭제',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
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
            const SizedBox(height: 16),
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
                        const SizedBox(width: 5),
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
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      _showEditDeleteDialog(context);
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
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                          width: 16,
                          height: 16,
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
        Divider(color: Color(0xffD9D9D9)),
      ],
    );
  }
}
