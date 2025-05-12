import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../providers/kakao_provider.dart';

class LoginScreen extends StatelessWidget {
  final KakaoProvider kakaoProvider = KakaoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg1.png',
              fit: BoxFit.cover,
            ),
          ),
          // 버튼 영역
          Positioned(
            bottom: 40, // 화면 하단에서 40px 위로 배치
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 첫 번째 버튼: Guest로 시작하기
                GestureDetector(
                  onTap: () async {
                    await kakaoProvider.guestLogin(); // 게스트 로그인
                    Navigator.pushReplacementNamed(context, '/main'); // 메인 화면으로 이동
                  },
                  child: Image.asset(
                    'assets/images/guest_lg_btn.png', // 게스트 로그인 버튼 이미지
                    width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                    height: (MediaQuery.of(context).size.width * 0.8) * 45 / 300, // 비율 300:45 유지
                  ),
                ),
                SizedBox(height: 16), // 버튼 간 간격
                // 두 번째 버튼: 카카오 로그인
                GestureDetector(
                  onTap: () async {
                    OAuthToken? token = await kakaoProvider.login();
                    if (token != null) {
                      User? user = await kakaoProvider.getUserInfo();
                      if (user != null) {
                        String id = user.id.toString();
                        String name = user.kakaoAccount?.profile?.nickname ?? '';
                        String nickname = user.kakaoAccount?.profile?.nickname ?? '';
                        String gender = user.kakaoAccount?.gender.toString() ?? '';
                        String ageRange = user.kakaoAccount?.ageRange.toString() ?? '';
                        String phoneNumber = user.kakaoAccount?.phoneNumber ?? '';
                        await kakaoProvider.saveUserInfo(id, name, nickname, gender, ageRange, token.accessToken, phoneNumber, 'kakao');
                        Navigator.pushReplacementNamed(context, '/main');
                      }
                    }
                  },
                  child: Image.asset(
                    'assets/images/kakao_lg_btn.png', // 카카오 로그인 버튼 이미지
                    width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                    height: (MediaQuery.of(context).size.width * 0.8) * 45 / 300, // 비율 300:45 유지
                  ),
                ),
                SizedBox(height: 16), // 버튼 간 간격
                // 세 번째 버튼: Apple ID 로그인
                GestureDetector(
                  onTap: () {
                    // Apple ID 버튼 클릭 시 동작
                  },
                  child: Image.asset(
                    'assets/images/apple_lg_btn.png', // Apple ID 버튼 이미지
                    width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                    height: (MediaQuery.of(context).size.width * 0.8) * 45 / 300, // 비율 300:45 유지
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}