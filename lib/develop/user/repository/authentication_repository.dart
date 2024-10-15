import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/user/exceptions/user_not_found_exception.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationRepository extends GetxService {
  String baseUrl = "https://www.neromakebrain.site/api/v1";
  var user = Rxn<NeroUser>();
  var isLoading = false.obs;
  DioService dioService = Get.find<DioService>();

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

        await dioService.saveTokens(newAccessToken, refreshToken);
      } else {
        throw Exception('토큰 갱신 실패');
      }
    } catch (e) {
      throw Exception('토큰 갱신 실패');
    }
  }


  Future<NeroUser?> fetchAndSaveUserInfo() async {
    try {
      final tokens = await getDrfTokens();
      final String? accessToken = tokens['accessToken'];
      final String? refreshToken = tokens['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        var userInfo = await getUserInfoWithTokens(accessToken);

        if (userInfo == null) {
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
      rethrow;
    } catch (e) {
      print("자동 로그인 실패: $e");
    }
    return null;
  }


  Future<Map<String, dynamic>?> getUserInfoWithTokens(
      String accessToken) async {
    final response = await dioService.get('/accounts/userinfo/', params: {
      'access_token': accessToken,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 404) {
      throw UserNotFoundException();
    } else {
      return null;
    }
  }


  Future<Map<String, dynamic>> signUpWithKakao() async {
    isLoading.value = true;
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      User kakaoUser = await UserApi.instance.me();

      var kakaoAccessToken = token.accessToken;
      final signUpResponse = await signUpWithKakaoServer(kakaoAccessToken);

      return signUpResponse;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> signUpWithApple(AuthorizationCredentialAppleID? appleCredential) async {
    // appleCredential이 null일 때는 서버에서 token 갱신을 처리하도록 할 수 있습니다.
    if (appleCredential == null) {
      throw Exception('Apple Credential is null');
    }

    final response = await http.post(
      Uri.parse('${baseUrl}/accounts/auth/apple/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'identityToken': appleCredential.identityToken,
        'authorizationCode': appleCredential.authorizationCode,
      }),
    );

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final refreshToken = parsed['tokens']['refreshToken'];
      final accessToken = parsed['tokens']['accessToken'];
      final needsSignup = parsed['needsSignup'] ?? false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('accessToken', accessToken);
      await prefs.setBool('needsSignup', needsSignup);

      // 로그인 후 즉시 토큰 반영
      await dioService.saveTokens(accessToken, refreshToken);

      return {
        'refreshToken': refreshToken,
        'accessToken': accessToken,
        'needsSignup': needsSignup,
      };
    } else {
      String responseBody = utf8.decode(response.bodyBytes);
      throw Exception('Apple 인증 실패: $responseBody');
    }
  }

  Future<Map<String, dynamic>> signUpWithKakaoServer(String kakaoAccessToken) async {
    final response = await http.post(
      Uri.parse('${baseUrl}/accounts/auth/kakao/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'accessToken': kakaoAccessToken,
      }),
    );
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final refreshToken = parsed['tokens']['refreshToken'];
      final accessToken = parsed['tokens']['accessToken'];
      final needsSignup = parsed['needsSignup'] ?? false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('accessToken', accessToken);
      await prefs.setBool('needsSignup', needsSignup);

      // 로그인 후 즉시 토큰 반영
      await dioService.saveTokens(accessToken, refreshToken);

      return {
        'refreshToken': refreshToken,
        'accessToken': accessToken,
        'needsSignup': needsSignup,
      };
    } else {
      String responseBody = utf8.decode(response.bodyBytes);
      throw Exception('카카오 인증 실패: $responseBody');
    }
  }


  Future<void> saveDrfTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    await dioService.saveTokens(accessToken, refreshToken);
  }


  Future<Map<String, String?>> getDrfTokens() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');
    print(
        "getDrfToken | accessToken: $accessToken, refreshToken: $refreshToken");
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }


  Future<void> clearDrfTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    await dioService.clearDrfTokens();
  }


  Future<void> logout() async {
    user.value = null;
    await clearDrfTokens();
    Future.microtask(() => Get.offAllNamed('/login'));
  }

  Future<void> updateUserInfo(Map<String, dynamic> updatedInfo) async {
    try {
      final tokens = await getDrfTokens();
      final String? accessToken = tokens['accessToken'];
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await dioService.patch('/userinfo/', data: updatedInfo);
      if (response.statusCode == 200) {
        final updatedUser = NeroUser.fromJson(response.data);
        user.value = updatedUser;
      } else {
        throw Exception('사용자 정보 업데이트 실패');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final tokens = await getDrfTokens();
      final String? accessToken = tokens['accessToken'];

      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await dioService.delete('/accounts/delete/');

      if (response.statusCode == 204) {
        await clearDrfTokens();
        return true;
      } else {
        throw Exception('회원 탈퇴 실패: ${response.data}');
      }
    } catch (e) {
      throw e;
    }
  }
}
