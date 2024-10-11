import 'package:flutter/material.dart';
import 'screen/shopTable.dart'; // shopTable.dart 파일 경로 수정

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beacorder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Beacoder User Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        backgroundColor: Colors.white70,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu_outlined)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh_outlined)),
        ],
        iconTheme: IconThemeData(color: Colors.brown),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'myPage'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // 2개의 열로 구성된 그리드
          padding: const EdgeInsets.all(32.0),
          childAspectRatio: 0.8, // 버튼 비율 조정
          children: List.generate(4, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopTable()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4.0, right: 8.0, left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.brown, // 버튼 배경색 변경
                      borderRadius: BorderRadius.circular(8.0), // 둥근 모서리 조정
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54, // 그림자 색상 변경
                          offset: Offset(0, 6), // 그림자 위치
                          blurRadius: 3.0, // 흐림 정도 조정
                        ),
                      ],
                    ),
                    height: 120.0, // 버튼 높이 증가
                    width: double.infinity, // 버튼 너비 조정
                  ),
                ),
                const SizedBox(height: 16.0), // 버튼과 레이블 간의 간격 추가
                Text(
                  '가게 이름 ${index + 1}', // 가게 이름 텍스트
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
