import 'woo_dto.dart';

class CategoryTree {
  final List<WooCategory> all;
  final Map<int, WooCategory> byId;
  final Map<int, List<WooCategory>> childrenByParent;

  CategoryTree._(this.all, this.byId, this.childrenByParent);

  factory CategoryTree.fromList(List<WooCategory> list) {
    final byId = <int, WooCategory>{for (final c in list) c.id: c};
    final children = <int, List<WooCategory>>{};
    for (final c in list) {
      children.putIfAbsent(c.parent, () => []).add(c);
    }
    for (final e in children.entries) {
      e.value.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    return CategoryTree._(list, byId, children);
    }

  List<WooCategory> childrenOf(int parentId) =>
      childrenByParent[parentId] ?? const [];
}