import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_contacts.dart';
import '../../data/strapi/strapi_repository.dart';
import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/launcher_utils.dart';
import '../../utils/tab_scroll_padding.dart';

import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onOpenCatalog,
    this.onOpenFavorites,
  });

  final VoidCallback? onOpenCatalog;
  final VoidCallback? onOpenFavorites;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = StrapiRepository();
  List<WooCategory> _categories = const [];

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
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final tree = await _repo.categoryTree();
      final top = tree.all
          .where((c) => c.parent == 0)
          .where((c) => _orderedSlugs.contains(c.slug.toLowerCase()))
          .toList();

      top.sort((a, b) => _orderedSlugs
          .indexOf(a.slug.toLowerCase())
          .compareTo(_orderedSlugs.indexOf(b.slug.toLowerCase())));

      if (mounted) setState(() => _categories = top);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pad = tabScrollPadding(context);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          // header row: title + subtitle + favorites button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Атлантида',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.deepBlue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Зоомагазин и аквариумистика',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.softInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onOpenFavorites,
                    icon: const Icon(Icons.favorite_outline,
                        color: AppColors.softInk),
                    tooltip: 'Избранное',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // promo banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PromoBanner(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // category scroll (only when loaded)
          if (_categories.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 12),
                child: Text(
                  'Категории',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.deepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 88,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final c = _categories[i];
                    final svg = _svgForSlug[c.slug.toLowerCase()];
                    return _CategoryChip(
                      label: c.name,
                      svgPath: svg,
                      onTap: widget.onOpenCatalog,
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],

          // advantages
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 12),
              child: Text(
                'Преимущества',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.deepBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (final adv in HomeContent.advantages)
                    _AdvantageRow(advantage: adv),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // CTA card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CtaCard(),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: pad.bottom + 16)),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepBlue, AppColors.teal, AppColors.aqua],
          stops: [0.05, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Бесплатная доставка аквариума',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'При заказе от 10 000 ₽',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.svgPath,
    this.onTap,
  });

  final String label;
  final String? svgPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: svgPath != null
                ? Padding(
                    padding: const EdgeInsets.all(13),
                    child: SvgPicture.asset(
                      svgPath!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.teal,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : const Icon(Icons.category_outlined,
                    color: AppColors.teal, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: AppColors.deepBlue),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AdvantageRow extends StatelessWidget {
  const _AdvantageRow({required this.advantage});

  final HomeAdvantage advantage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(advantage.icon, color: AppColors.teal, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  advantage.title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  advantage.text,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.softInk,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Остались вопросы?',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.deepBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Позвоните или напишите — поможем с выбором.',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.softInk,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => makePhoneCall(AppContacts.phone),
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Позвонить'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => sendEmail(
                    email: AppContacts.email,
                    subject: 'Вопрос из приложения',
                    body: 'Здравствуйте! Хочу уточнить детали…',
                  ),
                  icon: const Icon(Icons.email_outlined, size: 18),
                  label: const Text('Написать'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.teal,
                    side: const BorderSide(color: AppColors.teal),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
