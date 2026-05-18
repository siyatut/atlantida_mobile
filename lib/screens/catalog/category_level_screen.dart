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
              padding: tabScrollPadding(context).copyWith(top: 8),
              itemCount: level2.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = level2[i];
                return _SubcategoryRow(
                  title: c.name,
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

class _SubcategoryRow extends StatelessWidget {
  const _SubcategoryRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: t.bodyLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.softInk.withValues(alpha: .6), size: 22),
          ],
        ),
      ),
    );
  }
}
