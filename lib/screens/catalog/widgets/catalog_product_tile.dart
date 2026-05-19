import 'package:flutter/material.dart';

import '../../../context/favorites_provider.dart';
import '../../../domain/product.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/product_image_box.dart';

class CatalogProductTile extends StatelessWidget {
  const CatalogProductTile({
    super.key,
    required this.product,
    required this.onOpenDetails,
  });

  final Product product;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final favorites = FavoritesProvider.of(context);
    final isFav = favorites.isFavorite(product.id);

    return GestureDetector(
      onTap: onOpenDetails,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ProductImageBox(imageUrl: product.image, borderRadius: 0),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: _FavButton(
                    isFavorite: isFav,
                    onTap: () => favorites.toggle(product),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    _PriceText(price: product.price),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  const _FavButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_outline,
          size: 22,
          color: isFavorite ? AppColors.teal : AppColors.deepBlue,
        ),
      ),
    );
  }
}

class _PriceText extends StatelessWidget {
  const _PriceText({this.price});
  final String? price;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium;
    final hasPrice = (double.tryParse(price ?? '') ?? 0) > 0;

    if (!hasPrice) return const SizedBox.shrink();

    return Text(
      '$price ₽',
      style: base?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.aqua,
      ),
    );
  }
}
