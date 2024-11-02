import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/mypage/model/user_update_profile.dart';

class UserProfileUpdateRepository {
  final DioService _dio = Get.find<DioService>();

  Future<UserUpdateProfile?> getUserInfo() async {
    try {
      final response = await _dio.get('/accounts/mypage/userinfo/');
      return UserUpdateProfile.fromJson(response.data);
    } catch (e) {
      print('Failed to load user info: $e');
      return null;
    }
  }

  Future<bool> updateUserInfo(UserUpdateProfile userInfo) async {
    try {
      final response = await _dio.patch('/accounts/update/', data: userInfo.toJson());
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to update user info: $e');
      return false;
    }
  }
}
