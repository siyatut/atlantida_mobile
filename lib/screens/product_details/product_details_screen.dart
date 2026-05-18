import 'package:flutter/material.dart';

import '../../context/favorites_provider.dart';
import '../../domain/product.dart';
import '../../theme/app_colors.dart';
import '../../utils/text_utils.dart';

import 'utils/product_description_parser.dart';
import 'widgets/product_details_contact_card.dart';
import 'widgets/product_details_description_card.dart';
import 'widgets/product_details_image_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final favorites = FavoritesProvider.of(context);

    final description = fixPrepositions(
      cleanProductDescription(product.description),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // image with top padding so floating buttons don't overlap
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ProductDetailsImageCard(imageUrl: product.image),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          splitTitleInTwo(product.title),
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.deepBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (product.price != null &&
                            product.price!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${product.price} ₽',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.aqua,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ProductDetailsDescriptionCard(text: description),
                        const SizedBox(height: 16),
                        ProductDetailsContactCard(productTitle: product.title),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // floating back button
            Positioned(
              top: 12,
              left: 12,
              child: _FloatingButton(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back, size: 22,
                    color: AppColors.deepBlue),
              ),
            ),

            // floating favorites button
            Positioned(
              top: 12,
              right: 12,
              child: ListenableBuilder(
                listenable: favorites,
                builder: (context, _) {
                  final isFavNow = favorites.isFavorite(product.id);
                  return _FloatingButton(
                    onTap: () => favorites.toggle(product),
                    child: Icon(
                      isFavNow ? Icons.favorite : Icons.favorite_outline,
                      size: 22,
                      color: isFavNow ? Colors.red : AppColors.softInk,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
