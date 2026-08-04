import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';

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
}
