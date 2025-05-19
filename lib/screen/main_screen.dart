import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'order/order_progress_screen.dart';
import 'order/order_history_screen.dart';
import 'user/my_page_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    OrderProgressScreen(),
    OrderHistoryScreen(),
    MyPageScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex -= 1; // 이전 탭으로 이동
      });
      return false; // 뒤로가기 동작 중단
    } else {
      // 앱 종료 확인 팝업 표시
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('앱 종료'),
          content: Text('앱을 종료하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // 팝업 닫기
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // 종료 확인
              child: Text('종료'),
            ),
          ],
        ),
      ) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.brown,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: '주문 진행',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '주문 내역',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }
}