import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/user/exceptions/user_not_found_exception.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxService {
  String baseUrl = "https://www.neromakebrain.site/api/v1";
  var user = Rxn<NeroUser>();
  var isLoading = false.obs;
  DioService dioService = Get.find<DioService>();

  // Refresh Token 요청 메서드
  Future<void> _refreshTokenRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        throw Exception('리프레시 토큰이 없습니다.');
      }

      final response =
          await dioService.post('/accounts/auth/token/refresh/', data: {
        'refresh': refreshToken,
      });

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        prefs.setString('accessToken', newAccessToken);
        print('토큰이 성공적으로 갱신되었습니다.');
      } else {
        print('토큰 갱신 실패: ${response.data}');
        throw Exception('토큰 갱신 실패');
      }
    } catch (e) {
      print('토큰 갱신 실패: $e');
      throw Exception('토큰 갱신 실패');
    }
  }

  // 자동 로그인 시도 및 유저 정보 로드
  Future<NeroUser?> fetchAndSaveUserInfo() async {
    try {
      final tokens = await getDrfTokens();
      final String? accessToken = tokens['accessToken'];
      final String? refreshToken = tokens['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        var userInfo = await getUserInfoWithTokens(accessToken);

        if (userInfo == null) {
          // 유저 정보 가져오기 실패 시 토큰 갱신 시도
          await _refreshTokenRequest();
          final newAccessToken = (await getDrfTokens())['accessToken'];
          if (newAccessToken != null) {
            userInfo = await getUserInfoWithTokens(newAccessToken);
          }
        }

        if (userInfo != null) {
          user.value = NeroUser.fromJson(userInfo);
          return user.value;
        }
      }
    } on UserNotFoundException catch (e) {
      print("사용자 없음: $e");
      rethrow; // 예외를 다시 던져서 상위에서 처리하도록 함
    } catch (e) {
      print("자동 로그인 실패: $e");
    }
    return null;
  }

  // 토큰을 사용해 유저 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfoWithTokens(
      String accessToken) async {
    final response = await dioService.get('/accounts/userinfo/', params: {
      'access_token': accessToken,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 404) {
      // 사용자가 존재하지 않는 경우
      throw UserNotFoundException();
    } else {
      return null;
    }
  }

  // 카카오 회원가입
  Future<void> signUpWithKakao() async {
    isLoading.value = true;
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      print("kakaoAccessToken : ${token.accessToken}");
      print("kakaoRefreshToken : ${token.refreshToken}");

      // 사용자 정보 가져오기
      User kakaoUser = await UserApi.instance.me();
      String kakaoId = kakaoUser.id.toString();
      String kakaoNickname = kakaoUser.kakaoAccount?.profile?.nickname ?? '';
      print("Kakao ID: $kakaoId");
      print("Kakao Nickname: $kakaoNickname");

      var kakaoAccessToken = token.accessToken;
      // 카카오 회원가입 진행
      final signUpResponse =
          await signUp(kakaoAccessToken, kakaoId, kakaoNickname);

      print("카카오 회원가입 완료");

      // signUp 메서드에서 이미 토큰을 저장했으므로 추가적인 login 호출 제거

      // 이제 AuthenticationController에서 authCheck를 호출하여 인증 상태를 확인하고 라우팅하도록 합니다.
    } catch (e) {
      print('Kakao signup 실패: $e');
      rethrow; // 예외를 다시 던져서 상위에서 처리하도록 함
    } finally {
      isLoading.value = false;
    }
  }

  // DRF 회원가입 함수
  Future<Map<String, dynamic>> signUp(
      String kakaoAccessToken, String? kakaoId, String? nickname) async {
    final response = await http.post(
      Uri.parse('${baseUrl}/accounts/auth/kakao/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'accessToken': kakaoAccessToken,
        'kakaoId': kakaoId,
        'nickname': nickname,
      }),
    );
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final refreshToken = parsed['tokens']['refreshToken'];
      final accessToken = parsed['tokens']['accessToken'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('accessToken', accessToken);
      return parsed;
    } else {
      String responseBody = utf8.decode(response.bodyBytes);
      throw Exception('카카오 인증 실패: $responseBody');
    }
  }

  // 서버로부터 받은 토큰을 저장
  Future<void> saveDrfTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // 클라이언트에 저장된 서버 토큰 불러오기
  Future<Map<String, String?>> getDrfTokens() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');
    print(
        "getDrfToken | accessToken: $accessToken, refreshToken: $refreshToken");
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  // 클라이언트 토큰 삭제
  Future<void> clearDrfTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  // 로그아웃 메서드 추가
  Future<void> logout() async {
    user.value = null;
    await clearDrfTokens(); // 로그아웃 시 토큰 삭제
    Future.microtask(() => Get.offAllNamed('/login')); // 빌드 후 라우팅
  }
}
