import 'package:flutter/material.dart';

class ShopTable extends StatelessWidget {
  const ShopTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 가게 대표 이미지와 이름을 포함한 헤더
            ShopHeader(),

            // 메뉴 리스트: 메뉴 목록을 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '메뉴 목록',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // 메뉴 목록을 보여주는 ListView.builder 추가
            ListView.builder(
              shrinkWrap: true, // 부모의 크기에 맞춰 크기를 조정
              physics: NeverScrollableScrollPhysics(), // 외부 스크롤만 허용
              itemCount: 5, // 임시로 5개의 메뉴 항목
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 메뉴 이미지
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[300], // 기본 배경색 설정
                        ),
                        child: Image.network(
                          'https://example.com/menu-image.jpg', // 임시 이미지
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                '이미지 없음',
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      // 메뉴 텍스트 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Menu Name ${index + 1}', // 임시 메뉴 이름
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'This is a description for menu item ${index + 1}', // 임시 설명
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '\$Price', // 임시 가격
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 대표 이미지
        Container(
          width: double.infinity,
          height: 200.0, // 이미지 높이 설정
          child: Image.network(
            'https://example.com/shop-image.jpg', // 가게 대표 이미지 URL
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // 이미지 로드 실패 시
              return Container(
                color: Colors.grey[300], // 회색 배경
                child: Center(
                  child: Text(
                    '이미지 추가 예정',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 가게 이름
        Padding(
          padding: const EdgeInsets.all(16.0), // 이름과 이미지 간의 여백
          child: Text(
            'ShopName',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
