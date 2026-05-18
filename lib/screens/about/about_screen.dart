import 'package:flutter/material.dart';

import '../../core/constants/app_contacts.dart';
import '../../theme/app_colors.dart';
import '../../utils/launcher_utils.dart';
import '../../utils/tab_scroll_padding.dart';
import '../../utils/spacing.dart';
import '../../utils/text_utils.dart';
import '../../widgets/page_header.dart';
import '../../widgets/teal_card.dart';
import '../contacts/contacts_content.dart';

import 'about_content.dart';
import 'widgets/about_accordion_item.dart';
import 'widgets/about_bullets.dart';
import 'widgets/about_feature_grid.dart';
import 'widgets/about_section_title.dart';
import 'widgets/about_surface_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, this.onOpenCatalog, this.onGoHome});

  final VoidCallback? onOpenCatalog;
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final aboutIntro = AboutContent.intro;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          PageHeader(
            title: 'О нас',
            subtitle: 'Информация о компании',
            onBack: onGoHome,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // 1) О магазине
                SliverToBoxAdapter(
                    child: _buildTextSection(context, aboutIntro)),
                const SliverToBoxAdapter(child: gap12),

                // 2) Преимущества магазина
                SliverToBoxAdapter(
                  child: AboutSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AboutSectionTitle(
                            'Почему выбирают «Атлантиду»'),
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
                    child: AboutFeatureGrid(items: AboutContent.features),
                  ),
                ),
                const SliverToBoxAdapter(child: gap12),

                // 4) Категории (аккордеон)
                SliverToBoxAdapter(
                  child: AboutSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AboutSectionTitle(
                            'Зоотовары для разных питомцев'),
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

                // 5) Контакты
                SliverToBoxAdapter(
                  child: AboutSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AboutSectionTitle('Контакты'),
                        gap12,
                        _ContactRow(
                          icon: Icons.call_outlined,
                          label: 'Телефон',
                          value: ContactsContent.phones.first.phoneUi,
                          onTap: () => makePhoneCall(
                              ContactsContent.phones.first.tel),
                        ),
                        gap8,
                        _ContactRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: AppContacts.email,
                          onTap: () => sendEmail(email: AppContacts.email),
                        ),
                        gap8,
                        _ContactRow(
                          icon: Icons.send_outlined,
                          label: 'Telegram',
                          value: '@gagin645',
                          onTap: () =>
                              openUrl(ContactsContent.telegramUrl),
                        ),
                        gap8,
                        _ContactRow(
                          icon: Icons.location_on_outlined,
                          label: 'Адрес',
                          value: ContactsContent.addressTitleUi(),
                          onTap: null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: gap12),

                // 6) Маршрут
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TealRouteCard(
                      onYandex: () =>
                          openUrl(ContactsContent.yandexRouteUrl),
                      onGoogle: () =>
                          openUrl(ContactsContent.googleRouteUrl),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                      height: tabScrollPadding(context).bottom + 16),
                ),
              ],
            ),
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
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.teal, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: t.labelSmall?.copyWith(
                        color: AppColors.softInk),
                  ),
                  Text(
                    value,
                    style: t.bodyMedium?.copyWith(
                      color: onTap != null
                          ? AppColors.teal
                          : AppColors.deepBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right,
                  color: AppColors.softInk.withValues(alpha: .5), size: 18),
          ],
        ),
      ),
    );
  }
}
