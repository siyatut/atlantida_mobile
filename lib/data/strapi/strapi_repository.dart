import '../../data/woo/category_tree.dart';
import '../../domain/product.dart';
import 'strapi_client.dart';
import 'strapi_dto.dart';
import 'strapi_mappers.dart';

class StrapiRepository {
  final StrapiClient _client;

  StrapiRepository([StrapiClient? client]) : _client = client ?? StrapiClient();

  List<dynamic>? _rawProductsCache;
  CategoryTree? _treeCache;

  Future<List<dynamic>> _loadRawProducts() async {
    _rawProductsCache ??= await _client.fetchAll(
      '/api/products',
      query: {
        'populate[subcategories]': 'true',
        'populate[mainCategory]': 'true',
        'populate[images]': 'true',
      },
    );
    return _rawProductsCache!;
  }

  bool _matchesCategory(dynamic raw, int categoryId) {
    final record = getEntityRecord(raw);
    if (record == null) return false;
    if (getRelationId(record['mainCategory']) == categoryId) return true;
    return getRelationEntities(record['subcategories'])
        .any((e) => getEntityId(e) == categoryId);
  }

  Future<List<Product>> products({
    int page = 1,
    int perPage = 20,
    int? categoryId,
  }) async {
    final raw = await _loadRawProducts();
    final filtered = categoryId == null
        ? raw
        : raw.where((p) => _matchesCategory(p, categoryId)).toList();

    final offset = (page - 1) * perPage;
    if (offset >= filtered.length) return const [];
    final end = (offset + perPage).clamp(offset, filtered.length);
    return filtered
        .sublist(offset, end)
        .map(mapStrapiProduct)
        .whereType<Product>()
        .toList();
  }

  Future<CategoryTree> categoryTree() async {
    if (_treeCache != null) return _treeCache!;

    final results = await Future.wait([
      _client.fetchAll('/api/main-categories'),
      _client.fetchAll(
        '/api/subcategories',
        query: {
          'populate[mainCategory]': 'true',
          'populate[parent]': 'true',
        },
      ),
    ]);

    final categories = buildCatalogCategories(results[0], results[1]);
    _treeCache = CategoryTree.fromList(categories);
    return _treeCache!;
  }

  void invalidateCache() {
    _rawProductsCache = null;
    _treeCache = null;
  }
}
