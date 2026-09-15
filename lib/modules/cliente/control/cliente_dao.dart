import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

import 'package:variedadesjm/modules/cliente/entity/cliente.dart';

class ClienteDAO extends SembastDao<Cliente> {
  ClienteDAO(Database database) : super(database, SembastStores.cliente); 

  @override
  Cliente fromJson(Map<String, dynamic> json) {
    return Cliente.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Cliente item) {
    return item.toJson();
  }

  /// Construye dinámicamente los filtros de Sembast para Clientes.
  Filter? _buildFilter(FilterParams params) {
    final List<Filter> filters = [];

    if (params.query.trim().isNotEmpty) {
      final regExp = RegExp(RegExp.escape(params.query.trim()), caseSensitive: false);
      // Busca coincidencias en nombre, apellido o teléfono
      filters.add(Filter.or([
        Filter.matches('nombre', regExp.pattern),
        Filter.matches('apellido', regExp.pattern),
        Filter.matches('telefono', regExp.pattern),
      ]));
    }

    if (params.initialLetter != null && params.initialLetter!.trim().isNotEmpty) {
      final letterRegExp = RegExp('^${RegExp.escape(params.initialLetter!.trim())}', caseSensitive: false);
      filters.add(Filter.matches('nombre', letterRegExp.pattern));
    }

    if (filters.isEmpty) return null;
    if (filters.length == 1) return filters.first;
    return Filter.and(filters);
  }

  Future<List<Cliente>> obtenerClientesConFiltros(FilterParams params) async {
    try {
      final filter = _buildFilter(params);
      final isAscending = params.sortDirection == SortDirection.asc;

      final finder = Finder(
        filter: filter,
        sortOrders: [
          SortOrder('nombre', isAscending),
          SortOrder('apellido', isAscending) // Orden secundario
        ],
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
      throw DaoException('Error de Sembast al obtener clientes filtrados', e);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error inesperado al obtener clientes filtrados', e),
        stackTrace,
      );
    }
  }

  Future<int> contarClientesConFiltros(FilterParams params) async {
    try {
      final filter = _buildFilter(params);
      return await store.count(database, filter: filter);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        DaoException('Error al contar los clientes filtrados', e),
        stackTrace,
      );
    }
  }
}