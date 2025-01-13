import 'package:flutter/material.dart';
import '../models/store_dto.dart';

class StoreProvider with ChangeNotifier {
  List<StoreDTO> _stores = [];
  StoreDTO? _selectedStore;

  List<StoreDTO> get stores => _stores;
  StoreDTO? get selectedStore => _selectedStore;

  void setSelectedStore(StoreDTO store) {
    _selectedStore = store;
    notifyListeners();
  }

// fetchStoreList 및 기타 메서드 추가
}