// lib/providers/menu_provider.dart
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/menu_dto.dart';
import '../service/api_service.dart';
import '../models/cart_dto.dart';

class MenuProvider with ChangeNotifier {
  List<MenuDTO> _menus = [];
  MenuDTO? _selectedMenu;
  bool _isLoading = false;
  String _errorMessage = '';

  List<MenuDTO> get menus => _menus;
  MenuDTO? get selectedMenu => _selectedMenu;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMenu(int storeId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _menus = await ApiService.fetchMenu(storeId);
    } catch (e) {
      _errorMessage = '메뉴 목록을 불러오지 못했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedMenu(MenuDTO menu) {
    _selectedMenu = menu;
    notifyListeners();
  }

  Future<void> createOrder(int storeId, List<CartDTO> cartItems) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    String? token = fcmToken;

    try {
      List<Map<String, dynamic>> orderDetail = _convertToOrderDetail(cartItems);
      await ApiService.createOrder(token!, storeId, orderDetail);
    } catch (e) {
      _errorMessage = '주문을 생성하지 못했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _convertToOrderDetail(List<CartDTO> cartItems) {
    return cartItems.map((item) {
      return {
        'menu_id': item.menuId,
        'opt_id': item.selectedOptions.map((option) => option.id).toList(),
        'quantity': item.quantity,
      };
    }).toList();
  }
}