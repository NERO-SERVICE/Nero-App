import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/clinic/controller/drf_clinic_controller.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/page/drf_clinic_list_page.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';

class DrfClinicWriteController extends GetxController {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();

  // Form fields controllers
  final titleController = TextEditingController();
  final recentDay = DateTime.now().obs;
  final nextDay = DateTime.now().obs;

  // Drug management
  var drugs = <DrfDrug>[].obs;

  void addDrug(DrfDrug drug) {
    drugs.add(drug);
  }

  void removeDrug(int index) {
    drugs.removeAt(index);
  }

  Future<void> createClinic() async {
    try {
      DrfClinic newClinic = DrfClinic(
        clinicId: 0,
        owner: 1,
        nickname: '',
        recentDay: recentDay.value,
        nextDay: nextDay.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: titleController.text,
        drugs: drugs.toList(),
      );

      final createdClinic = await _clinicRepository.createClinic(newClinic);
      if (createdClinic != null) {
        // 새로 생성된 클리닉을 추가하고 리스트를 업데이트
        final clinicController = Get.find<DrfClinicController>();
        clinicController.clinics.add(createdClinic);
        clinicController.fetchClinics();

        Get.back(result: true);
      } else {
        Get.snackbar('Error', 'Failed to create clinic');
      }
    } catch (e) {
      print('Failed to create clinic: $e');
      Get.snackbar('Error', 'Failed to create clinic');
    }
  }


  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
