import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/components/btn.dart';

import 'app_font.dart';

class PlaceNamePopup extends StatefulWidget {
  const PlaceNamePopup({super.key});

  @override
  State<PlaceNamePopup> createState() => _PlaceNamePopupState();
}

class _PlaceNamePopupState extends State<PlaceNamePopup> {
  bool possible = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Align(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    height: 250,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppFont(
                          '선택한 곳의 장소명을 입력해주세요',
                          fontWeight: FontWeight.bold,
                          size: 16,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          autofocus: true,
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: '예) 잠실역 1번 출구',
                            hintStyle: TextStyle(
                                color: Color(0xffCDCDCD)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              possible = value != '';
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Btn(
                            child: const Text(
                              '선택 완료',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            disabled: !possible,
                            onTap: () {
                              Get.back(result: controller.text);
                            },),
                      ],
                    ),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
