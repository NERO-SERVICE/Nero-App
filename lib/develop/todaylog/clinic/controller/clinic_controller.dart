import 'package:get/get.dart';

import '../model/clinic.dart';
import '../model/drug.dart';
import '../repository/clinic_repository.dart';

class ClinicController extends GetxController {
  final ClinicRepository _clinicRepository = ClinicRepository();
  var clinics = <Clinic>[].obs;
  var isLoading = true.obs; // 로딩 상태
  var errorMessage = ''.obs; // 오류 메시지

  @override
  void onInit() {
    super.onInit();
    fetchClinics();
  }

  void fetchClinics() async {
    try {
      isLoading(true); // 로딩 시작
      errorMessage(''); // 이전 오류 메시지 초기화

      // 2초 딜레이 추가 (실제 네트워크 요청 대기 시간 대체)
      await Future.delayed(Duration(seconds: 2));

      var fetchedClinics = await _clinicRepository.getClinics();
      clinics.value = fetchedClinics;
    } catch (e) {
      print('Failed to fetch clinics: $e');
      errorMessage('클리닉 데이터를 불러오는 중 오류가 발생했습니다.');
    } finally {
      isLoading(false); // 로딩 종료
    }
  }

  Future<void> addClinicAndUpdateList(Clinic newClinic) async {
    clinics.add(newClinic);
    fetchClinics();
  }

  List<Drug> getDrugsForClinic(int clinicId) {
    return clinics.firstWhere((clinic) => clinic.clinicId == clinicId).drugs;
  }

  Future<bool> updateClinic(Clinic clinic) async {
    return await _clinicRepository.updateClinic(clinic);
  }

  Future<bool> deleteClinic(int clinicId) async {
    return await _clinicRepository.deleteClinic(clinicId);
  }
}
