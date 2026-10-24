/// Centraliza la escritura de entidades en stores Sembast.
import 'package:sembast/sembast.dart';

/// Guarda una entidad serializada con una clave explícita.
Future<void> writeRecord({
  required Database database,
  required String storeName,
  required String id,
  required Map<String, dynamic> value,
}) {
  final store = stringMapStoreFactory.store(storeName);
  return store.record(id).put(database, value);
}

/// Elimina un registro por clave sin exponer detalles de Sembast a las vistas.
Future<void> deleteRecord({
  required Database database,
  required String storeName,
  required String id,
}) {
  final store = stringMapStoreFactory.store(storeName);
  return store.record(id).delete(database);
}
