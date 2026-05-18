import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/strapi/strapi_repository.dart';

import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../widgets/page_header.dart';

import 'category_level_screen.dart';

class CatalogHomeScreen extends StatefulWidget {
  const CatalogHomeScreen({super.key, this.onGoHome});

  final VoidCallback? onGoHome;

  @override
  State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
}

class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
  final _repo = StrapiRepository();

  bool _loading = true;
  String? _error;

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
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Каталог',
            subtitle: 'Выберите категорию',
            onBack: widget.onGoHome,
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (!_loading && _error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: _load, child: const Text('Повторить')),
                  ],
                ),
              ),
            ),
          if (!_loading && _error == null)
            Expanded(
              child: ListView.separated(
                padding: tabScrollPadding(context)
                    .copyWith(left: 16, right: 16, top: 4),
                itemCount: _top.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final c = _top[i];
                  final svgPath = _svgForSlug[c.slug.toLowerCase()];
                  return _CategoryCard(
                    title: c.name,
                    svgPath: svgPath,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryLevelScreen(repo: _repo, parent: c),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
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

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.aqua.withValues(alpha: .15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            color: cs.surface,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                  color: cs.onSurface.withValues(alpha: .35), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
