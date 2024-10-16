import 'cart_item.dart';

class Cart {
  List<CartItem> items = [];

  // 장바구니에 항목 추가
  void addItem(CartItem item) {
    items.add(item);
  }

  // 장바구니의 총 가격 계산
  int getTotalPrice() {
    return items.fold(0, (total, item) => total + item.price);
  }

  // 장바구니의 전체 항목 삭제
  void clearCart() {
    items.clear();
  }

  // 장바구니 항목을 출력하는 메서드 (디버깅용)
  void printCartItems() {
    for (var item in items) {
      print('메뉴: ${item.menuName}, 가격: ${item.price}, 옵션: ${item.selectedOptions}');
    }
  }
}
