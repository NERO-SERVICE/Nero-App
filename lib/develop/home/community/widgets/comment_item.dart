import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff2C2C2C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 닉네임 및 날짜
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    comment.nickname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${comment.createdAt.year}-${comment.createdAt.month.toString().padLeft(2, '0')}-${comment.createdAt.day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // 댓글 내용
              Text(
                comment.content,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),

              // 좋아요 및 수정/삭제
              Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          comment.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${comment.likeCount}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // 수정 및 삭제 버튼 (작성자만 보이도록 조건 추가 필요)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}