import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/develop/home/main/page/home_main_page.dart';

class Root extends GetView<BottomNavController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    HomeMainPage(),
                  ],
                ),
              ),
              Obx(
                    () => Container(
                  decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.transparent)],
                  ),
                  child: BottomNavigationBar(
                    currentIndex: controller.menuIndex.value,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: const Color(0xffffffff),
                    unselectedItemColor: const Color(0xffaaaaaa),
                    selectedFontSize: 11.0,
                    unselectedFontSize: 11.0,
                    onTap: controller.changeBottomNav,
                    selectedLabelStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: Color(0xffFFFFFF),
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: Color(0xffFFFFFF),
                    ),
                    items: [
                      BottomNavigationBarItem(
                        label: '홈',
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/home-off.svg'),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/home-on.svg'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '하루기록',
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/todaylog-off.svg'),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/todaylog-on.svg'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '빠른메모',
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/fastmemo-off.svg'),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/fastmemo-on.svg'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '마이페이지',
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/mypage-off.svg'),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/develop/mypage-on.svg'),
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
    );
  }
}
