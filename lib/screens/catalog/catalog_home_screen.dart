import 'package:flutter/material.dart';

import '../../data/woo/category_tree.dart';
import '../../data/woo/woo_dto.dart';
import '../../data/woo/woo_repository.dart';
import '../../theme/app_colors.dart';
import '../../utils/tab_scroll_padding.dart';

import 'category_level_screen.dart';

class CatalogHomeScreen extends StatefulWidget {
  const CatalogHomeScreen({super.key});

  @override
  State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
}

class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
  final _repo = WooRepository();

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
      top: false,
      bottom: false,
      child: ListView.separated(
        padding: tabScrollPadding(context),
        itemCount: _top.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final c = _top[i];
          return _BigCategoryCell(
            title: c.name,
            subtitle: _subtitleForSlug(c.slug),
            imageAsset: _imageForSlug(c.slug), 
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryLevelScreen(repo: _repo, parent: c),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _subtitleForSlug(String slug) {
    switch (slug.toLowerCase()) {
      case 'rybki':
        return 'Рыбки, аквариумы, корма и всё для ухода';
      case 'gryzuny':
        return 'Клетки, корма, игрушки и аксессуары';
      case 'koshki':
        return 'Корма, наполнители, уход и аксессуары';
      case 'sobaki':
        return 'Корма, амуниция, игрушки и уход';
      case 'pticzy':
        return 'Корма, клетки и товары для птиц';
      case 'reptilii':
        return 'Террариумы, корм и оборудование';
      default:
        return '';
    }
  }

  String? _imageForSlug(String slug) {
    return null;
  }
}

class _BigCategoryCell extends StatelessWidget {
  const _BigCategoryCell({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String? imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 128,
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
            _LeftImage(imageAsset: imageAsset),
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
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: .75),
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Открыть',
                          style: t.labelLarge?.copyWith(color: AppColors.deepBlue)
                          ),
                        const SizedBox(width: 6),
                        Icon(Icons.chevron_right,
                            color: cs.onSurface.withValues(alpha: .55)),
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

class _LeftImage extends StatelessWidget {
  const _LeftImage({this.imageAsset});

  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasImage = imageAsset != null && imageAsset!.isNotEmpty;

    return SizedBox(
      width: 120,
      height: double.infinity,
      child: hasImage
          ? Image.asset(imageAsset!, fit: BoxFit.cover)
          : Container(
              color: cs.surfaceContainerLowest.withValues(alpha: .65),
              child: Icon(
                Icons.image_outlined,
                size: 42,
                color: cs.onSurface.withValues(alpha: .25),
              ),
            ),
    );
  }
}