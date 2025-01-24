// lib/screen/cart.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_dto.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/store_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void _updateQuantity(CartDTO item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity < 1) {
        item.quantity = 1;
      }
    });
  }

  void _removeItem(CartDTO item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.removeFromCart(item);
    if (cartProvider.cartItems.isEmpty) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamedAndRemoveUntil('/store_main', (Route<dynamic> route) => false);
    }
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
            return Container(
              margin: EdgeInsets.only(bottom: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.menuName,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10,),
                            ...item.selectedOptions.map((option) {
                              return Text(
                                  '${option.required ? '필수 옵션' : '추가 옵션'} : ${option.name} ${option.required ? '' : '(${option.price}원)'}',
                                  style: TextStyle(color: Colors.grey));
                            }).toList(),
                            Text('가격 : ${item.basePrice}원',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Image.network(item.menuImg,
                          width: 50, height: 50, fit: BoxFit.cover),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.totalPrice}원',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            item.quantity > 1
                                ? IconButton(
                              icon: Icon(Icons.remove),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                _updateQuantity(item, -1);
                                setState(() {});
                              },
                            )
                                : IconButton(
                              icon: Icon(Icons.delete),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                _removeItem(item);
                                setState(() {});
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                _updateQuantity(item, 1);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final menuProvider = Provider.of<MenuProvider>(context, listen: false);
                final storeProvider = Provider.of<StoreProvider>(context, listen: false);
                menuProvider.createOrder(storeProvider.selectedStore!.storeId, cartItems); // storeId는 예시로 1을 사용

                // 주문 생성 후 장바구니 비우기
                cartProvider.clearCart();

                // 주문 생성 완료 메시지
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('주문이 생성되었습니다!'),
                  ),
                );

                // store_main으로 돌아가기
                Navigator.of(context).pushNamedAndRemoveUntil('/store_main', (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.cyan, // 폰트 컬러 흰색, 배경색 진한 파란색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 모서리를 살짝 둥글게
                ),
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500), // 폰트 크기 키우기
                minimumSize: Size(double.infinity, 60), // 버튼의 높이 조절
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${cartItems.fold(0, (sum, item) => sum + item.totalPrice * item.quantity)}원 '),
                  Text('●', style: TextStyle(fontSize: 20, color: Colors.white)),
                  SizedBox(width: 8.0),
                  Text('결제하기'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}