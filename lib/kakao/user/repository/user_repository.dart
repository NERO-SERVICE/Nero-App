import 'package:nero_app/kakao/api_service.dart';
import 'package:nero_app/kakao/user/model/user_model.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  Future<User> authenticateWithKakao(String accessToken) async {
    final response = await apiService.sendTokenToServer(accessToken);
    return User.fromJson(response);
  }

  Future<User> getUserInfo() async {
    // 서버에서 사용자 정보를 가져오는 로직을 여기에 추가합니다.
    // 예를 들어, 사용자 정보를 저장한 세션이나 토큰을 이용해 서버에 요청합니다.
    final response = await apiService.getUserInfoFromServer();
    return User.fromJson(response);
  }
}
