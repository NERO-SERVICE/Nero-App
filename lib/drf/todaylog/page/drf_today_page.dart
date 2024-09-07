import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/drf/clinic/detail/drf_clinic_detail_page.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
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

class DrfTodayPage extends StatefulWidget {
  @override
  State<DrfTodayPage> createState() => _DrfTodayPageState();
}

class _DrfTodayPageState extends State<DrfTodayPage> {
  late Future<List<DrfDrug>> _drugsFuture;
  final List<int> _selectedDrugIds = [];

  @override
  void initState() {
    super.initState();
    _drugsFuture = _loadDrugs();
  }

  void _toggleDrugSelection(int drugId) {
    setState(() {
      if (_selectedDrugIds.contains(drugId)) {
        _selectedDrugIds.remove(drugId); // 이미 선택된 경우 선택 해제
      } else {
        _selectedDrugIds.add(drugId); // 선택되지 않은 경우 선택 추가
      }
    });
  }

  Future<List<DrfDrug>> _loadDrugs() async {
    final DrfClinicRepository clinicRepository = DrfClinicRepository();
    try {
      print("Loading drugs...");
      List<DrfDrug> drugs = await clinicRepository.getDrugsFromLatestClinic();
      print("Loaded drugs: ${drugs.length}");
      return drugs;
    } catch (e) {
      print('Error loading drugs: $e');
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DrfTodayController()),
        ],
        child: CommonLayout(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
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

  Widget _buildDrugWidget(BuildContext context) {
    return FutureBuilder<List<DrfDrug>>(
      future: _drugsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load drugs'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No drugs available'));
        } else {
          final drugs = snapshot.data!;
          return _buildDrugList(context, drugs);
        }
      },
    );
  }

  Widget _buildDrugList(BuildContext context, List<DrfDrug> drugs) {
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
            DateFormat('M월 d일').format(DateTime.now().toLocal()),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: drugs.map((drug) {
              final isSelected = _selectedDrugIds.contains(drug.drugId);
              final initialNumber = drug.initialNumber;
              final displayNumber = isSelected ? drug.number - 1 : drug.number;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: drug.allow
                            ? () {
                          _toggleDrugSelection(drug.drugId);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: isSelected ? Color(0xffD0EE17) : Colors.transparent,
                            width: 1.0,
                          ),
                          backgroundColor: Color(0xff1C1B1B),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                drug.myDrugArchive.drugName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '$displayNumber/$initialNumber',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 75.0),
            child: ElevatedButton(
              onPressed: _selectedDrugIds.isNotEmpty
                  ? () async {
                print('제출하기 버튼 클릭: $_selectedDrugIds');
                await _submitSelectedDrugs();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _selectedDrugIds.isNotEmpty ? Color(0xff1C1B1B) : Color(0xff7D7D7D),
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
          ),
        ],
      ),
    );
  }

  Future<void> _submitSelectedDrugs() async {
    final DrfClinicRepository clinicRepository = DrfClinicRepository();

    try {
      final success = await clinicRepository.consumeSelectedDrugs(_selectedDrugIds);

      if (success) {
        final updatedDrugs = await _loadDrugs();
        setState(() {
          _drugsFuture = Future.value(updatedDrugs);
          _selectedDrugIds.clear();
        });
      } else {
        print('Failed to consume selected drugs.');
      }
    } catch (e) {
      print('Error during drug submission: $e');
    }
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
}
