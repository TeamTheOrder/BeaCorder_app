import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../common/cart.dart';
import '../common/menu_detail.dart';

class StoreMainScreen extends StatefulWidget {
  @override
  _StoreMainScreenState createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      if (storeProvider.selectedStore != null) {
        menuProvider.fetchMenu(storeProvider.selectedStore!.storeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final store = storeProvider.selectedStore;

    const double menuImageSize = 120.0; // 메뉴 이미지 크기 변수
    const double menuTextSize = 20.0; // 메뉴 텍스트 크기 변수

    if (store == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Store Details'),
        ),
        body: Center(
          child: Text('No store selected.'),
        ),
      );
    }

    int totalCartPrice = cartProvider.cartItems.fold(0, (sum, item) => sum + item.totalPrice);
    int cartItemCount = cartProvider.cartItems.length;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  },
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    final bool isCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

                    return FlexibleSpaceBar(
                      title: isCollapsed ? Text(store.storeName) : null,
                      background: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          store.storeImg,
                          fit: BoxFit.cover,
                        ),
                      ),
                      collapseMode: CollapseMode.pin,
                    );
                  },
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        store.storeName,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<MenuProvider>(
                      builder: (context, menuProvider, child) {
                        if (menuProvider.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (menuProvider.errorMessage.isNotEmpty) {
                          return Center(child: Text(menuProvider.errorMessage));
                        } else {
                          return Column(
                            children: menuProvider.menus.map((menu) {
                              return GestureDetector(
                                onTap: () {
                                  menuProvider.setSelectedMenu(menu);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuDetailScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        menu.menuImg,
                                        width: menuImageSize,
                                        height: menuImageSize,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              menu.name,
                                              style: TextStyle(fontSize: menuTextSize),
                                            ),
                                            Text(
                                              '${menu.price}원',
                                              style: TextStyle(fontSize: menuTextSize),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (cartItemCount > 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.cyan, // 폰트 컬러 흰색, 배경색 진한 파란색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 모서리를 살짝 둥글게
                    ),
                    textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500), // 폰트 크기 키우기
                    minimumSize: Size(double.infinity, 60), // 버튼의 높이 조절
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => CartScreen(),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$totalCartPrice원 '),
                      Text('●', style: TextStyle(fontSize: 20, color: Colors.white)),
                      SizedBox(width: 8.0),
                      Text('장바구니 보기'),
                      SizedBox(width: 8.0),
                      Transform.translate(
                        offset: Offset(0, 3), // y축으로 2픽셀 내리기
                        child: CircleAvatar(
                          radius: 12, // 크기 조정
                          backgroundColor: Colors.white,
                          child: Text(
                            '$cartItemCount',
                            style: TextStyle(fontSize: 15, color: Colors.cyan), // 폰트 크기 조정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}