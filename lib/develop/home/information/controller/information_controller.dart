import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
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
        CustomSnackbar.show(
          context: Get.context!,
          message: '공지사항이 생성되었습니다.',
          isSuccess: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '공지사항 생성에 실패했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
