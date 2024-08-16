import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/calendar/fastlog/controller/drf_fastlog_controller.dart';

class DrfFastlogPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final DrfFastlogController controller = Get.find<DrfFastlogController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          '${controller.selectedDate.value.toLocal().toString().split(' ')[0]}일의 빠른 기록',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.fastlogs.isEmpty) {
                return Center(child: Text('No logs found for this date.'));
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: '기록 작성',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
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
