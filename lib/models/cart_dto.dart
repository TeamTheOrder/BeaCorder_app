import 'option_dto.dart';

class CartDTO {
  final int menuId;
  final String menuImg;
  final String menuName;
  final int basePrice;
  final List<OptionDTO> selectedOptions;
  final int totalPrice;
  int quantity; // 수량 변수 추가

  CartDTO({
    required this.menuId,
    required this.menuImg,
    required this.menuName,
    required this.basePrice,
    required this.selectedOptions,
    required this.totalPrice,
    this.quantity = 1, // 기본 수량을 1로 설정
  });
}