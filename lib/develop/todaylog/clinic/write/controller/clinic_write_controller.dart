import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';

import '../../controller/clinic_controller.dart';
import '../../model/clinic.dart';
import '../../model/drug.dart';
import '../../model/drug_archive.dart';
import '../../model/my_drug_archive.dart';
import '../../repository/clinic_repository.dart';

class ClinicWriteController extends GetxController {
  final ClinicRepository _clinicRepository = ClinicRepository();

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

  RxBool isPossibleSubmit = false.obs;
  final recentDay = DateTime.now().obs;
  final nextDay = DateTime.now().obs;
  var drugs = <Drug>[].obs;
  var drugArchives = <DrugArchive>[].obs;
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
        CustomSnackbar.show(
          context: Get.context!,
          message: '진료기록 생성을 실패했습니다.',
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '진료기록 생성을 실패했습니다.',
        isSuccess: false,
      );
    }
  }


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
        CustomSnackbar.show(
          context: Get.context!,
          message: '진료기록 수정을 실패했습니다.',
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '진료기록 수정을 실패했습니다.',
        isSuccess: false,
      );
    }
  }


  Future<void> deleteClinic(int clinicId) async {
    try {
      bool success = await _clinicRepository.deleteClinic(clinicId);
      if (success) {
        final clinicController = Get.find<ClinicController>();
        clinicController.fetchClinics();
        Get.back(result: true);
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: '진료기록 삭제를 실패했습니다.',
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '진료기록 삭제를 실패했습니다.',
        isSuccess: false,
      );
    }
  }
}
