import 'package:sembast/sembast.dart';

/// Excepción personalizada para centralizar y estandarizar los errores 
/// provenientes del acceso a datos, manteniendo la causa original.
class DaoException implements Exception {
  final String message;
  final Object? cause;

  DaoException(this.message, [this.cause]);

  @override
  String toString() => 'DaoException: $message${cause != null ? ' (Causa: $cause)' : ''}';
}

/// Clase abstracta base para los DAOs (Data Access Objects) utilizando Sembast.
/// Proporciona las operaciones CRUD estándar para cualquier entidad de tipo [T].
abstract class SembastDao<T> {
  final Database database;
  final StoreRef<String, Map<String, dynamic>> store;

  /// Constructor principal que inicializa la base de datos y crea la referencia
  /// al almacén a partir de su nombre [storeName].
  SembastDao(this.database, String storeName)
      : store = stringMapStoreFactory.store(storeName);

  /// Constructor alternativo que permite inyectar directamente la referencia
  /// del almacén ya creada. Útil para pruebas o configuraciones avanzadas.
  SembastDao.withStore(this.database, this.store);

  /// Convierte una entidad de tipo [T] a un mapa JSON compatible con Sembast.
  Map<String, dynamic> toJson(T item);

  /// Construye una entidad de tipo [T] a partir de un mapa JSON proveniente de Sembast.
  T fromJson(Map<String, dynamic> json);

  /// Recupera una lista paginada de registros del almacén.
  /// [offset] indica cuántos registros saltar antes de empezar a devolver 
  /// resultados (debe ser >= 0).
  /// [limit] define la cantidad máxima de registros a devolver (si se provee, debe ser > 0).
  Future<List<T>> findRange({int offset = 0, int? limit}) {
    if (offset < 0) {
      throw ArgumentError('El valor de offset no debe ser menor a 0.');
    }
    if (limit != null && limit <= 0) {
      throw ArgumentError('El valor de limit debe ser mayor a 0.');
    }

    return _runDbOperation(() async {
      final finder = Finder(
        offset: offset,
        limit: limit,
        sortOrders: [SortOrder(Field.key, true)],
      );

      final snapshots = await store.find(database, finder: finder);
      return snapshots.map((snapshot) => fromJson(snapshot.value)).toList();
    }, 'findRange');
  }

  /// Busca y devuelve un registro específico a partir de su [id].
  /// Retorna la entidad [T] si se encuentra, o `null` si el registro no existe.
  Future<T?> findById(String id) {
    _validateId(id);

    return _runDbOperation(() async {
      final snapshot = await store.record(id).getSnapshot(database);
      if (snapshot == null) {
        return null;
      }
      return fromJson(snapshot.value);
    }, 'findById');
  }

  /// Inserta un nuevo registro o actualiza uno existente identificado por su [id].
  /// El parámetro [item] es la entidad a guardar.
  Future<void> put(String id, T item) {
    _validateId(id);

    final json = toJson(item);
    if (json.isEmpty) {
      throw ArgumentError('El item serializado no puede estar vacío.');
    }

    return _runDbOperation(
      () => store.record(id).put(database, json),
      'put',
    );
  }

  /// Elimina de la base de datos el registro asociado al [id].
  /// Retorna `true` si el registro se eliminó exitosamente, o `false` si 
  /// el registro no existía.
  Future<bool> delete(String id) {
    _validateId(id);

    return _runDbOperation(() async {
      final deletedKey = await store.record(id).delete(database);
      return deletedKey != null;
    }, 'delete');
  }

  /// Devuelve el número total de registros almacenados en este store.
  Future<int> count() {
    return _runDbOperation(() => store.count(database), 'count');
  }

  /// Valida que el [id] proporcionado no sea nulo ni esté vacío.
  void _validateId(String id) {
    if (id.trim().isEmpty) {
      throw ArgumentError('El id no puede estar vacío.');
    }
  }

  /// Método envoltorio (wrapper) para ejecutar operaciones de Sembast.
  /// Atrapa las excepciones comunes, estandariza los errores lanzados hacia 
  /// la capa superior mediante [DaoException], y preserva el `StackTrace` 
  /// original para no obstaculizar la depuración.
  Future<R> _runDbOperation<R>(
    Future<R> Function() operation,
    String methodName,
  ) async {
    try {
      return await operation();
    } on DatabaseException catch (e) {
      throw DaoException('Error específico de Sembast en $methodName', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error inesperado en $methodName', e),
        stackTrace,
      );
    }
  }
}