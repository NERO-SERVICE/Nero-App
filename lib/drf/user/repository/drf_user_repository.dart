import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/drf/api_service.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';

// class DrfUserRepository {
//   final ApiService apiService;
//
//   DrfUserRepository({required this.apiService});
//
//   Future<User> authenticateWithKakao(String accessToken) async {
//     final response = await apiService.sendTokenToServer(accessToken);
//     return User.fromJson(response);
//   }
//
//   Future<User> getUserInfo() async {
//     // 서버에서 사용자 정보를 가져오는 로직을 여기에 추가합니다.
//     // 예를 들어, 사용자 정보를 저장한 세션이나 토큰을 이용해 서버에 요청합니다.
//     final response = await apiService.getUserInfoFromServer();
//     return User.fromJson(response);
//   }
// }

class DrfUserRepository extends GetxService {
  final ApiService apiService;

  DrfUserRepository({required this.apiService});

  Future<DrfUserModel?> findUserOne(String uid) async {
    print("----findUserOne----");
    try {
      final response = await apiService.getUserInfo(uid);
      return DrfUserModel.fromJson(response);
    } catch (e) {
      print('Error finding user: $e');
      return null;
    }
  }

  Future<bool> checkDuplicationNickName(String nickname) async {
    print("----checkDuplicationNickName----");
    try {
      final response = await apiService.checkNickname(nickname);
      return response['is_available'] as bool;
    } catch (e) {
      print('Error checking nickname: $e');
      return false;
    }
  }

  Future<String?> signupWithKakao(String uid) async {
    print("----signupWithKakao----");
    try {
      final response = await apiService.signUpWithKakao(uid);
      return response['id'] as String?;
    } catch (e) {
      print('Error signing up user: $e');
      return null;
    }
  }
}