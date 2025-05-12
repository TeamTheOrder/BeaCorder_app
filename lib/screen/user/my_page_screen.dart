import 'package:flutter/material.dart';
import '../../providers/kakao_provider.dart';

class MyPageScreen extends StatelessWidget {
  final KakaoProvider kakaoProvider = KakaoProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: kakaoProvider.getUserInfoFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else {
          final userInfo = snapshot.data;
          final userName = userInfo?['nickname'] ?? '사용자 닉네임';

          return Scaffold(
            appBar: AppBar(
              title: Text('마이페이지'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 30),
                      ),
                      SizedBox(width: 16),
                      Text(
                        userName + '님 환영합니다',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity, // Full width
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '내 포인트',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                            Text(
                              '0', // Example points
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Add navigation or action for "내역보기"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(double.infinity, 48), // Full width button
                          ),
                          child: Text('내역보기', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildListItem('포인트 교환소', Icons.card_giftcard, context),
                        _buildListItem('이벤트', Icons.event, context),
                        _buildListItem('공지사항', Icons.announcement, context),
                        _buildListItem('고객센터', Icons.support_agent, context),
                        _buildListItem('설정', Icons.settings, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildListItem(String title, IconData icon, BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          leading: Icon(icon, color: Colors.black),
          title: Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            // Add navigation or action here
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }
}