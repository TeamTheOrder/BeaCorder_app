import 'package:flutter/material.dart';
import './screen/shopTable.dart'; // ShopTable import
import './service/api_service.dart'; // ApiService import
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
      home: const MyHomePage(title: ''),
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
    fetchStores(); // 서버에서 가게 목록을 가져오는 함수 호출
  }

  Future<void> fetchStores() async {
    try {
      // UUID 리스트를 사용하여 서버에서 가게 목록을 가져옴
      List<StoreDTO> fetchedStores = await ApiService.fetchStoreList();
      setState(() {
        stores = fetchedStores;
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
        title: Text(widget.title),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu_outlined)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_outlined)),
        ],
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'My Page'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
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
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 6),
                    blurRadius: 12.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    store.storeImg, // 서버에서 받은 대표 이미지
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('이미지 없음');
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    store.storeName, // 가게 이름 표시
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
