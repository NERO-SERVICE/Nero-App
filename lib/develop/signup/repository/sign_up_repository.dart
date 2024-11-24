import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';

class SignUpRepository {
  final DioService _dio = Get.find<DioService>();

  Future<bool> settingUserInfo(NeroUser user) async {
    try {
      final response = await _dio.patch(
        '/accounts/update/',
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('서버 오류: ${response.data}');
        return false;
      }
    } catch (e) {
      print('알 수 없는 오류: $e');
      return false;
    }
  }
}
