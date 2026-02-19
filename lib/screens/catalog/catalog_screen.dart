import 'package:flutter/material.dart';

import '../../data/woo/woo_dto.dart';
import '../../data/woo/woo_repository.dart';
import '../../domain/product.dart';
import '../../utils/tab_scroll_padding.dart';
import '../product_details/product_details_screen.dart';

import 'widgets/catalog_filters.dart';
import 'widgets/catalog_subcategories.dart';
import 'widgets/catalog_product_tile.dart';
import 'widgets/catalog_load_more_footer.dart';
import 'widgets/catalog_states.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, this.initialFilter});
  final String? initialFilter;

  const _friendlyNetworkError =
    'Не удалось загрузить каталог. Проверьте подключение к интернету и попробуйте ещё раз.';

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String? _activeFilter; // slug верхней категории
  WooCategory? _activeSubcat; // активная подкатегория

  final _repo = WooRepository();

  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  List<Product> _items = const [];
  List<WooCategory> _cats = const [];
  List<WooCategory> _allCats = const [];

  final Map<String, int> _slugToId = {};

  int _page = 1;
  static const int _perPage = 40;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.initialFilter;
    _init();
  }

  Future<void> _init() async {
    await _loadCategories();
    if (!mounted) return;

    if (_activeFilter == null) {
      final firstSlug = _findFirstAvailableSlug();
      if (firstSlug != null) {
        _activeFilter = firstSlug;
      }
    }

    _selectFirstSubcatForActiveFilter();
    await _load(reset: true);
  }

  void _selectFirstSubcatForActiveFilter() {
    final parentId = _activeFilter == null ? null : _slugToId[_activeFilter!];
    if (parentId == null) {
      _activeSubcat = null;
      return;
    }
    final subs = _allCats.where((c) => c.parent == parentId).toList();
    _activeSubcat = subs.isNotEmpty ? subs.first : null;
  }

  String? _findFirstAvailableSlug() {
    const desiredOrder = ['rybki', 'gryzuny', 'koshki', 'sobaki'];
    for (final slug in desiredOrder) {
      if (_slugToId.containsKey(slug)) return slug;
    }
    return null;
  }

  Future<void> _loadCategories() async {
    try {
      final all = await _repo.allCategories();
      _allCats = all;

      _slugToId.clear();
      final List<WooCategory> filteredTop = [];

      for (final c in all) {
        final slug = c.slug.toLowerCase();
        if ([
              'rybki',
              'gryzuny',
              'koshki',
              'sobaki',
              'pticzy',
              'reptilii',
            ].contains(slug) &&
            c.parent == 0) {
          filteredTop.add(c);
          _slugToId[slug] = c.id;
        }
      }

      if (!mounted) return;
      setState(() => _cats = filteredTop);
    } catch (e) {
      debugPrint('Failed to load categories: $e');
    }
  }

  Future<void> _load({bool reset = false}) async {
  if (reset) {
    setState(() {
      _loading = true;
      _error = null;
      _page = 1;
      _hasMore = true;
      _items = const [];
    });
  } else {
    if (!_hasMore || _loadingMore) return;
    setState(() => _loadingMore = true);
  }

  try {
    final id = _activeSubcat?.id;
    final data = await _repo.products(
      page: _page,
      perPage: _perPage,
      categoryId: id,
    );

    if (!mounted) return;

    setState(() {
      _items = [..._items, ...data];
      _hasMore = data.length == _perPage;
      if (_hasMore) _page += 1;
    });
  } catch (e) {
  debugPrint('Failed to load products: $e');
  if (!mounted) return;
  setState(() => _error = _friendlyNetworkError);
}

  if (!mounted) return;

  setState(() {
    if (reset) {
      _loading = false;
    } else {
      _loadingMore = false;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final products = _items;

    final parentId = _activeFilter == null ? null : _slugToId[_activeFilter!];
    final subcats = parentId == null
        ? const <WooCategory>[]
        : _allCats.where((c) => c.parent == parentId).toList();

    return Column(
      children: [
        CatalogFilters(
          categories: _cats,
          activeSlug: _activeFilter,
          onSelect: (slug) {
            setState(() {
              _activeFilter = slug;
              _selectFirstSubcatForActiveFilter();
            });
            _load(reset: true);
          },
        ),

        CatalogSubcategories(
          items: subcats,
          activeId: _activeSubcat?.id,
          onSelect: (sc) {
            setState(() => _activeSubcat = sc);
            _load(reset: true);
          },
        ),

        if (_loading) const CatalogLoadingView(),

        if (!_loading && _error != null)
          CatalogErrorView(
            error: _error!,
            onRetry: _load,
          ),

        if (!_loading && _error == null)
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () => _load(reset: true),
                child: ListView.separated(
                  padding: tabScrollPadding(context),
                  itemBuilder: (_, i) {
                    if (i == products.length) {
                      return CatalogLoadMoreFooter(
                        visible: _hasMore,
                        loading: _loadingMore,
                        onTap: () => _load(),
                      );
                    }

                    final item = products[i];
                    return CatalogProductTile(
                      product: item,
                      onOpenDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: item),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, i) => i < products.length - 1
                      ? const SizedBox(height: 12)
                      : const SizedBox.shrink(),
                  itemCount: products.length + 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}