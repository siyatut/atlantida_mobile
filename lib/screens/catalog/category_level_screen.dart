import 'package:flutter/material.dart';

import '../../data/strapi/strapi_repository.dart';
import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';

import 'category_products_screen.dart';

class CategoryLevelScreen extends StatelessWidget {
  const CategoryLevelScreen({
    super.key,
    required this.repo,
    required this.parent,
  });

  final StrapiRepository repo;
  final WooCategory parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(parent.name)),
      body: FutureBuilder(
        future: repo.categoryTree(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tree = snapshot.data!;
          final level2 = tree.childrenOf(parent.id);

          if (level2.isEmpty) {
            return CategoryProductsScreen(repo: repo, category: parent);
          }

          return SafeArea(
            top: false,
            bottom: false,
            child: ListView.separated(
              padding: tabScrollPadding(context),
              itemCount: level2.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final c = level2[i];
                return _BigSubcategoryCell(
                  title: c.name,
                  imageAsset: null, // потом подключим фото
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryProductsScreen(repo: repo, category: c),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BigSubcategoryCell extends StatelessWidget {
  const _BigSubcategoryCell({
    required this.title,
    required this.onTap,
    this.imageAsset,
  });

  final String title;
  final String? imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final hasImage = imageAsset != null && imageAsset!.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 118,
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .14),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: AppColors.deepBlue.withValues(alpha: .10),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: double.infinity,
              child: hasImage
                  ? Image.asset(imageAsset!, fit: BoxFit.cover)
                  : Container(
                      color: cs.surfaceContainerLowest.withValues(alpha: .65),
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: cs.onSurface.withValues(alpha: .25),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'Открыть',
                          style: t.labelLarge?.copyWith(
                            color: AppColors.deepBlue,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.chevron_right,
                          color: cs.onSurface.withValues(alpha: .55),
                        ),
                      ],
                    ),
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