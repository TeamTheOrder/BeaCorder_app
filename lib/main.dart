import 'package:flutter/material.dart';
import './screen/shop_table.dart'; // ShopTable import
import './service/api_service.dart'; // ApiService import
import './service/ble_service.dart'; // BleService import
import './models/store_dto.dart'; // StoreDTO import

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
      home: const MyHomePage(title: '가게 검색'),
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
  bool isLoading = true;
  List<StoreDTO> stores = [];

  @override
  void initState() {
    super.initState();
    startScanningAndFetchStores(); // BLE 스캔과 가게 목록 가져오는 함수 호출
  }

  // BLE 스캔을 시작하고 UUID 리스트가 업데이트되면 서버에서 가게 목록을 가져옴
  Future<void> startScanningAndFetchStores() async {
    setState(() {
      isLoading = true; // 스캔 중 로딩 표시
    });
    try {
      // BLE 스캔 시작
      await BleService.startBleScan();

      // BLE 스캔 완료 후 UUID 리스트를 기반으로 서버에서 가게 목록 가져오기
      List<StoreDTO> fetchedStores = await ApiService.fetchStoreList(BleService.uuidList);

      setState(() {
        stores = fetchedStores;
        isLoading = false; // 로딩 완료 후 화면에 데이터 표시
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
        title: Text(widget.title),
        backgroundColor: Colors.white,
        // titleTextStyle: const TextStyle(
        //   fontSize: 20,
        //   fontWeight: FontWeight.bold,
        //   fontStyle: FontStyle.italic,
        // ),
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu_outlined)),
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   onTap: (index) {},
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'My Page'),
      //     BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      //   ],
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중 표시
          : GridView.count(
        crossAxisCount: 2, // 2개의 열로 구성된 그리드
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 0.8,
        children: List.generate(stores.length, (index) {
          final store = stores[index];
          return GestureDetector(
            onTap: () {
              // 가게 ID를 ShopTable로 전달
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopTable(
                    storeId: store.storeId,
                    shopName: store.storeName,
                    shopImg: store.examImg,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0), // 둥글게 설정
                      boxShadow: const [  // 추가적인 그림자 설정 (선택 사항)
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias, // 둥근 효과 적용
                    child: Image.network(
                      store.storeImg, // 서버에서 받은 대표 이미지
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('이미지 없음');
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    store.storeName, // 가게 이름 표시
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      // 플로팅 버튼 추가 (스캔 다시 시작)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () async {
          // 스캔 다시 시작
          await startScanningAndFetchStores();
        },
        child: const Icon(Icons.refresh_outlined , color: Colors.white), // BLE 스캔 버튼 아이콘
        tooltip: '다시 스캔',
      ),
    );
  }
}
