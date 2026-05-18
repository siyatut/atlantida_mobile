import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/product_image_box.dart';

Color _cardBg(BuildContext context) =>
    Theme.of(context).colorScheme.surface.withValues(alpha: .95);

class ProductDetailsImageCard extends StatelessWidget {
  const ProductDetailsImageCard({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? _cardBg(context) : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ProductImageBox(imageUrl: imageUrl, borderRadius: 0),
      ),
    );
  }
}
