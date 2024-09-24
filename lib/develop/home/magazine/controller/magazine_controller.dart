import 'package:get/get.dart';
import 'package:nero_app/develop/home/magazine/model/magazine.dart';
import 'package:nero_app/develop/home/magazine/repository/magazine_repository.dart';

class MagazineController extends GetxController {
  final MagazineRepository _magazineRepository = MagazineRepository();
  var magazines = <Magazine>[].obs;
  var isLoading = false.obs;
  var currentMagazine = Magazine.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchMagazines();
  }

  // 매거진 리스트 가져오기
  Future<void> fetchMagazines() async {
    isLoading.value = true;
    try {
      final result = await _magazineRepository.getMagazines();
      magazines.assignAll(result);
    } catch (e) {
      print('매거진을 불러오는 데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 특정 매거진 가져오기
  Future<void> fetchMagazine(int magazineId) async {
    isLoading.value = true;
    try {
      final magazine = await _magazineRepository.getMagazine(magazineId);
      if (magazine != null) {
        currentMagazine.value = magazine;
      }
    } catch (e) {
      print('특정 매거진을 불러오는 데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 매거진 생성 (로그인한 유저가 writer로 설정됨)
  Future<void> createMagazine(Magazine magazine) async {
    isLoading.value = true;
    try {
      final newMagazine = await _magazineRepository.createMagazine(magazine);
      if (newMagazine != null) {
        magazines.add(newMagazine);
        Get.snackbar('성공', '매거진이 성공적으로 생성되었습니다.');
      }
    } catch (e) {
      Get.snackbar('실패', '매거진 생성에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 매거진 수정
  Future<void> updateMagazine(Magazine magazine) async {
    isLoading.value = true;
    try {
      final success = await _magazineRepository.updateMagazine(magazine);
      if (success) {
        int index =
            magazines.indexWhere((n) => n.magazineId == magazine.magazineId);
        if (index != -1) {
          magazines[index] = magazine;
          Get.snackbar('성공', '매거진이 성공적으로 수정되었습니다.');
        }
      }
    } catch (e) {
      Get.snackbar('실패', '매거진 수정에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 매거진 삭제
  Future<void> deleteMagazine(int magazineId) async {
    isLoading.value = true;
    try {
      final success = await _magazineRepository.deleteMagazine(magazineId);
      if (success) {
        magazines.removeWhere((n) => n.magazineId == magazineId);
        Get.snackbar('성공', '매거진이 성공적으로 삭제되었습니다.');
      }
    } catch (e) {
      Get.snackbar('실패', '매거진 삭제에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}