// Helper functions for navigating Strapi v4/v5 entity shapes.
// Strapi v5: flat { id, documentId, ...fields }
// Strapi v4: { id, attributes: { ...fields } }

Map<String, dynamic>? getEntityRecord(dynamic entity) {
  if (entity is! Map) return null;
  final map = Map<String, dynamic>.from(entity);
  final attrs = map['attributes'];
  if (attrs is Map) return Map<String, dynamic>.from(attrs);
  return map;
}

int? getEntityId(dynamic entity) {
  if (entity is! Map) return null;
  final id = entity['id'];
  if (id is int) return id;
  if (id is String) return int.tryParse(id);
  return null;
}

String? getEntityDocumentId(dynamic entity) {
  if (entity is! Map) return null;
  final v = entity['documentId'];
  return v is String && v.isNotEmpty ? v : null;
}

dynamic _unwrapRelation(dynamic value) {
  if (value is Map && value.containsKey('data')) return value['data'];
  return value;
}

List<dynamic> getRelationEntities(dynamic value) {
  final raw = _unwrapRelation(value);
  if (raw is List) return raw.whereType<Map>().toList();
  if (raw is Map) return [raw];
  return const [];
}

dynamic getRelationEntity(dynamic value) {
  final entities = getRelationEntities(value);
  return entities.isEmpty ? null : entities.first;
}

int? getRelationId(dynamic value) {
  return getEntityId(getRelationEntity(value));
}

String? getString(dynamic value) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  return null;
}

bool? getBoolValue(dynamic value) {
  if (value is bool) return value;
  return null;
}
