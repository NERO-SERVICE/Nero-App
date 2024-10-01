import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:provider/provider.dart';

import '../controller/recall_controller.dart';

class SelfRecordPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecallController>(
      create: (_) => RecallController(type: '')..fetchSelfLogs(),
      builder: (context, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomDetailAppBar(title: '셀프 기록'),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/selflog_background.png',
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: kToolbarHeight + 56),
                                Text(
                                  '아직 적지 못한 당신의 이야기를\n자유롭게 적어주세요',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xffD9D9D9),
                                  ),
                                ),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                          Consumer<RecallController>(
                            builder: (context, controller, child) {
                              if (controller.isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                reverse: true,
                                itemCount: controller.selfLogs.length,
                                itemBuilder: (context, index) {
                                  final log = controller.selfLogs[index];
                                  final formattedTime = DateFormat('HH:mm').format(log.createdAt);

                                  // 이전 로그와 시간 비교하여 같은 날짜 및 시간을 갖는 경우 시간 생략
                                  bool showTime = true;
                                  if (index > 0) {
                                    final previousLog = controller.selfLogs[index - 1];
                                    if (DateFormat('yyyy-MM-dd HH:mm').format(previousLog.createdAt) ==
                                        DateFormat('yyyy-MM-dd HH:mm').format(log.createdAt)) {
                                      showTime = false;
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: 280,
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 12),
                                              padding: const EdgeInsets.symmetric(horizontal: 26),
                                              decoration: BoxDecoration(
                                                color: Color(0xffD8D8D8).withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 16),
                                                  Text(
                                                    log.content,
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                      color: Color(0xffFFFFFF),
                                                    ),
                                                    softWrap: true,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                  SizedBox(height: 16),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (showTime)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12, bottom: 12),
                                              child: Text(
                                                formattedTime,
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Color(0xffD9D9D9),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xffFFFFFF),
                              ),
                              cursorColor: Color(0xffD9D9D9),
                              decoration: InputDecoration(
                                hintText: '기록을 입력해주세요',
                                hintStyle: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
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
                                fillColor: Color(0xffD8D8D8).withOpacity(0.4),
                                contentPadding: EdgeInsets.symmetric(horizontal: 21),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_textController.text.isNotEmpty) {
                              await Provider.of<RecallController>(context, listen: false)
                                  .submitSelfLog(_textController.text);
                              _textController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffD8D8D8).withOpacity(0.4),
                            shape: CircleBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            ],
          ),
        );
      },
    );
  }
}
