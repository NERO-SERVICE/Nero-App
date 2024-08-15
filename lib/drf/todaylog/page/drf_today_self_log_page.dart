import 'package:flutter/material.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:provider/provider.dart';

class DrfTodaySelfLogPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrfTodayController>(
      create: (_) => DrfTodayController()..fetchSelfLogs(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('셀프 기록'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Consumer<DrfTodayController>(
                  builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: controller.selfLogs.length,
                      itemBuilder: (context, index) {
                        final log = controller.selfLogs[index];
                        return ListTile(
                          title: Text(log.content, style: TextStyle(color: Colors.white)),
                          subtitle: Text(log.createdAt.toString(),  style: TextStyle(color: Colors.white54)),
                        );
                      },
                    );
                  },
                ),
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
                          await Provider.of<DrfTodayController>(context, listen: false)
                              .submitSelfLog(_textController.text);
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
      },
    );
  }
}
