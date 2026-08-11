import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class MarcaDAO extends SembastDao<Marca> {
  MarcaDAO(Database database) : super(database, SembastStores.marca);

  @override
  Marca fromJson(Map<String, dynamic> json) {
    return Marca.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Marca item) {
    return item.toJson();
  }

  /// Busca y retorna una lista de marcas cuyo nombre coincida total o parcialmente con el [query].
  ///
  /// La búsqueda evalúa coincidencias ignorando mayúsculas y minúsculas
  /// (case-insensitive) y devuelve los resultados ordenados alfabéticamente
  /// por el nombre de la marca.
  ///
  /// El texto ingresado en [query] es sanitizado internamente para prevenir
  /// errores generados por caracteres especiales en la expresión regular.
  ///
  /// Lanza una [DaoException] en caso de presentarse un fallo interno en Sembast
  /// o un error inesperado durante la transacción[cite: 4].
  Future<List<Marca>> buscarPorNombreMarca(String query) async {
    final regExp = RegExp(RegExp.escape(query), caseSensitive: false);
    try {
      final finder = Finder(
        filter: Filter.matches('nombreMarca', regExp.pattern),
        sortOrders: [SortOrder('nombreMarca')],
      );

      final snapshots = await store.find(database, finder: finder);

      return snapshots.map((snapshot) {
        final map = Map<String, dynamic>.from(snapshot.value as Map);
        map['id'] = snapshot.key;

        return fromJson(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw DaoException('Error específico de Sembast en buscarPorNombre', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error inesperado en buscarPorNombre', e),
        stackTrace,
      );
    }
  }

  /// Construye dinámicamente los filtros de Sembast basados en los [FilterParams].
  /// 
  /// Este es un método privado auxiliar para no repetir la lógica de filtrado
  /// entre la consulta de datos y la consulta de conteo.
  Filter? _buildFilter(FilterParams params) {
    final List<Filter> filters = [];

    // Filtro 1: Búsqueda por texto (Ignora mayúsculas/minúsculas)
    if (params.query.trim().isNotEmpty) {
      final regExp = RegExp(RegExp.escape(params.query.trim()), caseSensitive: false);
      filters.add(Filter.matches('nombreMarca', regExp.pattern));
    }

    // Filtro 2: Búsqueda por letra inicial
    if (params.initialLetter != null && params.initialLetter!.trim().isNotEmpty) {
      // Usamos el símbolo '^' en la expresión regular para indicar "que empiece con"
      final letterRegExp = RegExp('^${RegExp.escape(params.initialLetter!.trim())}', caseSensitive: false);
      filters.add(Filter.matches('nombreMarca', letterRegExp.pattern));
    }

    // Si no hay filtros, retornamos null (trae todo). 
    // Si hay varios, los unimos con una condición AND.
    if (filters.isEmpty) return null;
    if (filters.length == 1) return filters.first;
    return Filter.and(filters);
  }

  /// Recupera una lista paginada y filtrada de marcas.
  ///
  /// Aplica los filtros de búsqueda, letra inicial, ordenamiento (A-Z o Z-A) 
  /// y los límites de paginación solicitados en [params].
  ///
  /// Lanza [DaoException] si ocurre un error en la base de datos local.
  Future<List<Marca>> obtenerMarcasConFiltros(FilterParams params) async {
    try {
      final filter = _buildFilter(params);
      
      // Determinamos si el orden es ascendente o descendente
      final isAscending = params.sortDirection == SortDirection.asc;

      final finder = Finder(
        filter: filter,
        sortOrders: [SortOrder('nombreMarca', isAscending)],
        // Lógica de Paginación para Sembast
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
      throw DaoException('Error de Sembast al obtener marcas filtradas', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error inesperado al obtener marcas filtradas', e),
        stackTrace,
      );
    }
  }

  /// Cuenta el total exacto de marcas que coinciden con los filtros actuales.
  /// 
  /// Este método es súper rápido porque no extrae los datos, solo los cuenta.
  /// Es vital para que el widget de paginación sepa cuántas páginas dibujar.
  Future<int> contarMarcasConFiltros(FilterParams params) async {
    try {
      final filter = _buildFilter(params);
      return await store.count(database, filter: filter);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error al contar las marcas filtradas', e),
        stackTrace,
      );
    }
  }
}
