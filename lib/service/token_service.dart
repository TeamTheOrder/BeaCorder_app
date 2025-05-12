import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Access 토큰 저장
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: 'accessToken', value: token);
  }

  // Refresh 토큰 저장
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refreshToken', value: token);
  }

  // Access 토큰 가져오기
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  // Refresh 토큰 가져오기
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refreshToken');
  }

  // Access 토큰 삭제
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: 'accessToken');
  }

  // Refresh 토큰 삭제
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: 'refreshToken');
  }

  // 모든 토큰 삭제
  Future<void> deleteAllTokens() async {
    await _secureStorage.deleteAll();
  }
}