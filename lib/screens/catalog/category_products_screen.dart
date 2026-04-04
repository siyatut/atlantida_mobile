import 'package:flutter/material.dart';

import '../../data/woo/woo_dto.dart';
import '../../data/woo/woo_repository.dart';
import '../../domain/product.dart';
import '../../utils/tab_scroll_padding.dart';
import '../product_details/product_details_screen.dart';

import 'widgets/catalog_load_more_footer.dart';
import 'widgets/catalog_product_tile.dart';
import 'widgets/catalog_states.dart';

const String _friendlyNetworkError =
    'Не удалось загрузить каталог. Проверьте подключение к интернету и попробуйте ещё раз.';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    super.key,
    required this.repo,
    required this.category,
  });

  final WooRepository repo;
  final WooCategory category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  List<Product> _items = const [];

  // level3
  List<WooCategory> _filters = const [];
  int? _activeFilterId; 

  int _page = 1;
  static const int _perPage = 40;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadFilters();
    if (!mounted) return;

    if (_filters.isNotEmpty) {
      _activeFilterId = _filters.first.id;
    } else {
      _activeFilterId = null;
    }

    await _load(reset: true);
  }

  Future<void> _loadFilters() async {
    try {
      final tree = await widget.repo.categoryTree();
      final children = tree.childrenOf(widget.category.id);
      if (!mounted) return;
      setState(() => _filters = children);
    } catch (_) {
      if (!mounted) return;
      setState(() => _filters = const []);
    }
  }

  int get _categoryIdForRequest {
    return _activeFilterId ?? widget.category.id;
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
      final data = await widget.repo.products(
        page: _page,
        perPage: _perPage,
        categoryId: _categoryIdForRequest,
      );

      if (!mounted) return;

      setState(() {
        _items = [..._items, ...data];
        _hasMore = data.length == _perPage;
        if (_hasMore) _page += 1;
      });
    } catch (e) {
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

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Column(
        children: [
          if (_filters.isNotEmpty) _buildChips(context),

          if (_loading) const CatalogLoadingView(),

          if (!_loading && _error != null)
            CatalogErrorView(
              error: _error!,
              onRetry: () => _load(reset: true),
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
                              builder: (_) => ProductDetailsScreen(product: item),
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
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    Widget chip({
      required bool selected,
      required String label,
      required VoidCallback onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          selected: selected,
          showCheckmark: false,
          onSelected: (_) => onTap(),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 18, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(label),
            ],
          ),
          labelStyle: textTheme.labelLarge?.copyWith(
            color: selected ? Colors.white : cs.onSurface,
          ),
          selectedColor: const Color(0xFF007FAF), 
          backgroundColor: cs.surface.withValues(alpha: .95),
          side: BorderSide(color: selected ? const Color(0xFF007FAF) : Colors.transparent),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      );
    }

    final allSelected = _activeFilterId == null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(
            selected: allSelected,
            label: 'Все',
            onTap: () {
              setState(() => _activeFilterId = null);
              _load(reset: true);
            },
          ),
          for (final c in _filters)
            chip(
              selected: _activeFilterId == c.id,
              label: c.name,
              onTap: () {
                setState(() => _activeFilterId = c.id);
                _load(reset: true);
              },
            ),
        ],
      ),
    );
  }
}