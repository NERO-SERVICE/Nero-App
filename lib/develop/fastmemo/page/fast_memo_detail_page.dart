import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/fastmemo/controller/fastmemo_controller.dart';

import '../../common/components/custom_detail_app_bar.dart';
import '../../common/components/custom_loading_indicator.dart';

class FastMemoDetailPage extends StatefulWidget {
  @override
  _FastMemoDetailPageState createState() => _FastMemoDetailPageState();
}

class _FastMemoDetailPageState extends State<FastMemoDetailPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final FastmemoController controller = Get.find<FastmemoController>();
  final Map<int, bool> _selectedMap = {};
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late DateTime selectedDate;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args is DateTime) {
        selectedDate = args;
      } else {
        selectedDate = DateTime.now();
      }
      controller.setSelectedDate(selectedDate);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM월 dd일').format(selectedDate);

    return GestureDetector(
      onTap: () {
        if (_textFieldFocusNode.hasFocus) {
          _textFieldFocusNode.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomDetailAppBar(title: '$formattedDate 빠른 메모'),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/develop/fast-memo-background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _memoList()),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 24, left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          child: TextField(
                            controller: _textController,
                            focusNode: _textFieldFocusNode,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.titleColor,
                            ),
                            cursorColor: AppColors.inputTextColor,
                            decoration: InputDecoration(
                              hintText: '기록을 입력해주세요',
                              hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.hintTextColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              filled: true,
                              fillColor: Color(0xffD8D8D8).withOpacity(0.4),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 21),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_textController.text.isNotEmpty) {
                            await controller
                                .submitFastmemo(_textController.text);
                            analytics.logEvent(
                              name: 'fast_memo_detail_page_send_content',
                            );
                            _textController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffD8D8D8).withOpacity(0.4),
                          shape: CircleBorder(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/develop/send.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _actionButtons(),
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget _actionButtons() {
    if (_selectedMap.values.contains(true)) {
      _controller.forward();
      return Positioned(
        bottom: 150,
        right: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: _buildCustomActionButton(
                  'assets/develop/exit.svg', "선택 해제", _clearSelection,
                  backgroundColor: Color(0xffD8D8D8).withOpacity(0.4),
                  size: 30),
            ),
            SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: _buildCustomActionButton(
                  'assets/develop/check.svg', "체크 완료", _bulkUpdateIsChecked,
                  backgroundColor: AppColors.completeButtonColor, size: 30),
            ),
            SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: _buildCustomActionButton(
                  'assets/develop/delete.svg', "선택 삭제", _bulkDeleteFastmemo,
                  backgroundColor: AppColors.deleteButtonColor, size: 30),
            ),
          ],
        ),
      );
    } else {
      _controller.reverse();
      return SizedBox.shrink();
    }
  }

  Widget _buildCustomActionButton(
      String svgPath, String tooltip, VoidCallback onPressed,
      {required Color backgroundColor, required double size}) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      shape: CircleBorder(),
      child: SvgPicture.asset(
        svgPath,
        width: size,
        height: size,
      ),
    );
  }

  Future<void> _bulkUpdateIsChecked() async {
    List<int> selectedIds = _selectedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedIds.isNotEmpty) {
      bool confirmed = await _showConfirmationDialog(
        "선택한 메모를 수행하셨나요?",
        "체크하기",
        AppColors.completeButtonColor,
      );
      if (confirmed) {
        await controller.bulkUpdateIsChecked(true, selectedIds);
        analytics.logEvent(
          name: 'fast_memo_item_registered',
        );
        setState(() {
          _selectedMap.clear();
        });
      }
    }
  }

  Future<void> _bulkDeleteFastmemo() async {
    List<int> selectedIds = _selectedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedIds.isNotEmpty) {
      bool confirmed = await _showConfirmationDialog(
          "선택한 메모를 삭제하시겠습니까?", "삭제하기", AppColors.deleteButtonColor);
      if (confirmed) {
        await controller.bulkDeleteFastmemo(selectedIds);
        analytics.logEvent(
          name: 'fast_memo_item_deleted',
        );
        setState(() {
          _selectedMap.clear(); // 선택 해제
        });
      }
    }
  }

  Future<bool> _showConfirmationDialog(
      String content, String confirm, Color dialogColor) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.dialogBackgroundColor,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.dialogBackgroundColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Center(
                                child: Text(
                                  "취소",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: dialogColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Center(
                                child: Text(
                                  confirm,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedMap.clear();
    });
  }

  Widget _memoList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CustomLoadingIndicator());
      }
      if (controller.fastmemo.isEmpty) {
        return Center(
          child: Text(
            '해당 날짜에 메모가 없습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.primaryTextColor,
            ),
          ),
        );
      }
      return ListView.builder(
        reverse: true,
        itemCount: controller.fastmemo.length,
        itemBuilder: (context, index) {
          final log = controller.fastmemo[index];
          bool isSelected = _selectedMap[log.id] ?? false;
          return _memoListItem(log, isSelected, index);
        },
      );
    });
  }

  Widget _memoListItem(dynamic log, bool isSelected, int index) {
    bool isAlreadyChecked = log.isChecked;

    String iconPath = isSelected
        ? 'assets/develop/is-checked.svg'
        : isAlreadyChecked
            ? 'assets/develop/is-already-checked.svg'
            : 'assets/develop/is-not-checked.svg';
    Color containerColor = isSelected
        ? AppColors.memoSelectedButtonColor.withOpacity(0.5)
        : isAlreadyChecked
            ? AppColors.memoSelectedButtonColor.withOpacity(0.1)
            : AppColors.memoSelectedButtonColor.withOpacity(0.3);
    Color textColor = isSelected
        ? AppColors.memoSelectedTextColor
        : isAlreadyChecked
            ? AppColors.memoSelectedTextColor.withOpacity(0.1)
            : AppColors.memoSelectedTextColor;

    BorderSide borderSide = isSelected
        ? BorderSide(color: AppColors.titleColor, width: 1)
        : BorderSide(color: Colors.transparent, width: 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMap[log.id] = !isSelected;
          });
          analytics.logEvent(
            name: 'fastmemo_item_clicked',
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: containerColor,
            border:
                Border.all(color: borderSide.color, width: borderSide.width),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    log.content,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: null,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
