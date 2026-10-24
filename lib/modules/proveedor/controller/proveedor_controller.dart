/// Lectura y escritura de proveedores sobre el store Sembast existente.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/proveedor/entity/proveedor.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/data/app_record_writer.dart';

/// Lista de proveedores ordenada por nombre.
final proveedoresProvider = FutureProvider<List<Proveedor>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  final lista = await readEntities<Proveedor>(
    database: database,
    storeName: SembastStores.proveedor,
    fromJson: Proveedor.fromJson,
  );
  lista.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
  return lista;
});

/// Operaciones de guardado y borrado; refresca la lista al terminar.
class ProveedorActions {
  final Ref _ref;

  ProveedorActions(this._ref);

  Future<void> guardar(Proveedor proveedor) async {
    final database = await _ref.read(sembastDatabaseProvider.future);
    final json = proveedor.toJson();
    await writeRecord(
      database: database,
      storeName: SembastStores.proveedor,
      id: proveedor.id,
      value: json,
    );
    _ref.invalidate(proveedoresProvider);
  }

  Future<void> eliminar(String id) async {
    final database = await _ref.read(sembastDatabaseProvider.future);
    await deleteRecord(
      database: database,
      storeName: SembastStores.proveedor,
      id: id,
    );
    _ref.invalidate(proveedoresProvider);
  }
}

final proveedorActionsProvider = Provider<ProveedorActions>(ProveedorActions.new);
