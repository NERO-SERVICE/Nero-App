import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';

class CommunityWritePage extends StatefulWidget {
  @override
  _CommunityWritePageState createState() => _CommunityWritePageState();
}

class _CommunityWritePageState extends State<CommunityWritePage> {
  final CommunityController _controller = Get.find<CommunityController>();
  final TextEditingController _contentController = TextEditingController();
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  final List<String> types = ['인증', '습관', '일기', '고민', '정보'];

  @override
  void initState() {
    super.initState();
    _controller.selectedType.value = '';
  }

  Future<void> _pickImages() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        setState(() {
          _selectedImages = [imageFile]; // 한 장의 이미지만 선택
        });

        _controller.addImages([imageFile]);
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
      _controller.removeImage(removedImage);
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Widget _buildTypeSelector() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: DropdownButton<String>(
          value: _controller.selectedType.value.isEmpty
              ? null
              : _controller.selectedType.value,
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '유형',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, color: AppColors.primaryTextColor),
            ],
          ),
          dropdownColor: AppColors.secondaryTextColor,
          elevation: 0,
          borderRadius: BorderRadius.circular(16),
          items: types.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.primaryTextColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _controller.updateSelectedType(value);
            }
          },
          icon: SizedBox.shrink(),
          selectedItemBuilder: (BuildContext context) {
            return types.map((type) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _controller.selectedType.value.isEmpty
                        ? '유형'
                        : '#${_controller.selectedType.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: AppColors.primaryTextColor),
                ],
              );
            }).toList();
          },
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xffD9D9D9),
          ),
          underline: Container(
            height: 1,
            color: Colors.transparent,
          ),
        ),
      );
    });
  }

  Future<void> _submitPost() async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
    });

    String content = _contentController.text.trim();
    if (content.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: '게시물 내용을 입력해주세요.',
        isSuccess: false,
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      await _controller.createPost(
        content: content,
        images: _selectedImages,
      );
      setState(() {
        _selectedImages.clear();
        _isSubmitting = false;
      });
      _contentController.clear();
      CustomSnackbar.show(
        context: context,
        message: '게시물이 생성되었습니다.',
        isSuccess: true,
      );
      Get.back(result: true);
    } catch (e) {
      print('게시물 작성 실패: $e');
      setState(() {
        _isSubmitting = false;
      });
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
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          toolbarHeight: 56.0,
          titleSpacing: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                '게시물 작성',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Obx(
                () => _isSubmitting
                    ? Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CustomLoadingIndicator(),
                        ),
                      )
                    : TextButton(
                        onPressed:
                            (_controller.isPossibleSubmit.value && !_isSubmitting)
                                ? _submitPost
                                : null,
                        child: Text(
                          '완료',
                          style: TextStyle(
                            color: (_controller.isPossibleSubmit.value &&
                                    !_isSubmitting)
                                ? Color(0xffD0EE17)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          minimumSize: Size(80, 40),
                        ),
                      ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Row(
                children: [
                  _buildTypeSelector(),
                ],
              ),
              TextField(
                controller: _contentController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: '게시글 문구를 입력해주세요',
                  hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.hintTextColor,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _controller.updateContent(value);
                  _controller.isPossibleSubmit.value = value.isNotEmpty;
                },
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xffFFFFFF),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _selectedImages.length >= 1 ? null : _pickImages,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/develop/photo_gallery_icon.svg',
                      height: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '사진 선택',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '${_selectedImages.length}/1',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildImagePreview(),
              SizedBox(height: 30),
              Text(
                '''커뮤니티 이용 주의사항''',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xffD9D9D9),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '''1. 상호 존중: 모든 사용자는 서로를 존중하고 차별적이거나 공격적인 언어를 사용하지 않아야 합니다. 의견은 자유롭게 표현하되, 타인에게 불쾌감을 주는 표현은 삼가 주세요.\n''',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffD9D9D9),
                ),
              ),
              Text(
                '''2. 개인정보 보호: 개인정보(전화번호, 주소, 신분증 정보 등)를 포함한 게시물은 금지됩니다. 다른 사용자의 개인정보를 침해하지 않도록 주의해 주세요.\n''',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffD9D9D9),
                ),
              ),
              Text(
                '''3. 부적절한 콘텐츠 금지: 폭력적, 혐오적, 선정적이거나 불법적인 콘텐츠는 허용되지 않습니다. 또한, 외부 링크를 통한 불법 콘텐츠 유도는 금지됩니다.\n''',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffD9D9D9),
                ),
              ),
              Text(
                '''4. 스팸 및 광고 제한: 상업적 목적으로 작성된 글과 반복적인 스팸 게시물은 삭제될 수 있습니다.\n''',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffD9D9D9),
                ),
              ),
              Text(
                '''5. 건전한 대화 유도: 커뮤니티는 서로의 지식과 경험을 나누는 공간입니다. 잘못된 정보 유포를 방지하기 위해, 항상 신뢰할 수 있는 정보를 바탕으로 대화해 주세요.''',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffD9D9D9),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
