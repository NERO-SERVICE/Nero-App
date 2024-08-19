import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/calendar/fastlog/controller/drf_fastlog_controller.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

import '../../../../src/common/components/app_font.dart';

class DrfFastlogPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final DrfFastlogController controller = Get.find<DrfFastlogController>();

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        leadingWidth: Get.width * 0.8,
        leading: GestureDetector(
          onTap: Get.back,
          child: Row(
            children: [
              const SizedBox(width: 10),
              SvgPicture.asset('assets/svg/icons/close.svg'),
              const SizedBox(width: 20),
              AppFont(
                '${controller.selectedDate.value.toLocal().toString().split(' ')[0]} 빠른 기록',
                fontWeight: FontWeight.bold,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.fastlogs.isEmpty) {
                return Center(
                  child: Text(
                    '작성된 글이 없습니다',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: controller.fastlogs.length,
                itemBuilder: (context, index) {
                  final log = controller.fastlogs[index];
                  return ListTile(
                    title: Text(
                      log.content,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      log.date.toLocal().toString(),
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: Colors.grey.shade600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xff323232),
                      labelText: '기록 작성',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_textController.text.isNotEmpty) {
                      await controller.submitFastlog(_textController.text);
                      _textController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff323232),
                  ),
                  child: Text('전송'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
