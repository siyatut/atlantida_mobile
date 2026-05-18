import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Generic teal-gradient card. Pass any [child] as content.
class TealCard extends StatelessWidget {
  const TealCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

/// Teal card with a subtitle and "Позвонить" / "Написать" buttons.
class TealCtaCard extends StatelessWidget {
  const TealCtaCard({
    super.key,
    this.subtitle = 'Свяжитесь с нами удобным способом',
    required this.onCall,
    required this.onWrite,
  });

  final String subtitle;
  final VoidCallback onCall;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return TealCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: t.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: .85),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _TealOutlinedButton(
                  onPressed: onCall,
                  icon: Icons.call_outlined,
                  label: 'Позвонить',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TealOutlinedButton(
                  onPressed: onWrite,
                  icon: Icons.chat_bubble_outline,
                  label: 'Написать',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Teal card with a subtitle and two map route buttons.
class TealRouteCard extends StatelessWidget {
  const TealRouteCard({
    super.key,
    this.subtitle = 'Построить маршрут',
    required this.onYandex,
    required this.onGoogle,
  });

  final String subtitle;
  final VoidCallback onYandex;
  final VoidCallback onGoogle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return TealCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: t.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _TealOutlinedButton(
                  onPressed: onYandex,
                  icon: Icons.map_outlined,
                  label: 'Яндекс Карты',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TealOutlinedButton(
                  onPressed: onGoogle,
                  icon: Icons.directions_outlined,
                  label: 'Google Maps',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TealOutlinedButton extends StatelessWidget {
  const _TealOutlinedButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white.withValues(alpha: .5)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
