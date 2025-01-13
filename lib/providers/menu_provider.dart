// lib/providers/menu_provider.dart
import 'package:beacorder_user_table/main.dart';
import 'package:flutter/material.dart';
import '../models/menu_dto.dart';
import '../service/api_service.dart';

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

  Future<void> createOrder(int storeId, List<Map<String, dynamic>> orderDetail) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    String? token = fcmToken;

    try {
      await ApiService.createOrder(token!, storeId, orderDetail);
    } catch (e) {
      _errorMessage = '주문을 생성하지 못했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}