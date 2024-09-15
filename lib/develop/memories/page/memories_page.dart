import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/layout/common_layout.dart';
import 'package:nero_app/develop/memories/controller/memories_controller.dart';

class MemoriesPage extends StatefulWidget {
  const MemoriesPage({super.key});

  @override
  State<MemoriesPage> createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  final List<String> things = [
    '지갑', '스마트폰', '립스틱', '립밤', '충전기', '우산', '교통카드',
    '노트북', '태블릿', '전공책', '필기구', '식권', '이어폰', '약', '쿠폰'
  ];
  List<bool> selectedItems = List.generate(15, (index) => false);

  final MemoriesController _memoriesController = Get.put(MemoriesController());

  void _registerMemories() async {
    List<String> selectedThings = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) {
        selectedThings.add(things[i]);
      }
    }

    if (selectedThings.isNotEmpty) {
      await _memoriesController.sendMemories(selectedThings);
    }

    Get.offNamed('/tutorial');
  }

  Widget _titleBox() {
    return Column(
      children: [
        Text(
          '자주 잃어버리는 물건이 있나요?',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xffFFFFFF),
          ),
        ),
        SizedBox(height: 40),
        Text(
          '매일 잊지 않고 챙기고 싶은\n물건들을 골라주세요',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xffD9D9D9),
          ),
        ),
      ],
    );
  }

  Widget _selectButtonList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.0,
        ),
        itemCount: things.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 80, // 가로 길이
            height: 40, // 세로 길이
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                backgroundColor: selectedItems[index]
                    ? Color(0xffD0EE17).withOpacity(0.5)
                    : Colors.transparent,
                side: BorderSide(
                  color: selectedItems[index]
                      ? Color(0xffD0EE17)
                      : Color(0xffD0EE17).withOpacity(0.5),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  selectedItems[index] = !selectedItems[index];
                });
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  things[index],
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _nextButton() {
    return ElevatedButton(
      onPressed: () {
        Get.offNamed('/tutorial');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff3C3C3C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: const Text(
          '다음에',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            color: Color(0xff959595),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: _registerMemories,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffD0EE17).withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: const Text(
          '등록하기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            color: Color(0xffFFFFFF),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
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
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 26),
            _titleBox(),
            const SizedBox(height: 50),
            _selectButtonList(),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _nextButton(),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _registerButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
