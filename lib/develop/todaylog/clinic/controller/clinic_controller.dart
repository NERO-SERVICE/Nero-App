import 'package:get/get.dart';

import '../model/clinic.dart';
import '../model/drug.dart';
import '../repository/clinic_repository.dart';


class ClinicController extends GetxController {
  final ClinicRepository _clinicRepository = ClinicRepository();
  var clinics = <Clinic>[].obs;

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
