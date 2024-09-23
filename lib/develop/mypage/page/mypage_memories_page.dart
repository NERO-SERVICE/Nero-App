import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/layout/common_layout.dart';
import 'package:nero_app/develop/memories/controller/memories_controller.dart';

class MypageMemoriesPage extends StatefulWidget {
  const MypageMemoriesPage({super.key});

  @override
  State<MypageMemoriesPage> createState() => _MypageMemoriesPageState();
}

class _MypageMemoriesPageState extends State<MypageMemoriesPage> {
  final MemoriesController _memoriesController = Get.put(MemoriesController());
  final TextEditingController _textController = TextEditingController();
  final Map<int, bool> _selectedMap = {}; // 선택된 아이템의 인덱스를 저장

  @override
  void initState() {
    super.initState();
    _memoriesController.loadMemories();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _bulkDeleteItems() async {
    List<int> selectedIndices = _selectedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedIndices.isNotEmpty) {
      bool confirmed = await _showConfirmationDialog(
          "선택한 아이템을 삭제하시겠습니까?", "삭제하기", Color(0xffFF5A5A).withOpacity(0.4));
      if (confirmed) {
        await _memoriesController.removeItemsAtIndices(selectedIndices);
        setState(() {
          _selectedMap.clear();
        });
      }
    }
  }

  Future<bool> _showConfirmationDialog(
      String content, String confirm, Color dialogColor) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
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
                        color: Color(0xffFFFFFF),
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
                            color: Color(0xffD8D8D8).withOpacity(0.3),
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
                                  color: Colors.white,
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
                                  color: Colors.white,
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
        );
      },
    );
  }

  Widget _memoriesList() {
    return Obx(() {
      if (_memoriesController.memoriesList.isEmpty ||
          _memoriesController.memoriesList[0].items == null ||
          _memoriesController.memoriesList[0].items!.isEmpty) {
        return Center(
          child: Text(
            '등록된 챙길거리가 없습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xffD9D9D9),
            ),
          ),
        );
      }
      final items = _memoriesController.memoriesList[0].items!;
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final itemContent = items[index];
          bool isSelected = _selectedMap[index] ?? false;
          return _memoryListItem(itemContent, isSelected, index);
        },
      );
    });
  }

  Widget _memoryListItem(String itemContent, bool isSelected, int index) {
    Color containerColor = isSelected
        ? Color(0xffD8D8D8).withOpacity(0.5)
        : Color(0xffD8D8D8).withOpacity(0.3);
    Color textColor = Color(0xffFFFFFF);

    BorderSide borderSide = isSelected
        ? BorderSide(color: Color(0xffFFFFFF), width: 1)
        : BorderSide(color: Colors.transparent, width: 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMap[index] = !isSelected; // 선택 상태 반전
          });
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Color(0xffD0EE17) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    itemContent,
                    style: TextStyle(
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

  void _showAddMemoryDialog() {
    _textController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "챙길거리 추가",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffFFFFFF),
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff3C3C3C),
                          hintText: '챙길거리를 입력해주세요',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff959595),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                            BorderSide(color: Color(0xffD0EE17), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 13),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_textController.text.isNotEmpty) {
                            await _memoriesController
                                .addItem(_textController.text);
                            _textController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff323232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 66.0,
                          ),
                        ),
                        child: Text(
                          '추가하기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xffD0EE17),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomActionButton(
      IconData iconData, String tooltip, VoidCallback? onPressed,
      {required Color backgroundColor, required double size}) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      shape: CircleBorder(),
      child: Icon(
        iconData,
        size: size,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: CustomDetailAppBar(title: '챙길거리'),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 26)),
              SliverToBoxAdapter(
                child: Center(
                  child: Image.asset(
                    'assets/develop/3d-book-icon.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 26)),
              Obx(() {
                if (_memoriesController.memoriesList.isEmpty ||
                    _memoriesController.memoriesList[0].items == null ||
                    _memoriesController.memoriesList[0].items!.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        '등록된 챙길거리가 없습니다',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                    ),
                  );
                }
                final items = _memoriesController.memoriesList[0].items!;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final itemContent = items[index];
                      bool isSelected = _selectedMap[index] ?? false;
                      return _memoryListItem(itemContent, isSelected, index);
                    },
                    childCount: items.length,
                  ),
                );
              }),
              SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          // 오른쪽 하단의 버튼들은 그대로 유지
          Positioned(
            bottom: 80,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCustomActionButton(
                  Icons.add,
                  "챙길거리 추가",
                  _showAddMemoryDialog,
                  backgroundColor: Color(0xffD0EE17).withOpacity(0.5),
                  size: 30,
                ),
                SizedBox(height: 10),
                _buildCustomActionButton(
                  Icons.delete,
                  "선택 삭제",
                  _selectedMap.values.contains(true) ? _bulkDeleteItems : null,
                  backgroundColor: _selectedMap.values.contains(true)
                      ? Color(0xffFF5A5A).withOpacity(0.4)
                      : Colors.grey.withOpacity(0.4),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
