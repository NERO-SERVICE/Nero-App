import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
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

  Future<bool> createClinic() async {
    try {
      DrfClinic newClinic = DrfClinic(
        clinicId: 0, // 이 필드는 서버에서 처리됨
        owner: 1, // 이 필드는 서버에서 처리됨
        recentDay: recentDay.value,
        nextDay: nextDay.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: titleController.text,
        drugs: drugs.toList(),
      );

      final result = await _clinicRepository.createClinic(newClinic);
      return result != null;
    } catch (e) {
      print('Failed to create clinic: $e');
      return false;
    }
  }


  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
