import 'option_dto.dart';

class CartDTO {
  final String menuImg;
  final String menuName;
  final int basePrice;
  final List<OptionDTO> selectedOptions;
  final int totalPrice;

  CartDTO({
    required this.menuImg,
    required this.menuName,
    required this.basePrice,
    required this.selectedOptions,
    required this.totalPrice,
  });
}