import 'package:get/get.dart';
import 'package:nero_app/drf/clinic/controller/drf_clinic_controller.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';

class DrfClinicWriteController extends GetxController {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();

  // 클리닉 정보
  final Rx<DrfClinic> clinic = DrfClinic(
    clinicId: 1,
    owner: 1,
    nickname: '',
    recentDay: DateTime.now(),
    nextDay: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    title: '',
    description: '',
    drugs: [],
  ).obs;

  // 상태 관리
  RxBool isPossibleSubmit = false.obs;
  final recentDay = DateTime.now().obs;
  final nextDay = DateTime.now().obs;

  // 위치 정보
  final Rxn<double> clinicLatitude = Rxn<double>();
  final Rxn<double> clinicLongitude = Rxn<double>();

  // Drug 관리
  var drugs = <DrfDrug>[].obs;

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
  }

  Future<void> _loadClinicDetail(int clinicId) async {
    var clinicData = await _clinicRepository.getClinic(clinicId);
    if (clinicData != null) {
      clinic(clinicData);
      drugs.addAll(clinicData.drugs);
      if (clinicData.clinicLatitude != null &&
          clinicData.clinicLongitude != null) {
        clinicLatitude.value = clinicData.clinicLatitude;
        clinicLongitude.value = clinicData.clinicLongitude;
      }
    }
  }

  void _isValidSubmitPossible() {
    if (clinic.value.title.isNotEmpty &&
        clinic.value.recentDay != null &&
        clinic.value.nextDay != null) {
      isPossibleSubmit(true);
    } else {
      isPossibleSubmit(false);
    }
  }

  void changeTitle(String value) {
    clinic.update((val) {
      if (val != null) {
        clinic.value = val.copyWith(title: value);
      }
    });
  }

  void changeDescription(String value) {
    clinic.update((val) {
      if (val != null) {
        clinic.value = val.copyWith(description: value);
      }
    });
  }

  void addDrug(DrfDrug drug) {
    drugs.add(drug);
  }

  void removeDrug(int index) {
    drugs.removeAt(index);
  }

  void changeLocationLabel(String value) {
    clinic.update((val) {
      if (val != null) {
        clinic.value = val.copyWith(locationLabel: value);
      }
    });
  }

  void changeLocation(double? latitude, double? longitude) {
    clinicLatitude.value = latitude;
    clinicLongitude.value = longitude;
    clinic.update((val) {
      if (val != null) {
        clinic.value = val.copyWith(
          clinicLatitude: latitude,
          clinicLongitude: longitude,
        );
      }
    });
  }

  Future<void> createClinic() async {
    try {
      DrfClinic newClinic = clinic.value.copyWith(
        clinicLatitude: clinicLatitude.value,
        clinicLongitude: clinicLongitude.value,
        recentDay: recentDay.value,
        nextDay: nextDay.value,
        drugs: drugs.toList(),
      );

      final createdClinic = await _clinicRepository.createClinic(newClinic);
      if (createdClinic != null) {
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

  Future<void> updateClinic(DrfClinic clinicData) async {
    try {
      DrfClinic updatedClinic = clinicData.copyWith(
        title: clinic.value.title,
        description: clinic.value.description,
        recentDay: clinic.value.recentDay,
        nextDay: clinic.value.nextDay,
        clinicLatitude: clinicLatitude.value,
        clinicLongitude: clinicLongitude.value,
        locationLabel: clinic.value.locationLabel,
        drugs: drugs.toList(),
      );

      bool success = await _clinicRepository.updateClinic(updatedClinic);
      if (success) {
        final clinicController = Get.find<DrfClinicController>();
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

  Future<void> deleteClinic(int clinicId) async {
    try {
      bool success = await _clinicRepository.deleteClinic(clinicId);
      if (success) {
        final clinicController = Get.find<DrfClinicController>();
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
