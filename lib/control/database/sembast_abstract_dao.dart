import 'package:sembast/sembast.dart';

abstract class SembastDao<T> {
  final Database database;
  final StoreRef<String, Map<String, dynamic>> store;

  SembastDao.withStore(this.database, this.store);

  Map<String, dynamic> toJson(T item);
  T fromJson(Map<String, dynamic> json);

    SembastDao(this.database, String storeName)
      : store = stringMapStoreFactory.store(storeName);

  Future<List<T>> findRange({int offset = 0, int? limit}) async {
    if (offset < 0) {
      throw ArgumentError("El valor de Offset no debe ser menor a 0");
    }

    if (limit != null && limit <= 0) {
      throw ArgumentError(
        "El valor del limit debe de ser mayor que cero y no puede ser null",
      );
    }

    try {
      final finder = Finder(
        offset: offset,
        limit: limit,
        sortOrders: [SortOrder(Field.key, true)],
      );

      final snapshots = await store.find(database, finder: finder);
      return snapshots.map((snapshot) => fromJson(snapshot.value)).toList();
    } on DatabaseException catch (e) {
      print('Error específico de Sembast en findRange: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error insesperado con el método findRange: $e');
      throw Exception('Error al leer los datos de la base de datos');
    }
  }

  Future<T?> findById(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError("El id no puede ser vacío");
    }

    try {
      final snapshot = await store.record(id).getSnapshot(database);
      if (snapshot == null) {
        return null;
      }
      return fromJson(snapshot.value);
    } on DatabaseException catch (e) {
      print('Error específico de Sembast en findById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error insesperado con el método findById: $e');
      throw Exception('Error al leer los datos de la base de datos');
    }
  }

  Future<void> put(String id, T item) async {
    if (id.trim().isEmpty) {
      throw ArgumentError("El id no puede ser vacío");
    }

    final json = toJson(item);
    if (json.isEmpty) {
      throw ArgumentError("El item no puede ser vacío");
    }

    try {
      await store.record(id).put(database, json);
    } on DatabaseException catch (e) {
      print('Error específico de Sembast en put: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error insesperado con el método put: $e');
      throw Exception('Error al guardar el registro en la base de datos');
    }
  }

  Future<bool> delete(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError("El id no puede ser vacío");
    }

    try {
      final deleted = await store.record(id).delete(database);
      return deleted != null;
    } on DatabaseException catch (e) {
      print('Error específico de Sembast en delete: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error insesperado con el método delete: $e');
      throw Exception('Error al eliminar el registro en la base de datos');
    }
  }

  Future<int> count() async {
    try {
      return await store.count(database);
    } on DatabaseException catch (e) {
      print('Error específico de Sembast en count: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error insesperado con el método count: $e');
      throw Exception('Error al contar los registros de la base de datos');
    }
  }
}