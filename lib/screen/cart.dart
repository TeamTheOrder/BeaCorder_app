import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final cartItems = cartProvider.cartItems;
      for (var item in cartItems) {
        print('메뉴: ${item.menuName}, 기본 가격: ${item.basePrice}원, 총 가격: ${item.totalPrice}원');
        for (var option in item.selectedOptions) {
          print('옵션: ${option.name}, 가격: ${option.price}원');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(bottom: 16.0),
            ),
          ),
          SizedBox(height: 16.0),
          ...cartItems.map((item) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.network(item.menuImg, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.menuName),
                  subtitle: Text('${item.basePrice}원'),
                  trailing: Text('${item.totalPrice}원'),
                ),
                ...item.selectedOptions.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option.name),
                        Text('${option.price}원'),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
          SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 결제 화면으로 이동하는 로직 추가
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.cyan, // 폰트 컬러 cyan
              ),
              child: Text('결제하기'),
            ),
          ),
        ],
      ),
    );
  }
}