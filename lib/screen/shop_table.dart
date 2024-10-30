import 'package:flutter/material.dart';
import '../models/cart.dart'; // 장바구니 모델
import 'package:http/http.dart' as http;
import 'dart:convert';
import './option_selection.dart'; // OptionSelectionScreen import
import '../models/menu_dto.dart'; // MenuDTO import
import '../service/api_service.dart'; // ApiService import

class ShopTable extends StatefulWidget {
  final int storeId; // 가게 ID
  final String shopName;
  final String shopImg;

  const ShopTable({Key? key, required this.storeId, required this.shopName, required this.shopImg}) : super(key: key);

  @override
  _ShopTableState createState() => _ShopTableState();
}

class _ShopTableState extends State<ShopTable> {
  List<MenuDTO> menuItems = [];
  bool isLoading = true;
  Cart cart = Cart(); // 장바구니 인스턴스 생성

  @override
  void initState() {
    super.initState();
    fetchMenu(); // 메뉴 데이터를 가져오는 함수 호출
  }

  Future<void> fetchMenu() async {
    try {
      // ApiService에서 메뉴 데이터를 가져와 menuItems에 저장
      List<MenuDTO> fetchedMenu = await ApiService.fetchMenu(widget.storeId);
      setState(() {
        menuItems = fetchedMenu;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 주문하기 API 호출
  Future<void> placeOrder() async {
    List<Map<String, dynamic>> orderDetail = cart.items.map((item) {
      return {
        'menu_id': item.menuId,
        'opt_id': item.selectedOptions.map((option) => option['id']).toList(),
      };
    }).toList();

    final orderData = {
      'store_id': widget.storeId,
      'order_detail': orderDetail,
    };

    final response = await http.post(
      Uri.parse('http://yourserver.com/api/order/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      // 주문 성공 처리
      print('Order placed successfully');
      cart.clearCart(); // 주문 후 장바구니 비움
    } else {
      // 주문 실패 처리
      print('Failed to place order: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴 목록'),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 가게 대표 이미지와 이름을 포함한 헤더
            ShopHeader(shopName: widget.shopName, shopImg: widget.shopImg),

            // 메뉴 목록: 서버에서 받은 데이터를 바탕으로 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                '메뉴 목록',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true, // 부모의 크기에 맞춰 크기를 조정
              physics: const NeverScrollableScrollPhysics(), // 외부 스크롤만 허용
              itemCount: menuItems.length, // 메뉴 데이터 개수
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return GestureDetector(
                  onTap: () {
                    // 옵션 선택 화면으로 이동, 메뉴 정보 전달
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OptionSelectionScreen(
                          menuId: item.id,
                          menuName: item.name,
                          menuImg: item.menuImg,
                          menuDescription: "메뉴 설명", // 설명이 있는 경우 여기에 추가
                          oList: item.oList,
                          storeId: widget.storeId, // 가게 ID 전달
                        ),
                      ),
                    );
                  },
                  child: Padding(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item.menuImg,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('이미지 없음'),
                                );
                              },
                            ),
                          )
                        ),
                        const SizedBox(width: 16.0),
                        // 메뉴 텍스트 정보
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name, // 서버에서 받은 메뉴 이름
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              const Text(
                                '상품 설명', // 임시 설명
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '₩${item.price}', // 서버에서 받은 메뉴 가격
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // 하단에 주문하기 버튼
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       await placeOrder(); // 주문 생성
      //     },
      //     child: const Text(''),
      //   ),
      // ),
    );
  }
}

class ShopHeader extends StatelessWidget {
  final String shopName; // 가게 이름을 받는 변수 추가
  final String shopImg;

  const ShopHeader({Key? key, required this.shopName, required this.shopImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 대표 이미지
        Container(
          width: double.infinity,
          height: 200.0, // 이미지 높이 설정
          child: Image.network(
            shopImg, // 임시 가게 이미지 URL
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300], // 회색 배경
                child: const Center(
                  child: Text('이미지 추가 예정'),
                ),
              );
            },
          ),
        ),
        // 가게 이름
        Padding(
          padding: const EdgeInsets.all(16.0), // 이름과 이미지 간의 여백
          child: Text(
            shopName, // 가게 이름 표시
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
