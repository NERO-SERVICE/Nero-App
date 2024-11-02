import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/mypage/repository/user_profile_update_repository.dart';
import 'package:nero_app/develop/mypage/model/user_update_profile.dart';

class UserProfileUpdateController extends GetxController {
  final UserProfileUpdateRepository _repository = UserProfileUpdateRepository();

  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  var selectedSex = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    final userInfo = await _repository.getUserInfo();
    if (userInfo != null) {
      nicknameController.text = userInfo.nickname.isNotEmpty ? userInfo.nickname : '';
      emailController.text = userInfo.email.isNotEmpty ? userInfo.email : '';
      birthController.text = userInfo.birth.isNotEmpty ? userInfo.birth : '';
      selectedSex.value = userInfo.sex.isNotEmpty ? userInfo.sex : '';
    } else {
      nicknameController.text = '';
      emailController.text = '';
      birthController.text = '';
      selectedSex.value = '';
    }
  }

  void updateUserInfo() async {
    try {
      final userInfo = UserUpdateProfile(
        nickname: nicknameController.text,
        email: emailController.text,
        birth: birthController.text,
        sex: selectedSex.value,
      );
      final success = await _repository.updateUserInfo(userInfo);
      if (success) {
        CustomSnackbar.show(
          context: Get.context!,
          message: '프로필이 성공적으로 업데이트되었습니다.',
          isSuccess: true,
        );
        Get.back();
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: '프로필 업데이트에 실패했습니다.',
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '오류 발생: $e',
        isSuccess: false,
      );
    }
  }
}
