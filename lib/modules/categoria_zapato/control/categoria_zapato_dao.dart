import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart'; 
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class CategoriaZapatoDAO extends SembastDao<CategoriaZapato> {
  CategoriaZapatoDAO(Database database) : super(database, SembastStores.categoriaZapato);

  @override
  CategoriaZapato fromJson(Map<String, dynamic> json) {
    return CategoriaZapato.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CategoriaZapato item) {
    return item.toJson();
  }

  /// Busca y retorna una lista de categorías cuyo nombre coincida total o parcialmente con el [query].
  ///
  /// La búsqueda evalúa coincidencias ignorando mayúsculas y minúsculas
  /// (case-insensitive) y devuelve los resultados ordenados alfabéticamente
  /// por el nombre de la categoría.
  ///
  /// El texto ingresado en [query] es sanitizado internamente para prevenir
  /// errores generados por caracteres especiales en la expresión regular.
  ///
  /// Lanza una [DaoException] en caso de presentarse un fallo interno en Sembast
  /// o un error inesperado durante la transacción.
  Future<List<CategoriaZapato>> buscarPorNombreCategoria(String query) async {
    final regExp = RegExp(RegExp.escape(query), caseSensitive: false);
    try {
      final finder = Finder(
        filter: Filter.matches('nombreCategoria', regExp.pattern),
        sortOrders: [SortOrder('nombreCategoria')],
      );

      final snapshots = await store.find(database, finder: finder);

      return snapshots.map((snapshot) {
        final map = Map<String, dynamic>.from(snapshot.value as Map);
        map['id'] = snapshot.key;

        return fromJson(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw DaoException('Error específico de Sembast en buscarPorNombreCategoria', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error inesperado en buscarPorNombreCategoria', e),
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

    if (params.query.trim().isNotEmpty) {
      final regExp = RegExp(RegExp.escape(params.query.trim()), caseSensitive: false);
      filters.add(Filter.matches('nombreCategoria', regExp.pattern));
    }

    if (params.initialLetter != null && params.initialLetter!.trim().isNotEmpty) {
      final letterRegExp = RegExp('^${RegExp.escape(params.initialLetter!.trim())}', caseSensitive: false);
      filters.add(Filter.matches('nombreCategoria', letterRegExp.pattern));
    }

    if (filters.isEmpty) return null;
    if (filters.length == 1) return filters.first;
    return Filter.and(filters);
  }

  /// Recupera una lista paginada y filtrada de categorías de zapatos.
  ///
  /// Aplica los filtros de búsqueda, letra inicial, ordenamiento (A-Z o Z-A) 
  /// y los límites de paginación solicitados en [params].
  ///
  /// Lanza [DaoException] si ocurre un error en la base de datos local.
  Future<List<CategoriaZapato>> obtenerCategoriasConFiltros(FilterParams params) async {
    try {
      final filter = _buildFilter(params);
      final isAscending = params.sortDirection == SortDirection.asc;

      final finder = Finder(
        filter: filter,
        sortOrders: [SortOrder('nombreCategoria', isAscending)],
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
      throw DaoException('Error de Sembast al obtener categorias filtradas', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error inesperado al obtener categorias filtradas', e),
        stackTrace,
      );
    }
  }

  /// Cuenta el total exacto de categorías que coinciden con los filtros actuales.
  /// 
  /// Este método es súper rápido porque no extrae los datos, solo los cuenta.
  /// Es vital para que el widget de paginación sepa cuántas páginas dibujar.
  Future<int> contarCategoriasConFiltros(FilterParams params) async {
    try {
      final filter = _buildFilter(params);
      return await store.count(database, filter: filter);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error al contar las categorias filtradas', e),
        stackTrace,
      );
    }
  }
}