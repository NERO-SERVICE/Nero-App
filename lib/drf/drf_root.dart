import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/clinic/page/drf_clinic_list_page.dart';
import 'package:nero_app/drf/clinic/page/drf_clinic_page.dart';
import 'package:nero_app/drf/common/controller/drf_bottom_nav_controller.dart';
import 'package:nero_app/drf/home/page/drf_home_page.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import 'package:nero_app/src/common/components/app_font.dart';

class DrfRoot extends GetView<DrfBottomNavController> {
  const DrfRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: [
          DrfHomePage(),
          DrfClinicPage(),
          const Center(child: AppFont('채팅')),
          Center(
            child: GestureDetector(
              onTap: () {
                Get.find<DrfAuthenticationRepository>().logout();
              },
              child: const AppFont('로그아웃'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.menuIndex.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff212123),
          selectedItemColor: const Color(0xffffffff),
          unselectedItemColor: const Color(0xfffffff),
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
              label: '동네 생활',
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    SvgPicture.asset('assets/svg/icons/arround-life-off.svg'),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/arround-life-on.svg'),
              ),
            ),
            BottomNavigationBarItem(
              label: '채팅',
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
    );
  }
}
