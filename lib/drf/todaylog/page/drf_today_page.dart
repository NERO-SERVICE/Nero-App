import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/drf/clinic/detail/drf_clinic_detail_page.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';
import 'package:nero_app/drf/clinic/write/page/drf_clinic_write_page.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drf_today_log_page.dart';
import 'drf_today_self_log_page.dart';
import 'drf_today_side_effect_page.dart';

class DrfTodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DrfTodayController()),
        ],
        child: CommonLayout(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: Get.width * 0.6,
            leading: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  const AppFont(
                    '하루기록',
                    fontWeight: FontWeight.bold,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            actions: [
              SvgPicture.asset('assets/svg/icons/search.svg'),
              const SizedBox(width: 15),
              SvgPicture.asset('assets/svg/icons/list.svg'),
              const SizedBox(width: 15),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('accessToken');
                  await prefs.remove('refreshToken');
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '오늘 약 드셨어요?',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  '만성 질환 관리는 의사가 처방한 약을\n올바른 방법으로 복용하는것이 시작이에요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
                SizedBox(height: 32),
                _buildDrugWidget(context),
                SizedBox(height: 81),
                Text(
                  '하루는 어땠어요?',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  '어떤 기분이었는지 궁금해요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
                SizedBox(height: 24),
                _buildCustomButton(
                  context,
                  labelTop: '오늘 컨디션을 기록하는',
                  labelBottom: '하루 설문',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrfTodayLogPage()),
                    );
                  },
                ),
                SizedBox(height: 16),
                _buildCustomButton(
                  context,
                  labelTop: '평소와 다르지 않았을까',
                  labelBottom: '부작용 설문',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrfTodaySideEffectPage()),
                    );
                  },
                ),
                SizedBox(height: 16),
                _buildCustomButton(
                  context,
                  labelTop: '추가적으로 더 쓰고 싶은 내용은',
                  labelBottom: '셀프 기록',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrfTodaySelfLogPage()),
                    );
                  },
                ),
                SizedBox(height: 81),
                Text(
                  '진료기록',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  '병원에서 어떤 처방을 해줬는지 기억나요?',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
                SizedBox(height: 24),
                _buildClinicPageView(context),
                SizedBox(height: 24),
                _clinicWriteWidget(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _clinicWriteWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => DrfClinicWritePage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff323232),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            '작성하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              color: Color(0xffD0EE17),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClinicPageView(BuildContext context) {
    return FutureBuilder<List<DrfClinic>>(
      future: _loadClinics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load clinics'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No clinics available'));
        } else {
          final clinics = snapshot.data!;
          return SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: clinics.length,
              controller: PageController(viewportFraction: 0.85),
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                return _clinicItem(context, clinic);
              },
            ),
          );
        }
      },
    );
  }

  Future<List<DrfClinic>> _loadClinics() async {
    final DrfClinicRepository clinicRepository = DrfClinicRepository();
    try {
      return await clinicRepository.getClinics();
    } catch (e) {
      print('Failed to load clinics: $e');
      return [];
    }
  }

  Widget _clinicItem(BuildContext context, DrfClinic clinic) {
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => DrfClinicDetailPage(clinic: clinic));
        if (result == true) {
          await _loadClinics();
        }
      },
      child: FractionallySizedBox(
        child: Padding(
          padding: const EdgeInsets.only(right: 17),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff323232),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
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
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.title,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      _subInfo(clinic),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _subInfo(DrfClinic clinic) {
    return Row(
      children: [
        AppFont(
          "${clinic.nickname}",
          color: const Color(0xff878B93),
          size: 12,
        ),
        const AppFont(
          ' · ',
          color: Color(0xff878B93),
          size: 12,
        ),
        AppFont(
          DateFormat('yyyy.MM.dd').format(clinic.recentDay),
          color: const Color(0xff878B93),
          size: 12,
        ),
      ],
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required String labelTop,
    required String labelBottom,
    required VoidCallback onPressed,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: Color(0xff323232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  labelTop,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
                Text(
                  labelBottom,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Color(0xffD0EE17),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugWidget(BuildContext context) {
    int itemCount = 5;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xff323232),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${DateTime.now().toLocal()}'.split(' ')[0],
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: List.generate(itemCount, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼 클릭 시 동작
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1C1B1B),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          '리스트 버튼 ${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 75.0),
            child: ElevatedButton(
              onPressed: () {
                // 제출하기 버튼 클릭 시 동작
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff1C1B1B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '제출하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: Color(0xffD0EE17),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
