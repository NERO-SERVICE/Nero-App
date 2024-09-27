import 'package:get/get.dart';
import 'package:nero_app/develop/home/information/model/information.dart';
import 'package:nero_app/develop/home/information/repository/information_repository.dart';

class InformationController extends GetxController {
  final InformationRepository _informationRepository = InformationRepository();
  var informations = <Information>[].obs;
  var isLoading = false.obs;
  var currentInformation = Information.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchInformations();
  }

  Future<void> fetchInformations() async {
    isLoading.value = true;
    try {
      final result = await _informationRepository.getInformations();
      informations.assignAll(result);
    } catch (e) {
      print('공지사항을 불러오는 데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchInformation(int infoId) async {
    isLoading.value = true;
    try {
      final information = await _informationRepository.getInformation(infoId);
      if (information != null) {
        currentInformation.value = information;
      }
    } catch (e) {
      print('특정 공지사항을 불러오는 데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createInformation(Information information) async {
    isLoading.value = true;
    try {
      final newInformation =
          await _informationRepository.createInformation(information);
      if (newInformation != null) {
        informations.add(newInformation);
        Get.snackbar('성공', '공지사항이 성공적으로 생성되었습니다.');
      }
    } catch (e) {
      Get.snackbar('실패', '공지사항 생성에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}
