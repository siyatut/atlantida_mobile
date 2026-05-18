import 'package:flutter/material.dart';

import '../../data/strapi/strapi_repository.dart';
import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../widgets/page_header.dart';

import 'category_products_screen.dart';

class CategoryLevelScreen extends StatefulWidget {
  const CategoryLevelScreen({
    super.key,
    required this.repo,
    required this.parent,
  });

  final StrapiRepository repo;
  final WooCategory parent;

  @override
  State<CategoryLevelScreen> createState() => _CategoryLevelScreenState();
}

class _CategoryLevelScreenState extends State<CategoryLevelScreen> {
  List<WooCategory> _children = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tree = await widget.repo.categoryTree();
    if (!mounted) return;
    final children = tree.childrenOf(widget.parent.id);
    if (children.isEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(
            repo: widget.repo,
            category: widget.parent,
          ),
        ),
      );
      return;
    }
    setState(() {
      _children = children;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: widget.parent.name,
              subtitle: 'Выберите подкатегорию',
              onBack: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.separated(
                  padding: tabScrollPadding(context)
                      .copyWith(left: 16, right: 16, top: 4),
                  itemCount: _children.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final c = _children[i];
                    return _SubcategoryCard(
                      title: c.name,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryLevelScreen(
                            repo: widget.repo,
                            parent: c,
                          ),
                        ),
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
