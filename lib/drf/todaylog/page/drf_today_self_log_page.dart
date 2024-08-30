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
          extendBodyBehindAppBar: true,
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
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/sideeffect_background.png',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: kToolbarHeight + 29),
                        Text(
                          '셀프 기록',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          '아직 적지 못한 당신의 이야기를\n자유롭게 적어주세요',
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
                    child: Consumer<DrfTodayController>(
                      builder: (context, controller, child) {
                        if (controller.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          reverse: true,
                          itemCount: controller.selfLogs.length,
                          itemBuilder: (context, index) {
                            final log = controller.selfLogs[index];
                            return ListTile(
                              title: Text(
                                log.content,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                log.createdAt.toString(),
                                style: TextStyle(color: Colors.white54),
                              ),
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
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            if (_textController.text.isNotEmpty) {
                              await Provider.of<DrfTodayController>(context,
                                  listen: false)
                                  .submitSelfLog(_textController.text);
                              _textController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.8),
                          ),
                          child: Text('전송'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
