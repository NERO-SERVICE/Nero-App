import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';

class SignUpRepository {
  final DioService _dio = DioService();

  Future<bool> settingUserInfo(NeroUser user) async {
    try {
      // 서버로 전송할 데이터 출력 (디버그용)
      final dataToSend = user.toJson();
      print('서버로 보내는 데이터: $dataToSend'); // 전송하는 데이터를 확인

      final response = await _dio.patch(
        '/accounts/${user.userId}/update/',
        data: dataToSend, // toJson으로 변환된 데이터를 보냄
      );

      return response.statusCode == 200;
    } catch (e) {
      print('유저 프로필 설정을 실패했습니다: $e');
      return false;
    }
  }
}
