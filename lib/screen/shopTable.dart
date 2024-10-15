import 'package:flutter/material.dart';
import '../models/menu_dto.dart'; // MenuDTO import
import '../service/api_service.dart'; // ApiService import

class ShopTable extends StatefulWidget {
  final int storeId; // 가게 ID
  final String shopName; // 가게 이름

  const ShopTable({Key? key, required this.storeId, required this.shopName}) : super(key: key);

  @override
  _ShopTableState createState() => _ShopTableState();
}

class _ShopTableState extends State<ShopTable> {
  List<MenuDTO> menuItems = [];
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName), // AppBar에 가게 이름 표시
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
            ShopHeader(shopName: widget.shopName),

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
                          'https://example.com/menu-image.jpg', // 임시 이미지, 실제 API로 교체 필요
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                '이미지 없음',
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
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
                            Text(
                              '메뉴 설명 없음', // 임시 설명, 필요시 API에서 추가
                              style: const TextStyle(
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
  final String shopName; // 가게 이름을 받는 변수 추가

  const ShopHeader({Key? key, required this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 대표 이미지
        Container(
          width: double.infinity,
          height: 200.0, // 이미지 높이 설정
          child: Image.asset(
            'assets/images/cafeExampleImg.png', // 로컬 이미지 사용
            fit: BoxFit.cover,
          ),
        ),
        // 가게 이름
        Padding(
          padding: const EdgeInsets.all(16.0), // 이름과 이미지 간의 여백
          child: Text(
            shopName, // 전달받은 가게 이름을 표시
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
