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
import '../home/home_content.dart';

import 'about_content.dart';
import 'widgets/about_section_title.dart';
import 'widgets/about_surface_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, this.onOpenCatalog, this.onGoHome});

  final VoidCallback? onOpenCatalog;
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
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
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // 1) О магазине
                SliverToBoxAdapter(
                    child: _buildTextSection(context, aboutIntro)),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // 2) Почему выбирают
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 12),
                        child: AboutSectionTitle('Почему выбирают Атлантиду'),
                      ),
                      AboutSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final adv in HomeContent.advantages)
                              _BenefitRow(advantage: adv),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // 5) Контакты
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 12),
                        child: AboutSectionTitle('Контакты и адрес магазина'),
                      ),
                      AboutSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _ContactRow(
                          icon: Icons.call_outlined,
                          label: 'Телефон',
                          value: ContactsContent.phones.first.phoneUi,
                          onTap: () => makePhoneCall(
                              ContactsContent.phones.first.tel),
                        ),
                        gap8,
                        _ContactRow(
                          icon: Icons.call_outlined,
                          label: 'Телефон',
                          value: ContactsContent.phones[1].phoneUi,
                          onTap: () => makePhoneCall(
                              ContactsContent.phones[1].tel),
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
                          value: ContactsContent.addressFullUi(),
                          onTap: null,
                        ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // 6) Маршрут
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 12),
                    child: AboutSectionTitle('Нужен маршрут до магазина?'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TealRouteCard(
                      subtitle: 'Воспользуйтесь удобным способом',
                      onYandex: () =>
                          openUrl(ContactsContent.yandexRouteUrl),
                      onGoogle: () =>
                          openUrl(ContactsContent.googleRouteUrl),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                      height: tabScrollPadding(context).bottom),
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
                    style: t.titleSmall?.copyWith(
                      color: onTap != null
                          ? AppColors.teal
                          : AppColors.deepBlue,
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

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.advantage});

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
                  style: t.titleSmall?.copyWith(color: cs.onSurface),
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
