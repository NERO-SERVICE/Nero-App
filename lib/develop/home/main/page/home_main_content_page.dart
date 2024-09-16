import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/home/magazine/model/magazine.dart';
import 'package:nero_app/develop/home/magazine/repository/magazine_repository.dart';
import 'package:nero_app/develop/home/main/page/home_magazine_page.dart';
import 'package:nero_app/develop/home/main/page/home_news_page.dart';
import 'package:nero_app/develop/home/news/model/news.dart';
import 'package:nero_app/develop/home/news/repository/news_repository.dart';
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
  final NewsRepository _newsRepository = NewsRepository();
  final MagazineRepository _magazineRepository = MagazineRepository();
  late Future<List<News>> _latestNewsFuture;
  late Future<List<Magazine>> _latestMagazinesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _latestNewsFuture = _newsRepository.getLatestNews();
    _latestMagazinesFuture = _magazineRepository.getLatestMagazine();
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

  Widget _copyrightInfo() {
    return Container(
      height: 118,
      color: Color(0xff1C1C1C),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '© 2024 NERO All rights reserved.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xff959595),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/instagram-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 5),
                        Center(
                          child: Text(
                            'Instagram',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff959595),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/twitter-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 5),
                        Center(
                          child: Text(
                            'X(twitter)',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff959595),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/tiktok-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 5),
                        Center(
                          child: Text(
                            'TikTok',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff959595),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
              const SizedBox(height: 20),
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
                          right: index ==
                                  _notificationController.notifications.length -
                                      1
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
              const SizedBox(height: 30),
              HomeNewsPage(
                latestNewsFuture: _latestNewsFuture,
              ),
              const SizedBox(height: 40),
              const CustomDivider(),
              const SizedBox(height: 30),
              HomeMagazinePage(latestMagazinesFuture: _latestMagazinesFuture),
              const SizedBox(height: 40),
              _copyrightInfo(),
            ],
          ),
        );
      }),
    );
  }
}
