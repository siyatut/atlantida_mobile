import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../screens/about/about_screen.dart';
import '../screens/catalog/catalog_home_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/home/home_screen.dart';

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
      const CatalogHomeScreen(),
      const FavoritesScreen(),
      AboutScreen(onOpenCatalog: () => setState(() => _index = 1)),
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
            child: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Главная',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront),
                  label: 'Каталог',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_outline),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Избранное',
                ),
                NavigationDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: 'О нас',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
