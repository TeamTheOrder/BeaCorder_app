import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_dto.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../models/menu_dto.dart';
import '../../models/option_dto.dart';

class MenuDetailScreen extends StatefulWidget {
  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  final Map<String, bool> _selectedOptions = {};
  final Map<String, String> _selectedRequiredOptions = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      if (menuProvider.selectedMenu != null) {
        // 필요한 초기화 작업이 있다면 여기에 추가
      }
    });
  }

  int _calculateTotalPrice(MenuDTO menu) {
    int totalPrice = menu.price;

    menu.oList.forEach((option) {
      if (option.required == true && _selectedRequiredOptions[option.name] == option.name) {
        totalPrice += option.price;
      } else if (_selectedOptions[option.name] == true) {
        totalPrice += option.price;
      }
    });

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final menu = menuProvider.selectedMenu;

    const double menuImageSize = 120.0;
    const double menuTextSize = 20.0;

    if (menu == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Menu Details'),
        ),
        body: Center(
          child: Text('No menu selected.'),
        ),
      );
    }

    final requiredOptions = menu.oList.where((option) => option.required == true).toList();
    final additionalOptions = menu.oList.where((option) => option.required != true).toList();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    final bool isCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

                    return FlexibleSpaceBar(
                      title: isCollapsed ? Text(
                        menu.name,
                        style: TextStyle(fontSize: menuTextSize, fontWeight: FontWeight.bold),
                      ) : null,
                      background: Container(
                        color: Colors.white,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            menu.menuImg,
                            fit: BoxFit.cover,
                          ),
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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu.name,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            menu.description ?? '메뉴 소개',
                            style: TextStyle(fontSize: menuTextSize),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '가격',
                                style: TextStyle(fontSize: menuTextSize),
                              ),
                              Text(
                                '${menu.price}원',
                                style: TextStyle(fontSize: menuTextSize),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (requiredOptions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '필수 옵션',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            ...requiredOptions.map((OptionDTO option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Radio<String>(
                                          value: option.name,
                                          groupValue: _selectedRequiredOptions['required'],
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedRequiredOptions['required'] = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(option.name, style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    Text('${option.price}원', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    if (additionalOptions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '추가 옵션',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            ...additionalOptions.map((OptionDTO option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: 1.2,
                                          child: Checkbox(
                                            value: _selectedOptions[option.name] ?? false,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _selectedOptions[option.name] = value ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(option.name, style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    Text('${option.price}원', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  final cartItem = CartDTO(
                    menuId: menu.id,
                    menuImg: menu.menuImg,
                    menuName: menu.name,
                    basePrice: menu.price,
                    selectedOptions: menu.oList.where((option) {
                      return option.required == true && _selectedRequiredOptions['required'] == option.name ||
                          _selectedOptions[option.name] == true;
                    }).toList(),
                    totalPrice: _calculateTotalPrice(menu),
                  );
                  cartProvider.addToCart(cartItem);

                  // 스낵바 알림 띄우기
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('장바구니에 담겼습니다!'),
                    ),
                  );

                  // store_main으로 돌아가기
                  Navigator.of(context).pushNamedAndRemoveUntil('/store_main', (Route<dynamic> route) => false);
                },
                child: Text('${_calculateTotalPrice(menu)}원 담기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}