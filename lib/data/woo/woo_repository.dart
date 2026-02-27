import '../../domain/product.dart';
import 'category_tree.dart';
import 'woo_client.dart';
import 'woo_dto.dart';
import 'woo_mappers.dart';

class WooRepository {
  final WooClient client;
  WooRepository({WooClient? client}) : client = client ?? WooClient();

  CategoryTree? _treeCache;

  /// Товары по конкретной категории
  Future<List<Product>> products({
    int page = 1,
    int perPage = 20,
    int? categoryId,
  }) async {
    final raw = await client.getProducts(
      page: page,
      perPage: perPage,
      categoryId: categoryId,
    );

    return raw
        .map((e) => productFromWooJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Все категории (плоский список)
  Future<List<WooCategory>> allCategories({int perPage = 100}) async {
    final raw = await client.getCategories(perPage: perPage);
    return raw
        .map((e) => WooCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Дерево категорий с кешем (чтобы не грузить каждый раз)
  Future<CategoryTree> categoryTree({int perPage = 100}) async {
    if (_treeCache != null) return _treeCache!;
    final all = await allCategories(perPage: perPage);
    _treeCache = CategoryTree.fromList(all);
    return _treeCache!;
  }

  /// Если вдруг захочешь принудительно обновлять
  void invalidateCache() {
    _treeCache = null;
  }
}