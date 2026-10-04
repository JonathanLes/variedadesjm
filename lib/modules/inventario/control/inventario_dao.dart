import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class InventarioDAO extends SembastDao<Inventario> {
  InventarioDAO(Database database) : super(database, SembastStores.inventario);

  @override
  Inventario fromJson(Map<String, dynamic> json) {
    return Inventario.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Inventario item) {
    return item.toJson();
  }

  /// Construye los filtros de Sembast combinando los parámetros globales y los filtros específicos.
  /// 
  /// Se inicializa una lista mutable `filters` para agrupar todas las condiciones de consulta.
  /// Si `params.query` contiene texto, crea una expresión regular ignorando mayúsculas/minúsculas 
  /// para evaluar coincidencias simultáneas en los campos `codigo` y `color` mediante un `Filter.or`.
  /// Si el parámetro opcional `idZapato` no es nulo ni vacío, se agrega un filtro de igualdad estricta 
  /// (`Filter.equals`) para aislar el stock de un modelo particular.
  /// Si el parámetro opcional `estado` es provisto, se filtra convirtiendo el enum a su nombre en `String` 
  /// para hacer coincidir el estado del calzado en base de datos (`activo`, `reservado`, `vendido`).
  /// Finalmente, si existen múltiples filtros los agrupa en una única condición `Filter.and`.
  Filter? _buildFilter(FilterParams params, {String? idZapato, EstadoZapato? estado}) {
    final List<Filter> filters = [];

    if (params.query.trim().isNotEmpty) {
      final queryText = params.query.trim();
      final regExp = RegExp(RegExp.escape(queryText), caseSensitive: false);
      filters.add(
        Filter.or([
          Filter.matches('codigo', regExp.pattern),
          Filter.matches('color', regExp.pattern),
        ]),
      );
    }

    if (idZapato != null && idZapato.isNotEmpty) {
      filters.add(Filter.equals('idZapato', idZapato));
    }

    if (estado != null) {
      filters.add(Filter.equals('estado', estado.name));
    }

    if (filters.isEmpty) return null;
    if (filters.length == 1) return filters.first;
    return Filter.and(filters);
  }

  /// Recupera un listado paginado y filtrado de los registros de inventario físico.
  /// 
  /// Construye el filtro dinámico ejecutando `_buildFilter` con las variables recibidas.
  /// Define la variable booleana `isAscending` según el sentido del ordenamiento solicitado en `params`.
  /// Configura el objeto `finder` ordenando por el campo `fechaCompra` y estableciendo la ventana de paginación
  /// mediante `limit` (elementos por página) y `offset` (cálculo de salto de registros según la página actual).
  /// Ejecuta la consulta sobre el `store` asignando el resultado a `snapshots`.
  /// Mapea los resultados convirtiendo los mapas JSON a instancias de `Inventario` e inyectando la clave de Sembast.
  /// Captura excepciones de tipo `DatabaseException` y re-lanza un `DaoException` con la traza de error.
  Future<List<Inventario>> obtenerInventarioConFiltros(
    FilterParams params, {
    String? idZapato,
    EstadoZapato? estado,
  }) async {
    try {
      final filter = _buildFilter(params, idZapato: idZapato, estado: estado);
      final isAscending = params.sortDirection == SortDirection.asc;

      final finder = Finder(
        filter: filter,
        sortOrders: [SortOrder('fechaCompra', isAscending)],
        limit: params.pageSize,
        offset: (params.page - 1) * params.pageSize,
      );

      final snapshots = await store.find(database, finder: finder);

      return snapshots.map((snapshot) {
        final map = Map<String, dynamic>.from(snapshot.value as Map);
        map['id'] = snapshot.key;
        return fromJson(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw DaoException('Error de Sembast al obtener el inventario filtrado', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(DaoException('Error inesperado en inventario', e), stackTrace);
    }

  }

  /// Indica si existe al menos una unidad de inventario asociada al [idZapato].
  Future<bool> existePorZapato(String idZapato) async {
    final count = await store.count(database, filter: Filter.equals('idZapato', idZapato));
    return count > 0;
  }

  /// Cuenta la cantidad total de unidades de inventario que cumplen con los criterios especificados.
  /// 
  /// Invoca internamente a `_buildFilter` para componer la estructura de filtrado requerida.
  /// Ejecuta el método `count` sobre el `store` de Sembast, optimizando el consumo de recursos 
  /// al no traer los registros completos a memoria, retornando únicamente el entero total.
  /// Lanza una `DaoException` en caso de fallos en el motor local de la base de datos.
  Future<int> contarInventarioConFiltros(
    FilterParams params, {
    String? idZapato,
    EstadoZapato? estado,
  }) async {
    try {
      final filter = _buildFilter(params, idZapato: idZapato, estado: estado);
      return await store.count(database, filter: filter);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(DaoException('Error al contar unidades de inventario', e), stackTrace);
    }
  }

  /// Busca un ítem de inventario en la base de datos utilizando su código autogenerado.
  /// 
  /// Configura un `Finder` con un filtro de igualdad estricta sobre el campo `codigo`.
  /// Busca el primer snapshot coincidente en la base de datos local Sembast.
  /// Si encuentra un registro, convierte el mapa a un objeto `Inventario` inyectando su ID.
  /// Retorna `null` si no existe ningún zapato en inventario registrado con dicho código.
  Future<Inventario?> buscarPorCodigo(String codigo) async {
    try {
      final finder = Finder(filter: Filter.equals('codigo', codigo));
      final snapshot = await store.findFirst(database, finder: finder);

      if (snapshot == null) return null;

      final map = Map<String, dynamic>.from(snapshot.value as Map);
      map['id'] = snapshot.key;
      return fromJson(map);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(DaoException('Error al buscar por código', e), stackTrace);
    }
  }
}