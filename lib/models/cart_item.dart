class CartItem {
  final int menuId;
  final String menuName;
  final List<Map<String, dynamic>> selectedOptions;
  final int price;

  CartItem({
    required this.menuId,
    required this.menuName,
    required this.selectedOptions,
    required this.price,
  });
}
