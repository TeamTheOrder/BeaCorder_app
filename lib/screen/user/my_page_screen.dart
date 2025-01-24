import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false; // 로그인 여부를 확인하는 변수
    String userName = "사용자 닉네임"; // 유저 닉네임

    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 환경설정 페이지로 이동하는 로직 추가
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 박스
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30), // 유저 아바타 아이콘
                ),
                SizedBox(width: 16),
                Text(
                  isLoggedIn ? userName : '로그인하고 시작하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 포인트 박스
            Card(
              child: ListTile(
                leading: Icon(Icons.point_of_sale),
                title: Text('포인트'),
                subtitle: Text('현재 포인트: 0'),
              ),
            ),
            SizedBox(height: 20),
            // 혜택정보 박스
            Card(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('혜택정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 3,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // 진행 중인 이벤트 페이지로 이동하는 로직 추가
                          },
                          child: Text('진행 중인 이벤트', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // 종료된 이벤트 페이지로 이동하는 로직 추가
                          },
                          child: Text('종료된 이벤트', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 문의 및 알림 박스
            Card(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('문의 및 알림', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 3,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // 고객센터 페이지로 이동하는 로직 추가
                          },
                          child: Text('고객센터', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // 고객센터 페이지로 이동하는 로직 추가
                          },
                          child: Text('자주묻는질문', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // 공지사항 페이지로 이동하는 로직 추가
                          },
                          child: Text('공지사항', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // 약관 및 정책 페이지로 이동하는 로직 추가
                          },
                          child: Text('약관 및 정책', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}