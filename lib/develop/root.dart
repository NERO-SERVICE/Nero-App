import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nero_app/develop/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/develop/fastmemo/page/fast_memo_main_page.dart';
import 'package:nero_app/develop/home/main/page/home_main_page.dart';
import 'package:nero_app/develop/mypage/page/my_page.dart';
import 'package:nero_app/develop/todaylog/main/page/todaylog_main_page.dart';

class Root extends GetView<BottomNavController> {
  const Root({super.key});

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
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => GNav(
                  gap: 12,
                  activeColor: Colors.white,
                  color: Colors.grey,
                  backgroundColor: Color(0xff202020),
                  tabBackgroundColor: Color(0xff3C3C3C),
                  padding: const EdgeInsets.all(16),
                  selectedIndex: controller.menuIndex.value,
                  onTabChange: controller.changeBottomNav,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: '홈',
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 0
                          ? 'assets/develop/home-on.svg'
                          : 'assets/develop/home-off.svg'),
                    ),
                    GButton(
                      icon: Icons.calendar_today,
                      text: '하루기록',
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 1
                          ? 'assets/develop/todaylog-on.svg'
                          : 'assets/develop/todaylog-off.svg'),
                    ),
                    GButton(
                      icon: Icons.note_add,
                      text: '빠른메모',
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 2
                          ? 'assets/develop/fastmemo-on.svg'
                          : 'assets/develop/fastmemo-off.svg'),
                    ),
                    GButton(
                      icon: Icons.person,
                      text: '마이페이지',
                      iconActiveColor: Colors.white,
                      leading: SvgPicture.asset(controller.menuIndex.value == 3
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
}
