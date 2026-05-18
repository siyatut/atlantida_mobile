import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../theme/app_colors.dart';

import '../screens/about/about_screen.dart';
import '../screens/catalog/catalog_home_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/home/home_screen.dart';

class _NavItem {
  const _NavItem({required this.icon, required this.activeIcon});
  final IconData icon;
  final IconData activeIcon;
}

const _navItems = [
  _NavItem(icon: Icons.home_outlined,       activeIcon: Icons.home),
  _NavItem(icon: Icons.storefront_outlined, activeIcon: Icons.storefront),
  _NavItem(icon: Icons.favorite_outline,    activeIcon: Icons.favorite),
  _NavItem(icon: Icons.info_outline,        activeIcon: Icons.info),
];

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          for (int i = 0; i < _navItems.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: i == selectedIndex
                          ? AppColors.teal
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      i == selectedIndex
                          ? _navItems[i].activeIcon
                          : _navItems[i].icon,
                      size: 24,
                      color: i == selectedIndex
                          ? Colors.white
                          : AppColors.teal,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(
        onOpenCatalog: () => setState(() => _index = 1),
        onOpenFavorites: () => setState(() => _index = 2),
      ),
      CatalogHomeScreen(onGoHome: () => setState(() => _index = 0)),
      FavoritesScreen(onGoHome: () => setState(() => _index = 0)),
      AboutScreen(
        onOpenCatalog: () => setState(() => _index = 1),
        onGoHome: () => setState(() => _index = 0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Stack(
            children: List.generate(_pages.length, (i) {
              final selected = i == _index;

              return AnimatedSlide(
                duration: const Duration(milliseconds: 230),
                curve: Curves.easeOutCubic,
                offset: selected ? Offset.zero : const Offset(0.018, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 170),
                  curve: Curves.easeOut,
                  opacity: selected ? 1 : 0,
                  child: IgnorePointer(ignoring: !selected, child: _pages[i]),
                ),
              );
            }),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: _BottomNav(
              selectedIndex: _index,
              onTap: (i) => setState(() => _index = i),
            ),
          ),
        ),
      ),
    );
  }
}
