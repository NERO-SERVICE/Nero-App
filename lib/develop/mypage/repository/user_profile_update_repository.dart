import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/mypage/model/user_update_profile.dart';

class UserProfileUpdateRepository {
  final DioService _dio = Get.find<DioService>();

  // 사용자 정보 가져오기
  Future<UserUpdateProfile?> getUserInfo() async {
    try {
      final response = await _dio.get('/accounts/mypage/userinfo/');
      return UserUpdateProfile.fromJson(response.data);
    } catch (e) {
      print('Failed to load user info: $e');
      return null;
    }
  }

  // 사용자 정보 업데이트 (이미지 제외)
  Future<bool> updateUserInfo(UserUpdateProfile userInfo) async {
    try {
      Map<String, dynamic> data = userInfo.toJson(); // 이미지 제외한 정보만 포함

      final response = await _dio.patch('/accounts/update/', data: data);
      return response.statusCode == 200;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('Failed to update user info: ${e.response?.statusCode}');
        print('Error details: ${e.response?.data}');
      } else {
        print('Failed to update user info: ${e.message}');
      }
      throw e;
    } catch (e) {
      print('Failed to update user info: $e');
      throw e;
    }
  }

  // 프로필 이미지 업로드
  Future<bool> uploadProfileImage(File image) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'profile_image': await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await _dio.patchFormData('/accounts/update/', formData: formData);

      return response.statusCode == 200;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('Failed to upload profile image: ${e.response?.statusCode}');
        print('Error details: ${e.response?.data}');
      } else {
        print('Failed to upload profile image: ${e.message}');
      }
      throw e;
    } catch (e) {
      print('Failed to upload profile image: $e');
      throw e;
    }
  }
}
