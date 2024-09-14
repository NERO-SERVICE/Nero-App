import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/signup/page/sign_up_page.dart';
import 'package:nero_app/drf/calendar/page/drf_calendar_page.dart';
import 'package:nero_app/drf/clinic/page/drf_clinic_page.dart';
import 'package:nero_app/drf/common/controller/drf_bottom_nav_controller.dart';
import 'package:nero_app/drf/mypage/page/drf_monthly_matrix_view.dart';
import 'package:nero_app/drf/product/home/page/drf_home_page.dart';

import 'todaylog/page/drf_today_page.dart';

class DrfRoot extends GetView<DrfBottomNavController> {
  const DrfRoot({super.key});

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
                    DrfHomePage(),
                    // DrfClinicPage(),
                    SignUpPage(),
                    DrfTodayPage(),
                    DrfCalendarPage(),
                    DrfMonthlyMatrixView(),
                  ],
                ),
              ),
              Obx(
                    () => BottomNavigationBar(
                  currentIndex: controller.menuIndex.value,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: const Color(0xffffffff),
                  unselectedItemColor: const Color(0xffaaaaaa),
                  selectedFontSize: 11.0,
                  unselectedFontSize: 11.0,
                  onTap: controller.changeBottomNav,
                  items: [
                    BottomNavigationBarItem(
                      label: '홈',
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/home-off.svg'),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/home-on.svg'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '테스트',
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/arround-life-off.svg'),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/arround-life-on.svg'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '하루기록',
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/chat-off.svg'),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/chat-on.svg'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '빠른메모',
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/near-off.svg'),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/near-on.svg'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '나의 네로',
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/my-off.svg'),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/icons/my-on.svg'),
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
  }
}
