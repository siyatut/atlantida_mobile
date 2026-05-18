import '../../core/env.dart';
import '../../data/woo/woo_dto.dart';
import '../../domain/product.dart';
import 'strapi_dto.dart';

String _mediaUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  final base = Env.get('STRAPI_API_URL', defaultValue: 'http://localhost:1337');
  return '$base${path.startsWith('/') ? path : '/$path'}';
}

List<String> _extractMediaUrls(dynamic value) {
  final entities = getRelationEntities(value);
  final urls = <String>[];
  for (final e in entities) {
    final record = getEntityRecord(e);
    if (record == null) continue;
    final url = _mediaUrl(getString(record['url']));
    if (url.isNotEmpty) urls.add(url);
    final formats = record['formats'];
    if (formats is Map) {
      for (final fv in formats.values) {
        if (fv is! Map) continue;
        final fu = _mediaUrl(getString(fv['url']));
        if (fu.isNotEmpty && !urls.contains(fu)) urls.add(fu);
      }
    }
  }
  return urls;
}

// Strips trailing decimal zeros: "60.00" → "60", "12.50" → "12.50".
String? _formatPrice(dynamic value) {
  if (value == null) return null;
  final str = value.toString().trim().replaceAll(',', '.');
  if (str.isEmpty) return null;
  if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(str)) return null;
  if (!str.contains('.')) return str;
  var result = str.replaceAll(RegExp(r'0+$'), '');
  if (result.endsWith('.')) result = result.substring(0, result.length - 1);
  return result.isEmpty ? null : result;
}

Product? mapStrapiProduct(dynamic raw) {
  final record = getEntityRecord(raw);
  final id = getEntityId(raw);
  if (record == null || id == null) return null;

  final images = _extractMediaUrls(record['images']);
  final subcats = getRelationEntities(record['subcategories']);
  final mainCatRecord = getEntityRecord(getRelationEntity(record['mainCategory']));

  String? categorySlug;
  if (subcats.isNotEmpty) {
    categorySlug = getString(getEntityRecord(subcats.first)?['slug']);
  }
  categorySlug ??= getString(mainCatRecord?['slug']);

  return Product(
    id: id,
    documentId: getEntityDocumentId(raw),
    title: getString(record['title']) ?? getString(record['name']) ?? 'Товар',
    price: _formatPrice(record['price'] ?? record['currentPrice']),
    oldPrice: _formatPrice(record['regularPrice'] ?? record['basePrice']),
    category: categorySlug,
    image: images.isNotEmpty ? images.first : null,
    images: images,
    inStock: getBoolValue(record['isInStock']) ?? getBoolValue(record['inStock']),
    shortDescription:
        getString(record['shortDescription']) ?? getString(record['short_description']),
    description: getString(record['description']),
    permalink: getString(record['permalink']),
  );
}

List<dynamic> _sortByOrder(List<dynamic> items) {
  return [...items]..sort((a, b) {
      final ra = getEntityRecord(a);
      final rb = getEntityRecord(b);
      final oa = (ra?['sortOrder'] as num?)?.toInt() ?? 999999;
      final ob = (rb?['sortOrder'] as num?)?.toInt() ?? 999999;
      if (oa != ob) return oa.compareTo(ob);
      final na = getString(ra?['title']) ?? getString(ra?['name']) ?? '';
      final nb = getString(rb?['title']) ?? getString(rb?['name']) ?? '';
      return na.compareTo(nb);
    });
}

WooCategory? mapStrapiMainCategory(dynamic raw) {
  final record = getEntityRecord(raw);
  final id = getEntityId(raw);
  final name = getString(record?['title']) ?? getString(record?['name']);
  final slug = getString(record?['slug']);
  if (id == null || name == null || slug == null) return null;
  if (record?['isActive'] == false) return null;
  return WooCategory(id: id, name: name, slug: slug, parent: 0);
}

WooCategory? mapStrapiSubcategory(dynamic raw) {
  final record = getEntityRecord(raw);
  final id = getEntityId(raw);
  final name = getString(record?['title']) ?? getString(record?['name']);
  final slug = getString(record?['slug']);
  if (id == null || name == null || slug == null) return null;
  final parent =
      getRelationId(record?['parent']) ?? getRelationId(record?['mainCategory']);
  if (parent == null) return null;
  return WooCategory(id: id, name: name, slug: slug, parent: parent);
}

List<WooCategory> buildCatalogCategories(
  List<dynamic> rawMain,
  List<dynamic> rawSubs,
) {
  final main = _sortByOrder(rawMain)
      .map(mapStrapiMainCategory)
      .whereType<WooCategory>()
      .toList();
  final subs = _sortByOrder(rawSubs)
      .map(mapStrapiSubcategory)
      .whereType<WooCategory>()
      .toList();
  return [...main, ...subs];
}
