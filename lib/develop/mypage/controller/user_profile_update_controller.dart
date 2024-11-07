// lib/develop/mypage/controller/user_profile_update_controller.dart

import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/mypage/model/user_update_profile.dart';
import 'package:nero_app/develop/mypage/repository/user_profile_update_repository.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';

class UserProfileUpdateController extends GetxController {
  final UserProfileUpdateRepository _repository = UserProfileUpdateRepository();
  final DioService _dioService = Get.find<DioService>();

  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  var selectedSex = ''.obs;
  var selectedImage = Rxn<File>(); // 선택된 이미지 관리
  var profileImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    try {
      final userInfo = await _repository.getUserInfo();
      if (userInfo != null) {
        nicknameController.text = userInfo.nickname.isNotEmpty ? userInfo.nickname : '';
        emailController.text = userInfo.email.isNotEmpty ? userInfo.email : '';
        birthController.text = userInfo.birth.isNotEmpty ? userInfo.birth : '';
        selectedSex.value = userInfo.sex.isNotEmpty ? userInfo.sex : '';
        profileImageUrl.value = '${_dioService.baseDomain}${userInfo.profileImageUrl}';
      } else {
        nicknameController.text = '';
        emailController.text = '';
        birthController.text = '';
        selectedSex.value = '';
        profileImageUrl.value = '';
      }
    } catch (e) {
      print('사용자 정보 가져오기 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '사용자 정보를 불러오는 데 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      print('이미지 선택 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '이미지 선택에 실패했습니다.',
        isSuccess: false,
      );
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
        // 이미지가 선택된 경우 프로필 이미지 업로드
        if (selectedImage.value != null) {
          final imageSuccess = await _repository.uploadProfileImage(selectedImage.value!);
          if (imageSuccess) {
            CustomSnackbar.show(
              context: Get.context!,
              message: '프로필이 성공적으로 업데이트되었습니다.',
              isSuccess: true,
            );
            _fetchUserInfo();
            Get.back();
          } else {
            CustomSnackbar.show(
              context: Get.context!,
              message: '프로필 정보는 업데이트되었으나, 이미지 업로드에 실패했습니다.',
              isSuccess: false,
            );
          }
        } else {
          CustomSnackbar.show(
            context: Get.context!,
            message: '프로필이 성공적으로 업데이트되었습니다.',
            isSuccess: true,
          );
          Get.back();
        }
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: '프로필 업데이트에 실패했습니다.',
          isSuccess: false,
        );
      }
    } catch (e) {
      String errorMessage = '프로필 업데이트 중 오류가 발생했습니다.';
      CustomSnackbar.show(
        context: Get.context!,
        message: errorMessage,
        isSuccess: false,
      );
    }
  }
}
