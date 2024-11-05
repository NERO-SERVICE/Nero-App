import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/multiful_image_view.dart';
import 'package:photo_manager/photo_manager.dart';

class CommunityWritePage extends StatefulWidget {
  @override
  _CommunityWritePageState createState() => _CommunityWritePageState();
}

class _CommunityWritePageState extends State<CommunityWritePage> {
  final CommunityController _controller = Get.find<CommunityController>();
  final TextEditingController _contentController = TextEditingController();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    try {
      // 이미지 선택 페이지로 이동
      var selectedAssets = await Get.to<List<AssetEntity>?>(
        MultifulImageView(
          initImages: [], // 초기 선택 이미지를 전달할 경우 사용
        ),
      );

      if (selectedAssets != null && selectedAssets.isNotEmpty) {
        // 선택된 AssetEntity를 File로 변환
        List<File> files = [];
        for (var asset in selectedAssets) {
          var file = await asset.file;
          if (file != null) {
            files.add(file);
          }
        }

        setState(() {
          _selectedImages = files;
        });

        // 컨트롤러에 이미지 추가
        _controller.addImages(files);
      }
    } catch (e) {
      print('이미지 선택 실패: $e');
      CustomSnackbar.show(
        context: context,
        message: '이미지 선택에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      File removedImage = _selectedImages.removeAt(index);
      // 컨트롤러에서 이미지 제거
      _controller.removeImage(removedImage);
    });
  }

  Future<void> _submitPost() async {
    String content = _contentController.text.trim();
    if (content.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: '게시물 내용을 입력해주세요.',
        isSuccess: false,
      );
      return;
    }

    try {
      await _controller.createPost(
        content: content,
        images: _selectedImages,
      );
      // 게시물 작성 후 UI 요소 초기화
      setState(() {
        _selectedImages.clear();
      });
      _contentController.clear();
      CustomSnackbar.show(
        context: context,
        message: '게시물이 생성되었습니다.',
        isSuccess: true,
      );
      Get.back(); // 게시물 작성 후 돌아가기
    } catch (e) {
      print('게시물 작성 실패: $e');
      CustomSnackbar.show(
        context: context,
        message: '게시물 작성에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  Widget _buildImagePreview() {
    return _selectedImages.isNotEmpty
        ? SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_selectedImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    )
        : SizedBox.shrink();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 작성', style: TextStyle(color: Colors.white),),
        actions: [
          Obx(
                () => GestureDetector(
              onTap: _controller.isPossibleSubmit.value ? _submitPost : null,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, right: 25),
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: _controller.isPossibleSubmit.value
                        ? Color(0xffD0EE17)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 게시물 내용 입력
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                '네로모임에 올릴 게시글 내용을 작성해주세요.\n(판매 금지 물품은 게시가 제한될 수 있어요)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                _controller.updateContent(value);
              },
            ),
            SizedBox(height: 16),

            // 이미지 선택 버튼
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed:
                  _selectedImages.length >= 10 ? null : _pickImages,
                  icon: Icon(Icons.photo),
                  label: Text('사진 추가', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 16),
                Text('${_selectedImages.length}/10'),
              ],
            ),
            SizedBox(height: 16),

            // 선택된 이미지 미리보기
            _buildImagePreview(),

            Spacer(),

            // 게시 버튼
            ElevatedButton(
              onPressed: _controller.isPossibleSubmit.value
                  ? _submitPost
                  : null,
              child: Text('게시', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: _controller.isPossibleSubmit.value
                    ? Color(0xffD0EE17)
                    : Colors.white, // 버튼 색상 변경
              ),
            ),
          ],
        ),
      ),
    );
  }
}
