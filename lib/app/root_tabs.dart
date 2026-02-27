import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../screens/about/about_screen.dart';
import '../screens/catalog/catalog_home_screen.dart';
import '../screens/contacts/contacts_screen.dart';
import '../screens/home/home_screen.dart';

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;
  late final List<Widget> _pages;

  static const _titles = ['Главная', 'Каталог', 'О нас', 'Контакты'];

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(onOpenCatalog: () => setState(() => _index = 1)),
      const CatalogHomeScreen(),
      AboutScreen(onOpenCatalog: () => setState(() => _index = 1)),
      const ContactsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          title: Text(_titles[_index]),
        ),
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
                label: 'Главная',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                label: 'Каталог',
              ),
              NavigationDestination(
                icon: Icon(Icons.info_outline),
                label: 'О нас',
              ),
              NavigationDestination(
                icon: Icon(Icons.call_outlined),
                label: 'Контакты',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
