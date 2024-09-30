import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/home/notification/controller/notification_controller.dart';

import '../../../common/components/custom_loading_indicator.dart';

class NotificationDetailPage extends StatefulWidget {
  NotificationDetailPage({super.key});

  @override
  _NotificationDetailPageState createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final NotificationController controller =
      Get.find<NotificationController>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final int noticeId = Get.arguments['noticeId']; // noticeId만 받음

    // 데이터를 로드한 후 렌더링
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentNotification.value.noticeId != noticeId) {
        controller.fetchNotification(noticeId);
      }
    });

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CustomLoadingIndicator());
        }

        final notification = controller.currentNotification.value;

        return Stack(
          children: [
            // 메인 콘텐츠
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.imageUrls.isNotEmpty)
                    Stack(
                      children: [
                        SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemCount: notification.imageUrls.isNotEmpty ? notification.imageUrls.length : 1,
                            itemBuilder: (context, index) {
                              if (notification.imageUrls.isNotEmpty) {
                                return Image.network(
                                  notification.imageUrls[index],
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CustomLoadingIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/develop/default.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image.asset(
                                  'assets/develop/default.png',
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: _buildIndicator(notification.imageUrls.length),
                        ),
                      ],
                    )
                  else
                    const Center(
                        child: Text('이미지가 없습니다.',
                            style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 30),

                  // 공지사항 제목
                  NotificationTitleWidget(title: notification.title),
                  const SizedBox(height: 30),
                  const CustomDivider(),

                  // 공지사항 설명
                  const SizedBox(height: 30),
                  if (notification.description != null)
                    NotificationContentWidget(
                        content: notification.description!),
                  const SizedBox(height: 20),
                  NotificationDateWidget(createdAt: notification.createdAt),
                  const SizedBox(height: 20),
                  const CustomDivider(),

                  // 작성자 정보
                  const SizedBox(height: 30),
                  NotificationWriterWidget(nickname: notification.nickname),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // 투명 앱바
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
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
            ),
          ],
        );
      }),
    );
  }

  // 인디케이터 빌드 함수
  Widget _buildIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 32 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xffD0EE17)
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}

// 분리된 위젯들

class NotificationTitleWidget extends StatelessWidget {
  final String title;

  const NotificationTitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}

class NotificationContentWidget extends StatelessWidget {
  final String content;

  const NotificationContentWidget({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        content,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}

class NotificationWriterWidget extends StatelessWidget {
  final String nickname;

  const NotificationWriterWidget({required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/develop/nero-small-logo.svg',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickname,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xffFFFFFF),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '에디터',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: Color(0xff848B8B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationDateWidget extends StatelessWidget {
  final DateTime createdAt;

  const NotificationDateWidget({
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '작성일',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color(0xff848B8B),
              ),
            ),
            Text(
              '${createdAt.toString().substring(0, 10)}',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color(0xff848B8B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
