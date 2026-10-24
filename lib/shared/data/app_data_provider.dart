/// Expone lecturas tipadas de los stores Sembast usados por el panel.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/modules/reserva_detalle/entity/reserva_detalle.dart';

/// Lee entidades serializadas de un store y conserva la clave como `id`.
Future<List<T>> readEntities<T>({
  required Database database,
  required String storeName,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  final store = stringMapStoreFactory.store(storeName);
  final snapshots = await store.find(
    database,
    finder: Finder(sortOrders: [SortOrder(Field.key, false)]),
  );
  return snapshots.map((snapshot) {
    final json = Map<String, dynamic>.from(snapshot.value);
    json['id'] = snapshot.key;
    return fromJson(json);
  }).toList();
}

/// Provee ventas reales almacenadas localmente.
final ventasProvider = FutureProvider<List<Venta>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.venta,
    fromJson: Venta.fromJson,
  );
});

/// Provee gastos reales almacenados localmente.
final gastosProvider = FutureProvider<List<Gasto>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.gasto,
    fromJson: Gasto.fromJson,
  );
});

/// Provee reservas reales almacenadas localmente.
final reservasProvider = FutureProvider<List<Reserva>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.reserva,
    fromJson: Reserva.fromJson,
  );
});

/// Provee existencias reales para construir métricas y reportes.
final existenciasProvider = FutureProvider<List<Inventario>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.inventario,
    fromJson: Inventario.fromJson,
  );
});

/// Provee clientes para los formularios que requieren asociar una operación.
final clientesProvider = FutureProvider<List<Cliente>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.cliente,
    fromJson: Cliente.fromJson,
  );
});

/// Provee detalles de venta para mostrar pares asociados y mantener consistencia.
final ventaDetallesProvider = FutureProvider<List<VentaDetalle>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.ventaDetalle,
    fromJson: VentaDetalle.fromJson,
  );
});

/// Provee detalles de reserva para mostrar pares asociados.
final reservaDetallesProvider = FutureProvider<List<ReservaDetalle>>((ref) async {
  final database = await ref.watch(sembastDatabaseProvider.future);
  return readEntities(
    database: database,
    storeName: SembastStores.reservaDetalle,
    fromJson: ReservaDetalle.fromJson,
  );
});

/// Agrupa las colecciones necesarias para renderizar el resumen de inicio.
class DashboardData {
  final List<Venta> ventas;
  final List<Gasto> gastos;
  final List<Reserva> reservas;
  final List<Inventario> existencias;

  const DashboardData({
    required this.ventas,
    required this.gastos,
    required this.reservas,
    required this.existencias,
  });
}

/// Carga una instantánea coherente de todos los indicadores del dashboard.
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final values = await Future.wait([
    ref.watch(ventasProvider.future),
    ref.watch(gastosProvider.future),
    ref.watch(reservasProvider.future),
    ref.watch(existenciasProvider.future),
  ]);
  return DashboardData(
    ventas: values[0] as List<Venta>,
    gastos: values[1] as List<Gasto>,
    reservas: values[2] as List<Reserva>,
    existencias: values[3] as List<Inventario>,
  );
});
