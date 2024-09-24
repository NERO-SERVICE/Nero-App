import 'package:get/get.dart';

import '../../controller/clinic_controller.dart';
import '../../model/clinic.dart';
import '../../model/drug.dart';
import '../../model/drug_archive.dart';
import '../../model/my_drug_archive.dart';
import '../../repository/clinic_repository.dart';

class ClinicWriteController extends GetxController {
  final ClinicRepository _clinicRepository = ClinicRepository();

  // 클리닉 정보
  final Rx<Clinic> clinic = Clinic(
    clinicId: 1,
    owner: 1,
    nickname: '',
    recentDay: DateTime.now(),
    nextDay: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    description: '',
    drugs: [],
  ).obs;

  // 상태 관리
  RxBool isPossibleSubmit = false.obs;
  final recentDay = DateTime.now().obs;
  final nextDay = DateTime.now().obs;

  // Drug 관리
  var drugs = <Drug>[].obs;

  // 약물 아카이브 관리
  var drugArchives = <DrugArchive>[].obs;

  // 수정 모드 여부
  bool isEditMode = false;

  @override
  void onInit() {
    super.onInit();
    var clinicId = Get.parameters['clinic_id'];
    if (clinicId != null) {
      isEditMode = true;
      _loadClinicDetail(int.parse(clinicId));
    }
    clinic.stream.listen((event) {
      _isValidSubmitPossible();
    });
    _loadDrugArchives();
  }

  Future<void> _loadClinicDetail(int clinicId) async {
    var clinicData = await _clinicRepository.getClinic(clinicId);
    if (clinicData != null) {
      clinic(clinicData);
      drugs.addAll(clinicData.drugs);
    }
  }

  Future<void> _loadDrugArchives() async {
    try {
      final archives = await _clinicRepository.getDrugArchives();
      drugArchives.assignAll(archives);
    } catch (e) {
      print('_loadDrugArchives를 실패했습니다: $e');
    }
  }

  void _isValidSubmitPossible() {
    isPossibleSubmit(true);
  }

  void changeDescription(String value) {
    clinic.update((val) {
      if (val != null) {
        clinic.value = val.copyWith(description: value);
      }
    });
  }

  void addDrug(Drug drug) {
    drugs.add(drug);
  }

  void removeDrug(int index) {
    drugs.removeAt(index);
  }

  void addDrugToClinic(DrugArchive drugArchive, int number, String time) {
    final myDrugArchive = MyDrugArchive(
      myArchiveId: drugArchive.archiveId,
      owner: clinic.value.owner,
      archiveId: drugArchive.archiveId,
      drugName: drugArchive.drugName,
      target: drugArchive.target,
      capacity: drugArchive.capacity,
    );

    final drug = Drug(
      drugId: 0,
      myDrugArchive: myDrugArchive,
      number: number,
      initialNumber: number,
      time: time,
      allow: true,
    );

    addDrug(drug);
  }

  // 클리닉 생성
  Future<void> createClinic() async {
    try {
      Clinic newClinic = clinic.value.copyWith(
        recentDay: recentDay.value,
        nextDay: nextDay.value,
        drugs: drugs.toList(),
      );

      final createdClinic = await _clinicRepository.createClinic(newClinic);
      if (createdClinic != null) {
        final clinicController = Get.find<ClinicController>();
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

  // 클리닉 업데이트
  Future<void> updateClinic(Clinic clinicData) async {
    try {
      Clinic updatedClinic = clinicData.copyWith(
        description: clinic.value.description,
        recentDay: clinic.value.recentDay,
        nextDay: clinic.value.nextDay,
        drugs: drugs.toList(),
      );

      bool success = await _clinicRepository.updateClinic(updatedClinic);
      if (success) {
        final clinicController = Get.find<ClinicController>();
        clinicController.fetchClinics();
        Get.back(result: true);
      } else {
        Get.snackbar('Error', 'Failed to update clinic');
      }
    } catch (e) {
      print('Failed to update clinic: $e');
      Get.snackbar('Error', 'Failed to update clinic');
    }
  }

  // 클리닉 삭제
  Future<void> deleteClinic(int clinicId) async {
    try {
      bool success = await _clinicRepository.deleteClinic(clinicId);
      if (success) {
        final clinicController = Get.find<ClinicController>();
        clinicController.fetchClinics();
        Get.back(result: true);
      } else {
        Get.snackbar('Error', 'Failed to delete clinic');
      }
    } catch (e) {
      print('Failed to delete clinic: $e');
      Get.snackbar('Error', 'Failed to delete clinic');
    }
  }
}
