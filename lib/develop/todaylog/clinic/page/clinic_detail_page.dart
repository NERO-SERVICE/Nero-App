import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/todaylog/clinic/model/clinic.dart';
import '../controller/clinic_controller.dart';

class ClinicDetailPage extends StatelessWidget {
  final int clinicId;
  final ClinicController controller = Get.find<ClinicController>();

  ClinicDetailPage({Key? key, required this.clinicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchClinicDetail(clinicId);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '진료 기록'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CustomLoadingIndicator());
        }

        final clinic = controller.clinicDetail.value;
        if (clinic == null) {
          return Center(
            child: Text(
              "클리닉 세부 사항을 찾을 수 없습니다.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          children: [
            SizedBox(height: kToolbarHeight + 80),
            Text(
              '최근 진료일',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD9D9D9),
              ),
            ),
            const SizedBox(height: 20),
            _buildDateSelector('Recent Day', clinic.recentDay.obs),
            const SizedBox(height: 30),
            _divider,
            const SizedBox(height: 20),
            Text(
              '다음 예약 진료일',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD9D9D9),
              ),
            ),
            const SizedBox(height: 20),
            _buildDateSelector('Next Day', clinic.nextDay.obs),
            const SizedBox(height: 30),
            _divider,
            const SizedBox(height: 20),
            Text(
              '등록 약물',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD9D9D9),
              ),
            ),
            const SizedBox(height: 20),
            _buildDrugList(clinic),
            const SizedBox(height: 30),
            _divider,
            const SizedBox(height: 20),
            Text(
              '특이사항',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD9D9D9),
              ),
            ),
            const SizedBox(height: 20),
            _clinicDescription(clinic.description),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  bool isDeleted = await controller.deleteClinic(clinicId);
                  if (isDeleted) {
                    Get.back(result: true);
                  } else {
                    Get.snackbar(
                      '삭제 실패',
                      '클리닉 삭제를 실패했습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deleteButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '삭제하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      }),
    );
  }

  Widget get _divider => const Divider(
    color: Color(0xff3C3C3E),
    indent: 0,
    endIndent: 0,
  );

  Widget _buildDateSelector(String label, Rx<DateTime> date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD9D9D9)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('yyyy년 MM월 dd일').format(date.value),
            style: const TextStyle(color: Colors.white),
          ),
          const Icon(Icons.calendar_today, size: 16, color: Color(0xff3C3C3C)),
        ],
      ),
    );
  }

  Widget _buildDrugList(Clinic clinic) {
    return Column(
      children: clinic.drugs.map((drug) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xff1C1B1B),
            border: Border.all(
              color: const Color(0xffD0EE17),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            title: Text(
              '${drug.myDrugArchive.drugName} ${drug.myDrugArchive.capacity}mg · ${drug.initialNumber}정 (${drug.time})',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _clinicDescription(String? description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1C1B1B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        description ?? '설명이 없습니다.',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
