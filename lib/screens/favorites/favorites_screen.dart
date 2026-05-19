import 'package:flutter/material.dart';

import '../../context/favorites_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../widgets/page_header.dart';
import '../catalog/widgets/catalog_product_tile.dart';
import '../product_details/product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, this.onGoHome});

  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesProvider.of(context);
    final items = favorites.items;
    final count = items.length;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Избранное',
            subtitle: count == 0 ? null : '$count ${_itemsLabel(count)}',
            onBack: onGoHome,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? const _EmptyFavorites()
                : GridView.builder(
                    padding: tabScrollPadding(context).copyWith(
                      left: 16,
                      right: 16,
                      top: 4,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final product = items[i];
                      return CatalogProductTile(
                        product: product,
                        onOpenDetails: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: product),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static String _itemsLabel(int n) {
    if (n % 100 >= 11 && n % 100 <= 19) return 'товаров';
    switch (n % 10) {
      case 1:
        return 'товар';
      case 2:
      case 3:
      case 4:
        return 'товара';
      default:
        return 'товаров';
    }
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border,
              size: 64, color: AppColors.teal.withValues(alpha: .5)),
          const SizedBox(height: 16),
          Text(
            'Вы ещё не добавили\nтовары в избранное',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.teal.withValues(alpha: .7),
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
