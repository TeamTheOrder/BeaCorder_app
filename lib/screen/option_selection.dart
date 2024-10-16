import 'package:flutter/material.dart';
import '../models/cart_item.dart'; // CartItem import
import '../models/cart.dart'; // Cart import (장바구니 모델)

class OptionSelectionScreen extends StatefulWidget {
  final int menuId;
  final String menuName;
  final String menuDescription;
  final String menuImg;
  final List<Map<String, dynamic>> oList; // 옵션 리스트
  final int storeId; // 가게 ID 추가

  const OptionSelectionScreen({
    Key? key,
    required this.menuId,
    required this.menuName,
    required this.menuDescription,
    required this.menuImg,
    required this.oList,
    required this.storeId,
  }) : super(key: key);

  @override
  _OptionSelectionScreenState createState() => _OptionSelectionScreenState();
}

class _OptionSelectionScreenState extends State<OptionSelectionScreen> {
  List<Map<String, dynamic>> selectedOptions = []; // 선택된 옵션 리스트
  Cart cart = Cart(); // 장바구니 인스턴스 (전역 관리 가정)

  // 옵션 선택 토글 함수
  void toggleOption(Map<String, dynamic> option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuName),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            // 메뉴 이미지
            Image.network(
              widget.menuImg,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('이미지 없음'));
              },
            ),
            const SizedBox(height: 16),

            // 메뉴 설명
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.menuDescription,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // 옵션 선택 리스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                '옵션 선택',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.oList.length,
              itemBuilder: (context, index) {
                final option = widget.oList[index];
                return CheckboxListTile(
                  title: Text(option['name']),
                  subtitle: Text('가격: ${option['price']}원'),
                  value: selectedOptions.contains(option),
                  onChanged: (bool? selected) {
                    toggleOption(option);
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // 장바구니 추가 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 장바구니에 상품 추가
                  cart.addItem(CartItem(
                    menuId: widget.menuId,
                    menuName: widget.menuName,
                    selectedOptions: selectedOptions,
                    price: widget.oList[0]['price'], // 가격은 기본 가격만 일단 적용
                  ));
                  Navigator.pop(context); // 상품 추가 후 화면을 닫음
                },
                child: const Text('장바구니에 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
