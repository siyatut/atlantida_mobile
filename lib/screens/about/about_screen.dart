import 'package:flutter/material.dart';

import '../../core/constants/app_contacts.dart';
import '../../theme/app_colors.dart';
import '../../utils/launcher_utils.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../utils/spacing.dart';
import '../../utils/text_utils.dart';
import '../../widgets/yellow_button.dart';
import '../contacts/contacts_content.dart';

import 'about_content.dart';
import 'widgets/about_accordion_item.dart';
import 'widgets/about_bullets.dart';
import 'widgets/about_feature_grid.dart';
import 'widgets/about_hero_card.dart';
import 'widgets/about_section_title.dart';
import 'widgets/about_surface_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, this.onOpenCatalog});

  final VoidCallback? onOpenCatalog;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final heroTitle = AboutContent.heroTitle();
    final heroSubtitle = AboutContent.heroSubtitle();
    final aboutIntro = AboutContent.intro;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AboutHeroCard(
              title: heroTitle,
              subtitle: heroSubtitle,
            ),
          ),
          const SliverToBoxAdapter(child: gap12),

          // 1) О магазине + ассортимент (коротко)
          SliverToBoxAdapter(child: _buildTextSection(context, aboutIntro)),
          const SliverToBoxAdapter(child: gap12),

          // 2) Преимущества магазина
          SliverToBoxAdapter(
            child: AboutSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AboutSectionTitle('Почему выбирают «Атлантиду»'),
                  gap12,
                  const AboutBullets(items: AboutContent.whyUsBullets),
                  gap12,
                  Text(
                    fixPrepositions(
                      'Мы стремимся сделать заботу о питомце проще: '
                      'помогаем с выбором, советуем правильный уход и предлагаем необходимые товары.',
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: .85),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: gap12),

          // 3) Фишки/иконки
          const SliverToBoxAdapter(
            child: AboutSurfaceCard(
              child: AboutFeatureGrid(
                items: AboutContent.features,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: gap12),

          // 4) Категории (аккордеон)
          SliverToBoxAdapter(
            child: AboutSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AboutSectionTitle('Зоотовары для разных питомцев'),
                  gap8,
                  for (final item in AboutContent.accordion) ...[
                    AboutAccordionItem(
                      title: fixPrepositions(item.title),
                      text: fixPrepositions(item.text),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: gap12),

          // 5) CTA перейти в каталог
          SliverToBoxAdapter(
            child: AboutSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AboutSectionTitle('Посмотреть товары'),
                  gap8,
                  Text(
                    fixPrepositions(
                      'Перейдите в каталог и выберите всё нужное для вашего любимца.',
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: .85),
                      height: 1.3,
                    ),
                  ),
                  gap12,
                  YellowButton(
                    text: 'Перейти в каталог',
                    icon: Icons.storefront_outlined,
                    onTap: onOpenCatalog ?? () {},
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: gap12),

          // 6) Контакты
          SliverToBoxAdapter(
            child: AboutSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AboutSectionTitle('Контакты'),
                  gap12,

                  // phones
                  for (final p in ContactsContent.phones) ...[
                    _ContactRow(
                      icon: Icons.call_outlined,
                      title: p.title,
                      subtitle: p.phoneUi,
                      onTap: () => makePhoneCall(p.tel),
                    ),
                    gap8,
                  ],

                  // telegram
                  _ContactRow(
                    icon: Icons.send_outlined,
                    title: 'Telegram',
                    subtitle: '@gagin645',
                    onTap: () => openUrl(ContactsContent.telegramUrl),
                  ),
                  gap16,

                  // address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.teal, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ContactsContent.addressTitleUi(),
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ContactsContent.addressSubtitleUi(),
                              style: textTheme.bodySmall?.copyWith(
                                color: cs.onSurface.withValues(alpha: .7),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  gap12,

                  // map buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              openUrl(ContactsContent.yandexRouteUrl),
                          icon: const Icon(Icons.map_outlined, size: 18),
                          label: const Text('Яндекс Карты'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.teal,
                            side: const BorderSide(color: AppColors.teal),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      hGap(10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              openUrl(ContactsContent.googleRouteUrl),
                          icon: const Icon(Icons.directions_outlined, size: 18),
                          label: const Text('Google Maps'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.teal,
                            side: const BorderSide(color: AppColors.teal),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  gap16,

                  // call / write
                  Row(
                    children: [
                      Expanded(
                        child: YellowButton(
                          text: 'Позвонить',
                          icon: Icons.call,
                          onTap: () => makePhoneCall(AppContacts.phone),
                        ),
                      ),
                      hGap(12),
                      Expanded(
                        child: YellowButton(
                          text: 'Написать',
                          icon: Icons.email_outlined,
                          onTap: () => sendEmail(
                            email: AppContacts.email,
                            subject: 'Вопрос из приложения',
                            body: 'Здравствуйте! Хочу уточнить детали…',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: tabScrollPadding(context).bottom),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection(BuildContext context, AboutSection s) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AboutSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AboutSectionTitle(splitTitleInTwo(fixPrepositions(s.title))),
          gap8,
          for (final p in s.paragraphs) ...[
            Text(
              fixPrepositions(p),
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: .85),
                height: 1.35,
              ),
            ),
            gap8,
          ],
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, color: AppColors.teal, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: .6),
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right,
                color: cs.onSurface.withValues(alpha: .3), size: 18),
          ],
        ),
      ),
    );
  }
}
