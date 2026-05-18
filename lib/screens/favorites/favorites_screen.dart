import 'package:flutter/material.dart';

import '../../context/favorites_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';
import '../catalog/widgets/catalog_product_tile.dart';
import '../product_details/product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesProvider.of(context);
    final items = favorites.items;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Избранное',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.deepBlue,
                    fontWeight: FontWeight.w700,
                  ),
            ),
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
                        onOpenDetails: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 64, color: cs.onSurface.withValues(alpha: .25)),
          const SizedBox(height: 16),
          Text(
            'Вы ещё не добавили\nтовары в избранное',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface.withValues(alpha: .5),
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
