import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nero_app/develop/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/develop/fastmemo/page/fast_memo_main_page.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/home/community/pages/community_main_page.dart';
import 'package:nero_app/develop/home/main/page/home_main_page.dart';
import 'package:nero_app/develop/mypage/page/my_page.dart';
import 'package:nero_app/develop/todaylog/main/page/todaylog_main_page.dart';

class Root extends GetView<BottomNavController> {
  Root({super.key});

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final CommunityController _communityController = Get.find<CommunityController>();

  Widget get _divider => const Divider(
        color: Color(0xff3C3C3E),
        thickness: 1,
        height: 1,
        indent: 0,
        endIndent: 0,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.menuIndex.value,
          children: [
            const HomeMainPage(),
            TodaylogMainPage(),
            CommunityMainPage(),
            FastMemoMainPage(),
            MyPage(),
          ],
        );
      }),
      bottomNavigationBar: Container(
        color: Color(0xff202020),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _divider,
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24, left: 24, right: 24),
              child: Obx(
                () => GNav(
                  gap: 5,
                  activeColor: Colors.white,
                  color: Colors.grey,
                  backgroundColor: Color(0xff202020),
                  tabBackgroundColor: Color(0xff3C3C3C),
                  padding: const EdgeInsets.all(16),
                  selectedIndex: controller.menuIndex.value,
                  onTabChange: (index) {
                    _logScreenView(index);
                    controller.changeBottomNav(index);

                    if (index == 2) {
                      _communityController.fetchAllPosts(refresh: true);
                    }
                  },
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 0
                          ? 'assets/develop/home-on.svg'
                          : 'assets/develop/home-off.svg'),
                    ),
                    GButton(
                      icon: Icons.calendar_today,
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 1
                          ? 'assets/develop/todaylog-on.svg'
                          : 'assets/develop/todaylog-off.svg'),
                    ),
                    GButton(
                      icon: Icons.person,
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 2
                          ? 'assets/develop/community-on.svg'
                          : 'assets/develop/community-off.svg'),
                    ),
                    GButton(
                      icon: Icons.note_add,
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 3
                          ? 'assets/develop/fastmemo-on.svg'
                          : 'assets/develop/fastmemo-off.svg'),
                    ),
                    GButton(
                      icon: Icons.person,
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 4
                          ? 'assets/develop/mypage-on.svg'
                          : 'assets/develop/mypage-off.svg'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logScreenView(int index) {
    String screenName;
    switch (index) {
      case 0:
        screenName = 'HomeMainPage';
        break;
      case 1:
        screenName = 'TodaylogMainPage';
        break;
      case 2:
        screenName = 'CommunityMainPage';
        break;
      case 3:
        screenName = 'FastMemoMainPage';
        break;
      case 4:
        screenName = 'MyPage';
        break;
      default:
        screenName = 'HomeMainPage';
        break;
    }

    analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }
}
