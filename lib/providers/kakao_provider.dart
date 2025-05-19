import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/api_service.dart';

class KakaoProvider {
  final ApiService _apiService = ApiService();

  Future<OAuthToken?> login() async {
    try {
      // 카카오톡 로그인
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공: ${token.accessToken}');

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      print('사용자 정보: ${user.kakaoAccount?.profile?.nickname}');

      // 사용자 정보를 API에 전달
      Map<String, dynamic> userInfo = {
        'id': user.id.toString(),
        'name': user.kakaoAccount?.profile?.nickname ?? '',
        'nickname': user.kakaoAccount?.profile?.nickname ?? '',
        'gender': user.kakaoAccount?.gender?.toString() ?? '',
        'ageRange': user.kakaoAccount?.ageRange?.toString() ?? '',
        'phoneNumber': user.kakaoAccount?.phoneNumber ?? '',
      };

      // ApiService의 kakaoLogin 호출
      await _apiService.kakaoLogin(userInfo);

      return token;
    } catch (e) {
      print('카카오톡으로 로그인 실패: $e');
      return null;
    }
  }

  Future<void> guestLogin() async {
    try {
      // SharedPreferences에 게스트 유저 정보 저장
      await saveGuestUserInfo();

      // 저장된 게스트 유저 정보 가져오기
      final guestInfo = await getUserInfoFromPrefs();

      // API 호출
      if (guestInfo['id'] != null) {
        await _apiService.kakaoLogin({
          'id': guestInfo['id']!,
          'name': guestInfo['name'] ?? 'Guest',
          'nickname': guestInfo['nickname'] ?? 'Guest',
          'gender': guestInfo['gender'] ?? 'unknown',
          'ageRange': guestInfo['ageRange'] ?? 'unknown',
          'phoneNumber': guestInfo['phoneNumber'] ?? 'unknown',
        });
        print('게스트 로그인 성공: ${guestInfo['id']}');
      } else {
        print('게스트 정보가 없습니다.');
      }
    } catch (e) {
      print('게스트 로그인 실패: $e');
    }
  }

  Future<User?> getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보: ${user.kakaoAccount?.profile?.nickname}');
      return user;
    } catch (e) {
      print('사용자 정보 가져오기 실패: $e');
      return null;
    }
  }

  Future<void> saveUserInfo(String id, String name, String nickname, String gender, String ageRange, String token, String phoneNumber, String loginType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('name', name);
    await prefs.setString('nickname', nickname);
    await  prefs.setString('gender', gender);
    await prefs.setString('ageRange', ageRange);
    await prefs.setString('token', token);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('loginType', loginType); // 로그인 타입 저장
    await prefs.setBool('isLoggedIn', true); // 로그인 여부 저장
  }

  Future<void> saveGuestUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', 'guest_${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString('name', 'Guest');
    await prefs.setString('nickname', 'Guest');
    await prefs.setString('gender', 'unknown');
    await prefs.setString('ageRange', 'unknown');
    await prefs.setString('token', 'guest_token');
    await prefs.setString('phoneNumber', 'unknown');
    await prefs.setString('loginType', 'guest'); // 로그인 타입: 게스트
    await prefs.setBool('isLoggedIn', true); // 로그인 여부 저장
  }

  Future<Map<String, String?>> getUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('id'),
      'name': prefs.getString('name'),
      'nickname': prefs.getString('nickname'),
      'gender': prefs.getString('gender'),
      'ageRange': prefs.getString('ageRange'),
      'token': prefs.getString('token'),
      'phoneNumber': prefs.getString('phoneNumber'),
      'loginType': prefs.getString('loginType'), // 로그인 타입 반환
    };
  }
}