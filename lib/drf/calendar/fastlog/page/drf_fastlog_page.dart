import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import 'package:nero_app/drf/calendar/fastlog/controller/drf_fastlog_controller.dart';

class DrfFastlogPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final DrfFastlogController controller = Get.find<DrfFastlogController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('yyyy년 M월 d일')
                      .format(controller.selectedDate.value),
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  '기억해야 하는 모든 것을 적어주세요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xffD9D9D9),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      maxHeight: 50,
                    ),
                    child: TextField(
                      controller: _textController,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffD9D9D9),
                      ),
                      decoration: InputDecoration(
                        labelText: '기록 작성',
                        labelStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
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
                        fillColor: Colors.grey.withOpacity(0.3),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 18.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: Size(50, 50),
                    maximumSize: Size(50, 50),
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
