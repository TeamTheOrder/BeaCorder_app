import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 내역'),
      ),
      body: Center(
        child: Text('주문 내역 화면'),
      ),
    );
  }
}