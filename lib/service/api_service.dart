import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/menu_dto.dart';
import '../models/store_dto.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';


// 가게 목록을 가져오는 함수 (UUID 리스트를 서버에 전송)
  static Future<List<StoreDTO>> fetchStoreList() async {
    final List<String> uuidList = ['1610-NORMAL-1630-HARD', '1670-NORMAL-1690-HARD']; // UUID 목록

    final response = await http.post(
      Uri.parse('$baseUrl/store'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'uuid_list': uuidList}),
    );

    if (response.statusCode == 200) {
      // UTF-8로 응답을 강제로 디코딩
      var decodedResponse = utf8.decode(response.bodyBytes);
      // 성공적으로 데이터를 받아온 경우, JSON 파싱
      List<dynamic> storeJson = json.decode(decodedResponse);

      // JSON 데이터를 StoreDTO 리스트로 변환
      return storeJson.map((json) => StoreDTO.fromJson(json)).toList();
    } else {
      // 요청 실패 시 예외 처리
      throw Exception('Failed to load store list');
    }
  }


  // 특정 가게의 메뉴 리스트를 가져오는 함수
  static Future<List<MenuDTO>> fetchMenu(int storeId) async {
    final response = await http.get(Uri.parse('$baseUrl/store/$storeId'));

    if (response.statusCode == 200) {
      // utf-8 디코드
      var decodedResponse = utf8.decode(response.bodyBytes);

      // JSON 데이터를 받아서 MenuDTO 리스트로 변환
      List<dynamic> menuJson = json.decode(decodedResponse);
      print(menuJson);
      return menuJson.map((json) => MenuDTO.fromJson(json)).toList();
    } else {
      throw Exception('메뉴를 불러오지 못했습니다.');
    }
  }
}
