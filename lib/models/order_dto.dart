class CreateOrderDTO {
  final int storeId;
  final List<OrderDetail> orderDetail;

  CreateOrderDTO({required this.storeId, required this.orderDetail});

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      "store_id": storeId,
      "order_detail": orderDetail.map((detail) => detail.toJson()).toList(),
    };
  }
}

class OrderDetail {
  final int menuId;
  final List<int> optId;

  OrderDetail({required this.menuId, required this.optId});

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      "menu_id": menuId,
      "opt_id": optId,
    };
  }
}
