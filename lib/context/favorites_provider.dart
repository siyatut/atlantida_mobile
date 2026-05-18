import 'package:flutter/material.dart';

import '../domain/product.dart';

class FavoritesNotifier extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool isFavorite(int id) => _items.any((p) => p.id == id);

  void toggle(Product product) {
    final idx = _items.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      _items.removeAt(idx);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}

class FavoritesProvider extends InheritedNotifier<FavoritesNotifier> {
  const FavoritesProvider({
    super.key,
    required FavoritesNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static FavoritesNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FavoritesProvider>()!
        .notifier!;
  }
}
