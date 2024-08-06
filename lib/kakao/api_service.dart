import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<Map<String, dynamic>> sendTokenToServer(String accessToken) async {
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

  Future<Map<String, dynamic>> getUserInfoFromServer() async {
    final response = await http.get(
      Uri.parse('https://www.neromakebrain.site/api/v1/accounts/userinfo/'),
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
}
