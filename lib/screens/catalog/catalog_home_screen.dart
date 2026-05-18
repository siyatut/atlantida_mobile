import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/strapi/strapi_repository.dart';
import '../../data/woo/category_tree.dart';
import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';

import 'category_level_screen.dart';

class CatalogHomeScreen extends StatefulWidget {
  const CatalogHomeScreen({super.key});

  @override
  State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
}

class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
  final _repo = StrapiRepository();

  bool _loading = true;
  String? _error;

  CategoryTree? _tree;
  List<WooCategory> _top = const [];

  static const _orderedSlugs = [
    'rybki',
    'gryzuny',
    'koshki',
    'sobaki',
    'pticzy',
    'reptilii',
  ];

  static const _svgForSlug = {
    'rybki': 'assets/images/icons_category/fish.svg',
    'koshki': 'assets/images/icons_category/cat.svg',
    'sobaki': 'assets/images/icons_category/dog.svg',
    'pticzy': 'assets/images/icons_category/bird.svg',
    'gryzuny': 'assets/images/icons_category/mouse.svg',
    'reptilii': 'assets/images/icons_category/reptile.svg',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tree = await _repo.categoryTree();

      final top = tree.all
          .where((c) => c.parent == 0)
          .where((c) => _orderedSlugs.contains(c.slug.toLowerCase()))
          .toList();

      top.sort((a, b) => _orderedSlugs
          .indexOf(a.slug.toLowerCase())
          .compareTo(_orderedSlugs.indexOf(b.slug.toLowerCase())));

      if (!mounted) return;
      setState(() {
        _tree = tree;
        _top = top;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Не удалось загрузить категории';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null || _tree == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error ?? 'Ошибка'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Повторить')),
          ],
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text(
                'Каталог',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.deepBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: tabScrollPadding(context).copyWith(
              left: 16,
              right: 16,
              top: 0,
            ),
            sliver: SliverList.separated(
              itemCount: _top.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = _top[i];
                final svgPath = _svgForSlug[c.slug.toLowerCase()];
                return _CategoryRow(
                  title: c.name,
                  svgPath: svgPath,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryLevelScreen(repo: _repo, parent: c),
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

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.title,
    required this.onTap,
    this.svgPath,
  });

  final String title;
  final String? svgPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: svgPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        svgPath!,
                        colorFilter: const ColorFilter.mode(
                          AppColors.teal,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : const Icon(Icons.category_outlined,
                      color: AppColors.teal, size: 22),
            ),
            const SizedBox(width: 14),
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
                color: cs.onSurface.withValues(alpha: .4), size: 22),
          ],
        ),
      ),
    );
  }
}
