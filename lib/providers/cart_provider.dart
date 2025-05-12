import 'package:flutter/material.dart';
import '../models/cart_dto.dart';

class CartProvider with ChangeNotifier {
  List<CartDTO> _cartItems = [];

  List<CartDTO> get cartItems => _cartItems;

  void addToCart(CartDTO cartItem) {
    _cartItems.add(cartItem);
    notifyListeners();
  }

  void removeFromCart(CartDTO cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}