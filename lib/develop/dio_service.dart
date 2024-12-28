import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'dart:async';
import 'package:nero_app/develop/user/controller/authentication_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  late dio.Dio _dio;
  String _accessToken = '';
  String _refreshToken = '';

  final Completer<void> _tokenInitializationCompleter = Completer<void>();

  DioService() {
    dio.BaseOptions options = dio.BaseOptions(
      baseUrl: "https://www.neromakebrain.site/api/v1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _dio = dio.Dio(options);
    _initializeTokens();
    _initializeInterceptors();
  }

  String get baseDomain {
    Uri baseUri = Uri.parse(_dio.options.baseUrl);
    return "${baseUri.scheme}://${baseUri.host}";
  }

  Future<void> _initializeTokens() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('accessToken') ?? '';
      _refreshToken = prefs.getString('refreshToken') ?? '';
    } catch (e) {
      print('토큰 초기화 중 오류 발생: $e');
    } finally {
      // 토큰 초기화 완료 알림
      if (!_tokenInitializationCompleter.isCompleted) {
        _tokenInitializationCompleter.complete();
      }
    }
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
        // 요청 시 requireToken 플래그 확인
        bool requireToken = options.extra['requireToken'] != false;

        if (requireToken) {
          // 토큰 초기화 완료될 때까지 대기
          if (!_tokenInitializationCompleter.isCompleted) {
            await _tokenInitializationCompleter.future;
          }

          if (_accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          } else {
            // 액세스 토큰이 없을 경우 예외 처리
            return handler.reject(
              dio.DioException(
                requestOptions: options,
                error: '액세스 토큰이 없습니다.',
                type: dio.DioExceptionType.cancel,
              ),
            );
          }
        }

        return handler.next(options);
      },
      onResponse: (dio.Response response, dio.ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (dio.DioException e, dio.ErrorInterceptorHandler handler) async {
        // 토큰 초기화 완료될 때까지 대기
        if (!_tokenInitializationCompleter.isCompleted) {
          await _tokenInitializationCompleter.future;
        }

        if (e.requestOptions.extra['refreshTokenRequest'] == true) {
          return handler.next(e);
        }

        if (e.response?.statusCode == 401 && _refreshToken.isNotEmpty) {
          dio.RequestOptions options = e.requestOptions;
          int retryCount = options.extra["retryCount"] ?? 0;

          if (retryCount < 2) {
            try {
              await _refreshTokenRequest();
              options.headers['Authorization'] = 'Bearer $_accessToken';
              options.extra["retryCount"] = retryCount + 1;
              final response = await _dio.request(
                options.path,
                options: dio.Options(
                  method: options.method,
                  headers: options.headers,
                  responseType: options.responseType,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );

              return handler.resolve(response);
            } catch (error) {
              Get.find<AuthenticationController>().logout();
              return handler.reject(e);
            }
          } else {
            Get.find<AuthenticationController>().logout();
            return handler.reject(e);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> _refreshTokenRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        throw Exception('리프레시 토큰이 없습니다.');
      }

      final response = await _dio.post(
        '/accounts/auth/token/refresh/',
        data: {'refresh': refreshToken},
        options: dio.Options(
          extra: {'refreshTokenRequest': true},
        ),
      );


      if (response.statusCode == 200) {
        _accessToken = response.data['access'];
        _refreshToken = response.data['refresh'] ?? _refreshToken;
        prefs.setString('accessToken', _accessToken);
        prefs.setString('refreshToken', _refreshToken);
      } else {
        await clearDrfTokens();
        throw Exception('토큰 갱신 실패');
      }
    } catch (e) {
      await clearDrfTokens();
      throw Exception('토큰 갱신 실패');
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
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
    _accessToken = '';
    _refreshToken = '';
  }

  Future<dio.Response<dynamic>> postFormData(String url,
      {dio.FormData? formData}) async {
    return _dio.post(
      url,
      data: formData,
      options: dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<dio.Response<dynamic>> putFormData(String url,
      {dio.FormData? formData}) async {
    return _dio.put(
      url,
      data: formData,
      options: dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<dio.Response<dynamic>> patchFormData(String url,
      {dio.FormData? formData}) async {
    return _dio.patch(
      url,
      data: formData,
      options: dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<dio.Response<dynamic>> deleteFormData(String url,
      {dio.FormData? formData}) async {
    return _dio.delete(
      url,
      data: formData,
      options: dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<dio.Response<dynamic>> get(String url,
      {Map<String, dynamic>? params, bool requireToken = true}) async {
    dio.Options options = dio.Options();
    if (!requireToken) {
      options.extra = {'requireToken': false};
    }
    return _dio.get(url, queryParameters: params, options: options);
  }

  Future<dio.Response<dynamic>> post(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.post(url, data: data);
  }

  Future<dio.Response<dynamic>> put(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.put(url, data: data);
  }

  Future<dio.Response<dynamic>> patch(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.patch(url, data: data);
  }

  Future<dio.Response<dynamic>> delete(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.delete(url, data: data);
  }

  // 외부 API 호출을 위한 Dio 인스턴스 생성
  final dio.Dio externalDio = dio.Dio();

  // 외부 API 호출을 위한 GET 메서드
  Future<dio.Response<dynamic>> externalGet(String url,
      {Map<String, dynamic>? params, bool requireToken = false}) async {
    dio.Options options = dio.Options(
      responseType: dio.ResponseType.plain, // 응답을 String으로 받음
    );
    if (!requireToken) {
      options.extra = {'requireToken': false};
    }
    return externalDio.get(url, queryParameters: params, options: options);
  }
}
