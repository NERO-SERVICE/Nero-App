import 'package:get/get.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';

class DrfClinicController extends GetxController {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();
  var clinics = <DrfClinic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClinics();
  }

  void fetchClinics() async {
    try {
      var fetchedClinics = await _clinicRepository.getClinics();
      clinics.value = fetchedClinics;
    } catch (e) {
      print('Failed to fetch clinics: $e');
    }
  }

  List<DrfDrug> getDrugsForClinic(int clinicId) {
    return clinics.firstWhere((clinic) => clinic.clinicId == clinicId).drugs;
  }

  Future<bool> updateClinic(DrfClinic clinic) async {
    return await _clinicRepository.updateClinic(clinic);
  }

  Future<bool> deleteClinic(int clinicId) async {
    return await _clinicRepository.deleteClinic(clinicId);
  }
}
