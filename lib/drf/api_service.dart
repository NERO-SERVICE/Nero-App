import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<Map<String, dynamic>> sendTokenToServer(String accessToken) async {
    print("-----Apiservice의 sendTokentoServer 실행-----");
    print('Sending access token to server: $accessToken');

    final response = await http.post(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/auth/kakao/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'access_token': accessToken}),
    );

    if (response.statusCode == 200) {
      print('Received response from server: ${response.body}');
      return json.decode(utf8.decode(response.bodyBytes));  // UTF-8로 디코딩
    } else {
      print('Failed to authenticate with Kakao: ${response.body}');
      throw Exception('Failed to authenticate with Kakao: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    print("-----Apiservice의 getUserInfo 실행------");
    final response = await http.get(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/userinfo/$uid/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Received user info from server: ${response.body}');
      return json.decode(utf8.decode(response.bodyBytes)); // 한글 디코딩 문제 해결
    } else {
      print('Failed to load user info: ${response.body}');
      throw Exception('Failed to load user info: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> checkNickname(String nickname) async {
    print("-----Apiservice의 checkNickname 실행-----");
    final response = await http.get(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/check-nickname/?nickname=$nickname'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to check nickname: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> signUp(Map<String, dynamic> user) async {
    print("-----Apiservice의 signUp 실행-----");
    final response = await http.post(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> signUpWithKakao(String uid) async {
    print("-----Apiservice의 signUpWithKakao 실행-----");
    final response = await http.post(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/signup/kakao/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid}),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to sign up with Kakao: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> user) async {
    print("-----Apiservice의 updateUser 실행-----");
    final response = await http.put(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/user/update/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<Map<String, dynamic>> completeSignup(Map<String, dynamic> user) async {
    print("-----Apiservice의 completeSignup 실행-----");
    final response = await http.post(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/signup/complete/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to complete signup');
    }
  }
}
