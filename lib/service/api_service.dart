import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/menu_dto.dart';
import '../models/store_dto.dart';
import 'token_service.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api/v1/consumer';
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 요청 전에 토큰을 추가
        String? token = await _tokenService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        // 토큰 만료 시 처리
        if (error.response?.statusCode == 401) {
          // 토큰 갱신 로직 추가 가능
        }
        return handler.next(error);
      },
    ));
  }

  Future<void> kakaoLogin(Map<String, dynamic> userInfo) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: userInfo,
      );
      if (response.statusCode == 200) {
        // TokenService를 사용하여 토큰 저장
        await _tokenService.saveAccessToken(response.data['access']);
        await _tokenService.saveRefreshToken(response.data['refresh']);
      } else {
        throw Exception('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('카카오 로그인 요청 실패: $e');
    }
  }

  // 가게 목록 가져오기
  Future<List<StoreDTO>> fetchStoreList(List<String> uuidList) async {
    try {
      final response = await _dio.post(
        '$baseUrl/store',
        data: {'uuid_list': uuidList},
      );
      if (response.statusCode == 200) {
        List<dynamic> storeJson = response.data;
        return storeJson.map((json) => StoreDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load store list');
      }
    } catch (e) {
      throw Exception('가게 목록 가져오기 실패: $e');
    }
  }

  // 특정 가게의 메뉴 리스트 가져오기
  Future<List<MenuDTO>> fetchMenu(int storeId) async {
    try {
      final response = await _dio.get('$baseUrl/store/$storeId');
      if (response.statusCode == 200) {
        List<dynamic> menuJson = response.data;
        return menuJson.map((json) => MenuDTO.fromJson(json)).toList();
      } else {
        throw Exception('메뉴를 불러오지 못했습니다.');
      }
    } catch (e) {
      throw Exception('메뉴 가져오기 실패: $e');
    }
  }

  // 주문 생성
  Future<void> createOrder(String token, int storeId, List<Map<String, dynamic>> orderDetail) async {
    try {
      final response = await _dio.post(
        '$baseUrl/order/create',
        data: {
          'store_id': storeId,
          'order_detail': orderDetail,
          'user_token': token,
        },
      );
      if (response.statusCode == 200) {
        print("주문 생성 성공");
      } else {
        print("주문 생성 실패: ${response.data}");
      }
    } catch (e) {
      throw Exception('주문 생성 실패: $e');
    }
  }
}