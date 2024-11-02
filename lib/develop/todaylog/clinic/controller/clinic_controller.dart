import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/todaylog/clinic/model/drug.dart';
import 'package:nero_app/develop/todaylog/clinic/model/drug_archive.dart';
import 'package:nero_app/develop/todaylog/clinic/model/my_drug_archive.dart';
import '../model/clinic.dart';
import '../repository/clinic_repository.dart';

class ClinicController extends GetxController {
  final ClinicRepository _clinicRepository = Get.find<ClinicRepository>();

  var clinics = <Clinic>[].obs;
  var clinicDetail = Rxn<Clinic>(); // 특정 클리닉 상세 정보 저장
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var drugArchives = <DrugArchive>[].obs; // drugArchives 필드 추가

  @override
  void onInit() {
    super.onInit();
    fetchClinics();
    loadDrugArchives(); // 약물 아카이브 불러오기
  }

  // 약물 아카이브 불러오기 메서드 추가
  void loadDrugArchives() async {
    try {
      drugArchives.value = await _clinicRepository.getDrugArchives();
    } catch (e) {
      errorMessage('약물 아카이브 불러오기 실패');
    }
  }

  // 약물 추가 메서드 추가
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

    clinicDetail.value?.drugs.add(drug);
    clinicDetail.refresh(); // 업데이트 알림
  }


  // 클리닉 목록 가져오기
  void fetchClinics() async {
    try {
      isLoading(true);
      errorMessage('');
      var fetchedClinics = await _clinicRepository.fetchClinics();
      clinics.value = fetchedClinics;
    } catch (e) {
      errorMessage('클리닉 데이터를 불러오는 중 오류가 발생했습니다.');
    } finally {
      isLoading(false);
    }
  }

  // 특정 클리닉 세부 정보 가져오기
  Future<void> fetchClinicDetail(int clinicId) async {
    try {
      isLoading(true);
      errorMessage('');
      clinicDetail.value = await _clinicRepository.getClinic(clinicId);
      print('Fetched clinic detail: ${clinicDetail.value}');
    } catch (e) {
      errorMessage('클리닉 세부 정보를 불러오는 중 오류가 발생했습니다.');
      print('Error fetching clinic detail: $e');
    } finally {
      isLoading(false);
    }
  }

  // 특정 클리닉 데이터를 로드하여 수정 모드로 설정하기
  void loadClinicForEdit(int clinicId) async {
    await fetchClinicDetail(clinicId);
  }

  // 클리닉 설명 업데이트
  void changeDescription(String description) {
    if (clinicDetail.value != null) {
      clinicDetail.value = clinicDetail.value!.copyWith(description: description);
    }
  }

  // 특정 클리닉 업데이트
  Future<bool> updateClinic() async {
    if (clinicDetail.value == null) return false;
    try {
      isLoading(true);
      errorMessage('');
      bool isUpdated = await _clinicRepository.updateClinic(clinicDetail.value!);
      if (isUpdated) {
        await fetchClinicDetail(clinicDetail.value!.clinicId); // 최신 데이터로 업데이트
        return true;
      } else {
        errorMessage('클리닉 업데이트에 실패했습니다.');
        return false;
      }
    } catch (e) {
      errorMessage('클리닉 정보를 업데이트하는 중 오류가 발생했습니다.');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // 특정 클리닉의 약물 리스트 가져오기
  List<Drug> getDrugsForClinic(int clinicId) {
    return clinics.firstWhere((clinic) => clinic.clinicId == clinicId).drugs;
  }

  // 약물 추가
  void addDrug(Drug drug) {
    clinicDetail.value?.drugs.add(drug);
    clinicDetail.refresh();
  }

  // 약물 삭제
  void removeDrug(int index) {
    clinicDetail.value?.drugs.removeAt(index);
    clinicDetail.refresh();
  }

  Future<bool> deleteClinic(int clinicId) async {
    try {
      bool success = await _clinicRepository.deleteClinic(clinicId);
      if (success) {
        fetchClinics(); // 삭제 후 클리닉 목록 갱신
        Get.back(result: true);
        return true;
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: '진료기록 삭제를 실패했습니다.',
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '진료기록 삭제를 실패했습니다.',
        isSuccess: false,
      );
      return false;
    }
  }
}
