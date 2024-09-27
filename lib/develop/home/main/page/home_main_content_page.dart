import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/home/information/model/information.dart';
import 'package:nero_app/develop/home/information/repository/information_repository.dart';
import 'package:nero_app/develop/home/magazine/model/magazine.dart';
import 'package:nero_app/develop/home/magazine/repository/magazine_repository.dart';
import 'package:nero_app/develop/home/main/page/home_information_page.dart';
import 'package:nero_app/develop/home/main/page/home_magazine_page.dart';
import 'package:nero_app/develop/home/main/page/home_news_page.dart';
import 'package:nero_app/develop/home/news/model/news.dart';
import 'package:nero_app/develop/home/news/repository/news_repository.dart';
import 'package:nero_app/develop/home/notification/controller/notification_controller.dart';
import 'package:nero_app/develop/home/notification/model/notification_model.dart';
import 'package:nero_app/develop/home/notification/page/notification_detail_page.dart';
import 'package:shimmer/shimmer.dart'; // Import Shimmer
import 'package:url_launcher/url_launcher.dart';

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
  final InformationRepository _informationRepository = InformationRepository();
  final MagazineRepository _magazineRepository = MagazineRepository();
  late Future<List<News>> _latestNewsFuture;
  late Future<List<Information>> _latestInformationsFuture;
  late Future<List<Magazine>> _latestMagazinesFuture;

  final String _instagramUrl = 'https://www.instagram.com/nero.cat_official/';
  final String _tiktokUrl = 'https://www.tiktok.com/@nero_official';

  Future<void> _launchUrl(String url, String appUrlScheme) async {
    final Uri appUri = Uri.parse(appUrlScheme);
    final Uri webUri = Uri.parse(url);

    // 앱 URL로 연결 시도
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else if (await canLaunchUrl(webUri)) {
      // 앱이 설치되어 있지 않다면 웹 브라우저로 연결
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openInstagram() {
    _launchUrl(_instagramUrl, 'instagram://user?username=nero.cat_official');
  }

  void _openTikTok() {
    _launchUrl(_tiktokUrl, 'snssdk1233://user/profile/7038378919538274309');
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _latestInformationsFuture = _informationRepository.getLatestInformation();
    _latestNewsFuture = _newsRepository.getLatestNews();
    _latestMagazinesFuture = _magazineRepository.getLatestMagazine();
  }

  Future<void> _loadNotifications() async {
    await _notificationController.fetchNotifications();
  }

  Widget subInfo(NotificationModel notification) {
    return Container(
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
            borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
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

  Widget _skeletonNotification() {
    return Shimmer.fromColors(
      baseColor: Color(0xff323232).withOpacity(0.5),
      highlightColor: Color(0xff323232).withOpacity(0.8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xff323232).withOpacity(0.5),
        ),
        width: 300,
        height: 400,
      ),
    );
  }

  Widget _skeletonNews() {
    return Shimmer.fromColors(
      baseColor: Color(0xff323232).withOpacity(0.5),
      highlightColor: Color(0xff323232).withOpacity(0.8),
      child: Column(
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
            child: Container(
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xff323232).withOpacity(0.5),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _skeletonMagazines() {
    return Shimmer.fromColors(
      baseColor: Color(0xff323232).withOpacity(0.5),
      highlightColor: Color(0xff323232).withOpacity(0.8),
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xff323232).withOpacity(0.5),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _copyrightInfo() {
    return Container(
      height: 118,
      color: const Color(0xff1C1C1C),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '© 2024 NERO All rights reserved.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xff959595),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _openInstagram,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/instagram-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Center(
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
                  child: GestureDetector(
                    onTap: () => print("X(Twitter) icon clicked"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/twitter-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Center(
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
                  child: GestureDetector(
                    onTap: _openTikTok,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/tiktok-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Center(
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + 56),
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3, // Number of skeletons
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: _skeletonNotification(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '개발자 공지사항',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          '더보기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _skeletonNews(),
                const SizedBox(height: 40),
                const CustomDivider(),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '매거진',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          '더보기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _skeletonMagazines(),
                const SizedBox(height: 40),
                _copyrightInfo(),
              ],
            ),
          );
        }

        if (_notificationController.notifications.isEmpty) {
          return Center(child: Text('No notifications available'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kToolbarHeight + 56),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _notificationController.notifications.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _notificationOne(
                        _notificationController.notifications[index],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              HomeNewsPage(
                latestNewsFuture: _latestNewsFuture,
              ),
              HomeInformationPage(
                  latestInformationFuture: _latestInformationsFuture),
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
