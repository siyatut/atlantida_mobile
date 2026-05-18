import 'package:flutter/material.dart';

import '../../data/strapi/strapi_repository.dart';
import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../widgets/page_header.dart';

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
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: parent.name,
              subtitle: 'Выберите подкатегорию',
              onBack: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder(
                future: repo.categoryTree(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tree = snapshot.data!;
                  final level2 = tree.childrenOf(parent.id);

                  if (level2.isEmpty) {
                    return CategoryProductsScreen(
                        repo: repo, category: parent);
                  }

                  return ListView.separated(
                    padding: tabScrollPadding(context)
                        .copyWith(left: 16, right: 16, top: 4),
                    itemCount: level2.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final c = level2[i];
                      return _SubcategoryCard(
                        title: c.name,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(
                              repo: repo,
                              category: c,
                              parentName: parent.name,
                            ),
                          ),
                        ),
                      );
                    },
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

class _SubcategoryCard extends StatelessWidget {
  const _SubcategoryCard({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.aqua.withValues(alpha: .15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            color: cs.surface,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  color: cs.onSurface.withValues(alpha: .35), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
