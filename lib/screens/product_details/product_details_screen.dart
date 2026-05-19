import 'package:flutter/material.dart';

import '../../context/favorites_provider.dart';
import '../../core/constants/app_contacts.dart';
import '../../domain/product.dart';
import '../../theme/app_colors.dart';
import '../../utils/launcher_utils.dart';
import '../../utils/text_utils.dart';
import '../../widgets/teal_card.dart';

import 'utils/product_description_parser.dart';
import 'widgets/product_details_description_card.dart';
import 'widgets/product_details_image_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
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
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ProductDetailsImageCard(imageUrl: product.image),
                      ),
                      Positioned(
                        top: 8,
                        left: 32,
                        child: _FloatingButton(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.chevron_left,
                              size: 22, color: AppColors.deepBlue),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 32,
                        child: ListenableBuilder(
                          listenable: favorites,
                          builder: (context, _) {
                            final isFav = favorites.isFavorite(product.id);
                            return _FloatingButton(
                              onTap: () => favorites.toggle(product),
                              child: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 22,
                                color: isFav ? AppColors.teal : AppColors.deepBlue,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          splitTitleInTwo(product.title),
                          style: t.titleLarge?.copyWith(
                            color: AppColors.deepBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (product.price != null &&
                            product.price!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${product.price} ₽',
                            style: t.headlineSmall?.copyWith(
                              color: AppColors.aqua,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Наличие уточняйте в магазине',
                            style: t.bodyMedium?.copyWith(
                              color: AppColors.softInk,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ProductDetailsDescriptionCard(text: description),
                        const SizedBox(height: 20),
                        Text(
                          'Остались вопросы?',
                          style: t.titleMedium?.copyWith(
                            color: AppColors.deepBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TealCtaCard(
                          onCall: () => makePhoneCall(AppContacts.phone),
                          onWrite: () => sendEmail(
                            email: AppContacts.email,
                            subject: 'Вопрос по товару из приложения',
                            body:
                                'Здравствуйте! Хочу уточнить наличие и стоимость товара «${product.title}».',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
