// lib/home/main/page/home_main_content_page.dart

import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/home/community/pages/community_main_page.dart';
import 'package:nero_app/develop/home/information/model/information.dart';
import 'package:nero_app/develop/home/information/repository/information_repository.dart';
import 'package:nero_app/develop/home/magazine/model/magazine.dart';
import 'package:nero_app/develop/home/magazine/repository/magazine_repository.dart';
import 'package:nero_app/develop/home/main/page/home_information_page.dart';
import 'package:nero_app/develop/home/main/page/home_magazine_page.dart';
import 'package:nero_app/develop/home/notification/controller/notification_controller.dart';
import 'package:nero_app/develop/home/notification/model/notification_model.dart';
import 'package:nero_app/develop/home/notification/page/notification_detail_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMainContentPage extends StatefulWidget {
  const HomeMainContentPage({super.key});

  @override
  State<HomeMainContentPage> createState() => _HomeMainContentPageState();
}

class _HomeMainContentPageState extends State<HomeMainContentPage> {
  final NotificationController _notificationController =
      Get.put(NotificationController(), permanent: true);
  final PageController _pageController =
      PageController(viewportFraction: 0.6, initialPage: 1000);
  final InformationRepository _informationRepository =
      Get.find<InformationRepository>();
  final MagazineRepository _magazineRepository = MagazineRepository();
  late Future<List<Information>> _latestInformationsFuture;
  late Future<List<Magazine>> _latestMagazinesFuture;
  final RxInt _currentPage = 0.obs;

  final String _instagramUrl = 'https://www.instagram.com/nero.cat_official/';
  final String _threadUrl = 'https://www.threads.net/@nero.cat_official';
  final String _twitterUrl = 'https://x.com/nerolaboratory';
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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
    analytics.logScreenView(
      screenName: '_openInstagram',
      screenClass: '_openInstagram',
    );
    _launchUrl(_instagramUrl, 'instagram://user?username=nero.cat_official');
  }

  void _openTwitter() {
    analytics.logScreenView(
      screenName: '_openTwitter',
      screenClass: '_openTwitter',
    );
    _launchUrl(_twitterUrl, 'twitter://user?screen_name=nerolaboratory');
  }

  void _openThreads() {
    analytics.logScreenView(
      screenName: '_openThreads',
      screenClass: '_openThreads',
    );
    _launchUrl(_threadUrl, 'threads://user?username=nero.cat_official');
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _latestInformationsFuture = _informationRepository.getLatestInformation();
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
            arguments: {'noticeId': notification.id});
      },
      behavior: HitTestBehavior.translucent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: notification.imageUrls.isNotEmpty
                  ? Image.network(
                      notification.imageUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/develop/default.png',
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: [0.6, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 36,
              left: 24,
              right: 24,
              child: Text(
                notification.title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
        height: 300,
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
                    onTap: _openTwitter,
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
                    onTap: _openThreads,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/develop/threads-icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Center(
                          child: Text(
                            'Threads',
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
      body: Obx(
        () {
          if (_notificationController.isLoading.value) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kToolbarHeight + 56),
                  SizedBox(
                    height: 300,
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
                          '커뮤니티 마당 (Beta)',
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
                          onTap: () {
                            Get.to(() => CommunityMainPage());
                          },
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "같은 고민을 하는 유저들을\n한 곳에서 만나볼 수 있어요",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomDivider(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          '공지사항',
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
            return Center(
              child: Text(
                '현재 네로의 공지가 없습니다',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xff3C3C3C),
                ),
              ),
            );
          }

          final notifications = _notificationController.notifications;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      child: Obx(() {
                        int currentIndex =
                            _currentPage.value % notifications.length;
                        String imageUrl;
                        if (notifications[currentIndex].imageUrls.isNotEmpty) {
                          imageUrl =
                              notifications[currentIndex].imageUrls.first;
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/develop/default.png',
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        } else {
                          return Image.asset(
                            'assets/develop/default.png',
                            fit: BoxFit.cover,
                          );
                        }
                      }),
                    ),
                    // 블러 효과
                    Positioned.fill(
                      child: Container(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    // 그라데이션 효과
                    Positioned.fill(
                      child: Container(
                        height: 300 + 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                            stops: [
                              0.5,
                              1.0,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // PageView
                    Column(
                      children: [
                        SizedBox(height: kToolbarHeight + 80),
                        Container(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              // 현재 페이지 인덱스를 업데이트할 때 모듈러 연산을 사용.
                              _currentPage.value = index;
                              analytics.logEvent(
                                name: 'HomeNotificationCardView',
                                parameters: {
                                  'page_index': index,
                                  'page_title': notifications[
                                          index % notifications.length]
                                      .title,
                                },
                              );
                            },
                            itemBuilder: (context, index) {
                              // 인덱스를 데이터 리스트의 길이로 나눈 나머지를 사용
                              int dataIndex = index % notifications.length;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: _notificationOne(
                                  notifications[dataIndex],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
                // "게시판" 버튼 추가
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '커뮤니티 마당 (Beta)',
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
                        onTap: () {
                          Get.to(() => CommunityMainPage());
                        },
                        child: Text(
                          '더보기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD0EE17),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "같은 고민을 하는 유저들을\n한 곳에서 만나볼 수 있어요",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const CustomDivider(),
                const SizedBox(height: 30),
                HomeInformationPage(),
                const SizedBox(height: 40),
                const CustomDivider(),
                const SizedBox(height: 30),
                HomeMagazinePage(latestMagazinesFuture: _latestMagazinesFuture),
                const SizedBox(height: 40),
                _copyrightInfo(),
              ],
            ),
          );
        },
      ),
    );
  }
}
