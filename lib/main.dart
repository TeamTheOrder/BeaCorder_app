import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 리본 삭제 코드
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu_outlined)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh_outlined))
        ],
        iconTheme: IconThemeData(color: Colors.brown),
      ),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'myPage'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
        ]),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),  // 아이콘과 텍스트 사이의 간격
            Text(
              '현재 검색된 가맹점이 존재하지 않습니다.',
              style: TextStyle(
                fontSize: 16,        // 폰트 크기
                fontWeight: FontWeight.bold,  // 폰트 두께
                color: Colors.black54, // 텍스트 색상
              ),
              textAlign: TextAlign.center,  // 텍스트 중앙 정렬
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '가게 찾기',
        child: const Icon(Icons.search_outlined),
      ),
    );
  }
}
