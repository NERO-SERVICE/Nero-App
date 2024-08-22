import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/drf/clinic/detail/drf_clinic_detail_page.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';
import 'package:nero_app/drf/clinic/write/page/drf_clinic_write_page.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

class DrfClinicListPage extends StatefulWidget {
  @override
  _DrfClinicListPageState createState() => _DrfClinicListPageState();
}

class _DrfClinicListPageState extends State<DrfClinicListPage> {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();
  List<DrfClinic> _clinics = [];
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _loadClinics();
  }

  Future<void> _loadClinics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final clinics = await _clinicRepository.getClinics();
      setState(() {
        _clinics = clinics;
      });
    } catch (e) {
      print('Failed to load clinics: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleClinicCreation() async {
    final result = await Get.to(() => DrfClinicWritePage());
    if (result == true) {
      // 클리닉이 생성되었을 경우에만 리스트를 다시 로드
      await _loadClinics();
      if (_clinics.isNotEmpty) {
        final newClinic = _clinics.last; // 리스트에서 마지막으로 추가된 클리닉
        await Get.to(() => DrfClinicDetailPage(clinic: newClinic)); // 상세 페이지로 이동
      }
    }
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

  Widget _clinicItem(DrfClinic clinic) {
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => DrfClinicDetailPage(clinic: clinic));
        if (result == true) {
          await _loadClinics();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                AppFont(
                  clinic.title,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(height: 5),
                _subInfo(clinic),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25),
        itemCount: _clinics.length,
        itemBuilder: (context, index) {
          final clinic = _clinics[index];
          return _clinicItem(clinic);
        },
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            color: Color(0xff3C3C3E),
          ),
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: _handleClinicCreation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
