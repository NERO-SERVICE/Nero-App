import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrfAuthenticationRepository extends GetxService {
  String baseUrl = "https://www.neromakebrain.site/api/v1";
  var user = Rxn<DrfUserModel>();
  var isLoading = false.obs;
  DioService dioService = DioService();

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
      User user = await UserApi.instance.me();
      String kakaoId = user.id.toString();
      String kakaoNickname = user.kakaoAccount?.profile?.nickname ?? '';
      print("Kakao ID: $kakaoId");
      print("Kakao Nickname: $kakaoNickname");

      var kakaoAccessToken = token.accessToken;
      // 카카오 회원가입 진행
      await signUp(kakaoAccessToken, kakaoId, kakaoNickname);

      print("카카오 회원가입 완료");

      if(kakaoAccessToken != null) {
        loginWithKakao();
      }
    } catch (e) {
      print('Kakao signup failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithKakao() async {
    isLoading.value = true;
    try {
      // 서버로 토큰을 전송하고 응답을 받아옵니다.
      final responseData = await login();
      user.value = DrfUserModel.fromJson(responseData['user']);
      print(user.value);
      print("유저 ID: ${user.value?.uid}");
    } catch (e) {
      print('Kakao login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    user.value = null;
    await clearDrfTokens(); // 로그아웃 시 토큰 삭제
  }

  // DRF 회원가입 함수
  Future<Map<String, dynamic>> signUp(String kakaoAccessToken, String? kakaoId, String? nickname) async {
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
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      String responseBody = utf8.decode(response.bodyBytes);
      throw Exception('Failed to authenticate with Kakao: $responseBody');
    }
  }

  // 로그인
  Future<Map<String, dynamic>> login() async {
    final response = await dioService.post('/accounts/login/');
    if (response.statusCode == 200) {
      return response.data;
    } else {
    String responseBody = response.data;
    throw Exception('Failed to authenticate with Kakao: $responseBody');
    }
  }

  // 유저 id에 따른 유저 정보 불러오기
  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    final response = await dioService.post('/accounts/userinfo/$uid/');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load user info: ${response.data}');
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
    print("getDrfToken | accessToken: ${accessToken}, refreshToken: ${refreshToken}");
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  // 클라이언트 토큰 삭제
  Future<void> clearDrfTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}
