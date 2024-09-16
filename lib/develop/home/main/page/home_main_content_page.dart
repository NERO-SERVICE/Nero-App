import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/home/notification/controller/notification_controller.dart';
import 'package:nero_app/develop/home/notification/model/notification_model.dart';
import 'package:nero_app/develop/home/notification/page/notification_detail_page.dart';

class HomeMainContentPage extends StatefulWidget {
  const HomeMainContentPage({super.key});

  @override
  State<HomeMainContentPage> createState() => _HomeMainContentPageState();
}

class _HomeMainContentPageState extends State<HomeMainContentPage> {
  final NotificationController _notificationController =
  Get.put(NotificationController(), permanent: true);
  final PageController _pageController = PageController(viewportFraction: 0.7);

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await _notificationController.fetchNotifications();
  }

  Widget subInfo(NotificationModel notification) {
    return Positioned(
      bottom: 36,
      left: 24,
      right: 24,
      child: Container(
        child: Text(
          notification.title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
          maxLines: null, // 무제한 줄 수 허용
          softWrap: true, // 줄바꿈 가능
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }


  Widget _notificationOne(NotificationModel notification) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => NotificationDetailPage(),
            arguments: {'noticeId': notification.noticeId});
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 300,
              height: 400,
              child: notification.imageUrls.isNotEmpty
                  ? Image.network(
                notification.imageUrls.first,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 36,
            left: 24,
            right: 24,
            child: subInfo(notification),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_notificationController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_notificationController.notifications.isEmpty) {
          return Center(child: Text('No notifications available'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _notificationController.notifications.length,
                  itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 25.0 : 10.0,
                          right: index == _notificationController.notifications.length - 1
                              ? 25.0
                              : 10.0,
                        ),
                        child: _notificationOne(
                            _notificationController.notifications[index]),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
