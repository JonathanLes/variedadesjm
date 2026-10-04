import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class ZapatoDAO extends SembastDao<Zapato> {
  ZapatoDAO(Database database) : super(database, SembastStores.zapato);

  @override
  Zapato fromJson(Map<String, dynamic> json) {
    return Zapato.fromJson(json);
  }

  /// Indica si un modelo pertenece a la marca indicada por [idMarca].
  Future<bool> existePorMarca(String idMarca) async {
    final count = await store.count(database, filter: Filter.equals('idMarca', idMarca));
    return count > 0;
  }

  /// Indica si un modelo pertenece a la categoría indicada por [idCategoria].
  Future<bool> existePorCategoria(String idCategoria) async {
    final count = await store.count(database, filter: Filter.equals('idCategoria', idCategoria));
    return count > 0;
  }

  @override
  Map<String, dynamic> toJson(Zapato item) {
    return item.toJson();
  }

  /// Construye los filtros de Sembast basados en los parámetros de búsqueda y relaciones.
  /// 
  /// Se inicializa una lista vacía `filters` para almacenar las condiciones.
  /// Primero evalúa si `params.query` contiene texto; de ser así, crea una expresión regular
  /// ignorando mayúsculas/minúsculas y la añade a los filtros para buscar coincidencias 
  /// en el campo `modelo`.
  /// Luego verifica si se requiere buscar por una letra inicial específica en `params.initialLetter`,
  /// añadiendo una expresión regular que obligue al texto a empezar con dicho carácter.
  /// Posteriormente, verifica si los parámetros opcionales `idMarca` e `idCategoria` no son nulos;
  /// si tienen valor, se añaden filtros de igualdad estricta (`Filter.equals`) para asegurar
  /// que la consulta traiga únicamente los zapatos pertenecientes a dichas entidades.
  /// Finalmente, si la lista de filtros tiene más de un elemento, los agrupa con un `Filter.and`
  /// para que todas las condiciones se cumplan simultáneamente, o devuelve el único filtro o nulo.
  Filter? _buildFilter(FilterParams params, {String? idMarca, String? idCategoria}) {
    final List<Filter> filters = [];

    if (params.query.trim().isNotEmpty) {
      final regExp = RegExp(RegExp.escape(params.query.trim()), caseSensitive: false);
      filters.add(Filter.matches('modelo', regExp.pattern));
    }

    if (params.initialLetter != null && params.initialLetter!.trim().isNotEmpty) {
      final letterRegExp = RegExp('^${RegExp.escape(params.initialLetter!.trim())}', caseSensitive: false);
      filters.add(Filter.matches('modelo', letterRegExp.pattern));
    }

    if (idMarca != null) {
      filters.add(Filter.equals('idMarca', idMarca));
    }

    if (idCategoria != null) {
      filters.add(Filter.equals('idCategoria', idCategoria));
    }

    if (filters.isEmpty) return null;
    if (filters.length == 1) return filters.first;
    return Filter.and(filters);
  }

  /// Obtiene una lista paginada y filtrada de zapatos desde la base de datos local.
  /// 
  /// Utiliza la variable `filter` llamando al método `_buildFilter` para obtener las condiciones.
  /// Declara `isAscending` evaluando si la dirección de ordenamiento en `params` es ascendente.
  /// Configura el objeto `finder` de Sembast enviándole el `filter`, estableciendo un ordenamiento
  /// basado en el campo `modelo` usando la variable booleana anterior, y aplicando los límites
  /// aritméticos de `limit` (tamaño de página) y `offset` (salto de registros calculando la página).
  /// Ejecuta la consulta asíncrona sobre el `store` guardando el resultado en `snapshots`.
  /// Transforma los `snapshots` en una lista de objetos `Zapato`, inyectando la llave principal
  /// de Sembast dentro de la propiedad `id` del mapa antes de pasarlo por `fromJson`.
  /// Captura excepciones de `DatabaseException` lanzando un `DaoException` formateado.
  Future<List<Zapato>> obtenerZapatosConFiltros(FilterParams params, {String? idMarca, String? idCategoria}) async {
    try {
      final filter = _buildFilter(params, idMarca: idMarca, idCategoria: idCategoria);
      final isAscending = params.sortDirection == SortDirection.asc;

      final finder = Finder(
        filter: filter,
        sortOrders: [SortOrder('modelo', isAscending)],
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
      throw DaoException('Error de Sembast al obtener zapatos filtrados', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(DaoException('Error inesperado', e), stackTrace);
    }
  }

  /// Cuenta el total exacto de zapatos que cumplen con las condiciones solicitadas.
  /// 
  /// Emplea la variable `filter` llamando a `_buildFilter` para obtener el bloque de restricciones.
  /// Ejecuta la función `count` del `store` de Sembast para contar sin extraer los datos completos,
  /// lo cual optimiza la memoria y permite calcular la paginación en la interfaz.
  /// Lanza una `DaoException` en caso de fallos en el motor de base de datos.
  Future<int> contarZapatosConFiltros(FilterParams params, {String? idMarca, String? idCategoria}) async {
    try {
      final filter = _buildFilter(params, idMarca: idMarca, idCategoria: idCategoria);
      return await store.count(database, filter: filter);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(DaoException('Error al contar zapatos', e), stackTrace);
    }
  }
}