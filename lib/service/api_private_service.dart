import 'package:dio/dio.dart';
import 'token_service.dart';

class ApiPrivateService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio();

  ApiPrivateService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 요청 전에 토큰을 추가합니다.
        String? token = await _tokenService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        // 토큰이 만료된 경우 처리합니다.
        if (error.response?.statusCode == 401) {
          // 토큰 갱신 로직을 추가할 수 있습니다.
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String url) async {
    return await _dio.get(url);
  }

  Future<Response> post(String url, Map<String, dynamic> data) async {
    return await _dio.post(url, data: data);
  }

// 추가적인 API 메서드를 여기에 작성할 수 있습니다.
}