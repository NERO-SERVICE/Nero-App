import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/clinic/controller/drf_clinic_controller.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';
import 'package:nero_app/drf/product/controller/drf_product_controller.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfClinicWriteController extends GetxController {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();
  DrfProductController _drfProductService = DrfProductController();
  final Rx<DrfProduct> product = DrfProduct(
    owner: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    wantTradeLocation: {},
  ).obs;

  // Form fields controllers
  final titleController = TextEditingController();
  final recentDay = DateTime.now().obs;
  final nextDay = DateTime.now().obs;

  // Drug management
  var drugs = <DrfDrug>[].obs;

  // 제품 제목 변경
  void changeTitle(String value) {
    product.value = product.value.copyWith(title: value);
  }

  // 설명 변경
  void changeDescription(String value) {
    product.value = product.value.copyWith(description: value);
  }

  // 거래 위치 변경
  void changeTradeLocationMap(Map<String, dynamic> mapInfo) {
    product.value = product.value.copyWith(
      wantTradeLocationLabel: mapInfo['label'],
      wantTradeLocation: mapInfo['location'] as Map<String, double>,
    );
  }

  // 거래 위치 초기화
  void clearWantTradeLocation() {
    product.value = product.value.copyWith(
      wantTradeLocationLabel: '',
      wantTradeLocation: null,
    );
  }

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
