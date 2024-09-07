import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/drf/clinic/controller/drf_clinic_controller.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/page/drf_clinic_list_page.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';
import 'package:nero_app/src/common/components/app_font.dart';

class DrfClinicDetailPage extends StatefulWidget {
  final DrfClinic clinic;

  DrfClinicDetailPage({required this.clinic});

  @override
  State<DrfClinicDetailPage> createState() => _DrfClinicDetailPageState();
}

class _DrfClinicDetailPageState extends State<DrfClinicDetailPage> {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();
  final DrfClinicController clinicController = Get.find();
  bool _isDeleting = false;

  DrfClinic? clinic;

  @override
  void initState() {
    super.initState();
    _loadClinic();
  }

  Future<void> _loadClinic() async {
    try {
      final _clinic = await _clinicRepository.getClinic(widget.clinic.clinicId);
      setState(() {
        clinic = _clinic;
      });
    } catch (e) {
      print('Failed to load clinic: $e');
    }
  }

  Future<void> _deleteClinic() async {
    setState(() {
      _isDeleting = true; // 로딩 상태로 변경
    });

    final deleted = await clinicController.deleteClinic(widget.clinic.clinicId);
    if (deleted) {
      Get.snackbar('Success', 'Clinic deleted successfully');
      Get.offAll(() => DrfClinicListPage()); // 삭제 후 리스트 페이지로 이동
    } else {
      Get.snackbar('Error', 'Failed to delete clinic');
      setState(() {
        _isDeleting = false; // 실패 시 로딩 상태 해제
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.6,
        leading: Padding(
          padding: const EdgeInsets.only(),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
                constraints: BoxConstraints(),
              ),
              AppFont(
                widget.clinic.title,
                fontWeight: FontWeight.bold,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('최근 진료일',
                DateFormat('yyyy년 MM월 dd일').format(widget.clinic.recentDay)),
            Obx(() {
              final drugs = clinicController.getDrugsForClinic(widget.clinic.clinicId);
              if (drugs.isEmpty) {
                return Center(child: Text('등록된 약이 없습니다'));
              }
              return ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ListView.separated(
                    shrinkWrap: true,
                    // 이걸 추가해야 스크롤 가능한 부모 위젯에서 정상 작동
                    physics: NeverScrollableScrollPhysics(),
                    // 부모 스크롤과 충돌하지 않도록 설정
                    padding: const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                    itemCount: drugs.length,
                    itemBuilder: (context, index) {
                      final drug = drugs[index];
                      return _drugItem(drug);
                    },
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 0)
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            _buildDetailRow('다음 진료 예약일',
                DateFormat('yyyy년 MM월 dd일').format(widget.clinic.nextDay)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updated = await clinicController.updateClinic(
                        DrfClinic(
                          clinicId: widget.clinic.clinicId,
                          owner: widget.clinic.owner,
                          nickname: widget.clinic.nickname,
                          recentDay: widget.clinic.recentDay,
                          nextDay: widget.clinic.nextDay.add(Duration(days: 7)),
                          createdAt: widget.clinic.createdAt,
                          updatedAt: DateTime.now(),
                          title: '${widget.clinic.title} (Updated)',
                          drugs: widget.clinic.drugs,
                        ),
                      );
                      if (updated) {
                        Get.snackbar('Success', 'Clinic updated successfully');
                        Get.back(result: true);
                      } else {
                        Get.snackbar('Error', 'Failed to update clinic');
                      }
                    },
                    child: Text('수정하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      textStyle: TextStyle(fontSize: 18),
                      elevation: 5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isDeleting ? null : _deleteClinic,
                    child: _isDeleting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('삭제하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.3),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      textStyle: TextStyle(fontSize: 18),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          AppFont(label, color: Colors.white, size: 16),
          const SizedBox(width: 10),
          AppFont(value, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  Widget _drugItem(DrfDrug drug) {
    return GestureDetector(
      onTap: () {
        // 약물 세부 정보 페이지로 이동 (추후 구현 필요)
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // 모서리 둥글게
          color: Colors.black.withOpacity(0.2)
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    drug.drugArchive.drugName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  AppFont(
                    '처방 개수 : ${drug.number}',
                    color: const Color(0xff878B93),
                    size: 12,
                  ),
                  const SizedBox(height: 5),
                  AppFont(
                    '복용 시간 : ${drug.time}',
                    color: const Color(0xff878B93),
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
