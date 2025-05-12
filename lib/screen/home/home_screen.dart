import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../models/store_dto.dart';
import '../../service/api_service.dart';
import '../../service/ble_service.dart';
import 'store_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<StoreDTO> stores = [];
  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessage.listen(showFirebaseMessage);
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackGroundHandler);

    startScanningAndFetchStores(); // BLE 스캔과 가게 목록 가져오는 함수 호출
  }

  Future<void> startScanningAndFetchStores() async {
    setState(() {
      isLoading = true; // 스캔 중 로딩 표시
    });
    try {
      BleService.uuidList = [
        "74278bdab64445208f0c720eaf059935",
        "f7a3e806f5bb43f8ba870783669ebeb9",
        "cbd5696feb2547e0ba3d5e9a6a7fc1f0",
        "e14ffe8a8ece4c3c97811e3d30d8f195"
      ];
      List<StoreDTO> fetchedStores = await _apiService.fetchStoreList(BleService.uuidList);

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
        title: Text('Nearby Stores'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
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
              final storeProvider = Provider.of<StoreProvider>(context, listen: false);
              storeProvider.setSelectedStore(store);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreMainScreen(),
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
                      boxShadow: const [
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () async {
          await startScanningAndFetchStores();
        },
        child: const Icon(Icons.refresh_outlined, color: Colors.white), // BLE 스캔 버튼 아이콘
        tooltip: '다시 스캔',
      ),
    );
  }
}