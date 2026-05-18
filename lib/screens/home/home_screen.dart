import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_contacts.dart';
import '../../data/strapi/strapi_repository.dart';
import '../../data/woo/woo_dto.dart';
import '../../theme/app_colors.dart';
import '../../utils/launcher_utils.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../utils/text_utils.dart';
import '../../widgets/teal_card.dart';
import '../catalog/category_level_screen.dart';

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
    'rybki', 'gryzuny', 'koshki', 'sobaki', 'pticzy', 'reptilii',
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
          .toList()
        ..sort((a, b) => _orderedSlugs
            .indexOf(a.slug.toLowerCase())
            .compareTo(_orderedSlugs.indexOf(b.slug.toLowerCase())));
      if (mounted) setState(() => _categories = top);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final pad = tabScrollPadding(context);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Атлантида',
                          style: t.headlineMedium?.copyWith(
                            color: AppColors.deepBlue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Зоомагазин и аквариумистика',
                          style: t.bodyMedium?.copyWith(
                              color: AppColors.softInk),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onOpenFavorites,
                    icon: const Icon(Icons.favorite_outline,
                        color: AppColors.softInk),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Promo banner ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PromoBanner(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── Categories ───────────────────────────────────────────────
          if (_categories.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Категории',
                  style: t.titleMedium?.copyWith(
                    color: AppColors.deepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 104,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final c = _categories[i];
                      return _CategoryChip(
                        label: c.name,
                        svgPath: _svgForSlug[c.slug.toLowerCase()],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoryLevelScreen(
                              repo: _repo,
                              parent: c,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],

          // ── Advantages ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 12),
              child: Text(
                'Преимущества покупки у нас',
                style: t.titleMedium?.copyWith(
                  color: AppColors.deepBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AdvantagesCard(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── CTA ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 12),
              child: Text(
                'Остались вопросы?',
                style: t.titleMedium?.copyWith(
                  color: AppColors.deepBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TealCtaCard(
                onCall: () => makePhoneCall(AppContacts.phone),
                onWrite: () => sendEmail(
                  email: AppContacts.email,
                  subject: 'Вопрос из приложения',
                  body: 'Здравствуйте! Хочу уточнить детали…',
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: pad.bottom + 4)),
        ],
      ),
    );
  }
}

// ── Promo banner ──────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_shipping_outlined,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'При заказе от 10 000 ₽',
                  style: t.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: .8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Бесплатная доставка аквариума',
                  style: t.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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

// ── Category chip ─────────────────────────────────────────────────────────────

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
    final t = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(18),
            ),
            child: svgPath != null
                ? Padding(
                    padding: const EdgeInsets.all(16),
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
            style: t.labelSmall?.copyWith(color: AppColors.deepBlue),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Advantages card ───────────────────────────────────────────────────────────

class _AdvantagesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        children: [
          for (final adv in HomeContent.advantages)
            _AdvantageRow(advantage: adv),
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
    final t = Theme.of(context).textTheme;
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
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(advantage.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fixPrepositions(advantage.title),
                  style: t.titleSmall?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fixPrepositions(advantage.text),
                  style: t.bodyMedium?.copyWith(
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
