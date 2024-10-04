import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';

class SignUpRepository {
  final DioService _dio = DioService();

  Future<bool> settingUserInfo(NeroUser user) async {
    try {
      final response = await _dio.patch(
        '/accounts/update/',
        data: user.toJson(),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
