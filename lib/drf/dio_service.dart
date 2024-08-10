import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService { // 로그인유저 세션 관리
  Dio _dio = Dio();
  String _accessToken = '';
  String _refreshToken = '';

  DioService() {
    BaseOptions options = BaseOptions(
      baseUrl: "https://neromakebrain.site/api/v1",
      connectTimeout: const Duration(seconds: 10),  // 연결 타임아웃 시간
      receiveTimeout: const Duration(seconds: 15),  // 응답 타임아웃 시간
      headers: {
        'Content-Type': 'application/json',
      }
    );

    _dio = Dio(options);
    _initializeInterceptors();
  }

  Future<void> _initializeTokens() async { // 서버 토큰 클라이언트에 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken') ?? '';
    _refreshToken = prefs.getString('refreshToken') ?? '';
  }

  void _initializeInterceptors() { // accessToke 만료 시 서버에 refreshToken으로 요청
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _initializeTokens();
        if (_accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && _refreshToken.isNotEmpty) {
          try {
            await _refreshTokenRequest();
            final opts = e.requestOptions;
            opts.headers['Authorization'] = 'Bearer $_accessToken';
            final response = await _dio.request(opts.path,
                options: Options(
                    method: opts.method,
                    headers: opts.headers,
                    responseType: opts.responseType),
                data: opts.data,
                queryParameters: opts.queryParameters);
            return handler.resolve(response);
          } catch (error) {
            return handler.reject(e);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> _refreshTokenRequest() async {
    try {
      final response = await _dio.post('/accounts/auth/token/refresh', data: {
        'refreshToken': _refreshToken,
      });
      if (response.statusCode == 200) {
        _accessToken = response.data['accessToken'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', _accessToken);
      }
    } catch (e) {
      throw Exception('Failed to refresh token');
    }
  }

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    return _dio.get(url, queryParameters: params);
  }

  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    return _dio.post(url, data: data);
  }

  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    return _dio.put(url, data: data);
  }

  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    return _dio.delete(url, data: data);
  }
}

