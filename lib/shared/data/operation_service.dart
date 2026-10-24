/// Coordina ventas y reservas con sus detalles y el estado del inventario.
import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/reserva_detalle/entity/reserva_detalle.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';

/// Error de dominio para evitar reservar o vender existencias no disponibles.
class InventoryUnavailableException implements Exception {
  final String message;
  const InventoryUnavailableException(this.message);

  @override
  String toString() => message;
}

/// Ejecuta operaciones compuestas manteniendo consistentes los stores relacionados.
class OperationService {
  final Database database;
  final StoreRef<String, Map<String, dynamic>> _inventory =
      stringMapStoreFactory.store(SembastStores.inventario);
  final StoreRef<String, Map<String, dynamic>> _sales = stringMapStoreFactory
      .store(SembastStores.venta);
  final StoreRef<String, Map<String, dynamic>> _saleDetails =
      stringMapStoreFactory.store(SembastStores.ventaDetalle);
  final StoreRef<String, Map<String, dynamic>> _reservations =
      stringMapStoreFactory.store(SembastStores.reserva);
  final StoreRef<String, Map<String, dynamic>> _reservationDetails =
      stringMapStoreFactory.store(SembastStores.reservaDetalle);

  OperationService(this.database);

  /// Guarda una venta, su detalle y marca los pares como vendidos.
  Future<void> createSale({
    required Venta sale,
    required List<VentaDetalle> details,
  }) async {
    if (details.isEmpty) {
      throw const InventoryUnavailableException('Selecciona al menos un par.');
    }
    await database.transaction((transaction) async {
      for (final detail in details) {
        final snapshot = await _inventory
            .record(detail.idInventario)
            .getSnapshot(transaction);
        if (snapshot == null) {
          throw const InventoryUnavailableException(
            'El par seleccionado ya no existe.',
          );
        }
        final item = Inventario.fromJson({
          ...snapshot.value,
          'id': snapshot.key,
        });
        if (item.estado != EstadoZapato.activo) {
          throw const InventoryUnavailableException(
            'Uno de los pares ya no está disponible.',
          );
        }
        await _inventory
            .record(item.id)
            .put(
              transaction,
              item.copyWith(estado: EstadoZapato.vendido).toMap(),
            );
      }
      await _sales.record(sale.id).put(transaction, sale.toMap());
      for (final detail in details) {
        await _saleDetails.record(detail.id).put(transaction, detail.toMap());
      }
    });
  }

  /// Guarda una reserva, su detalle y marca los pares como reservados.
  Future<void> createReservation({
    required Reserva reservation,
    required List<ReservaDetalle> details,
  }) async {
    if (details.isEmpty) {
      throw const InventoryUnavailableException('Selecciona al menos un par.');
    }
    await database.transaction((transaction) async {
      for (final detail in details) {
        final snapshot = await _inventory
            .record(detail.idInventario)
            .getSnapshot(transaction);
        if (snapshot == null) {
          throw const InventoryUnavailableException(
            'El par seleccionado ya no existe.',
          );
        }
        final item = Inventario.fromJson({
          ...snapshot.value,
          'id': snapshot.key,
        });
        if (item.estado != EstadoZapato.activo) {
          throw const InventoryUnavailableException(
            'Uno de los pares ya no está disponible.',
          );
        }
        await _inventory
            .record(item.id)
            .put(
              transaction,
              item.copyWith(estado: EstadoZapato.reservado).toMap(),
            );
      }
      await _reservations
          .record(reservation.id)
          .put(transaction, reservation.toMap());
      for (final detail in details) {
        await _reservationDetails
            .record(detail.id)
            .put(transaction, detail.toMap());
      }
    });
  }

  /// Elimina una venta y devuelve sus pares al inventario activo.
  Future<void> deleteSale(String saleId) => _deleteOperation(
    operationId: saleId,
    operationStore: _sales,
    detailStore: _saleDetails,
    detailOperationField: 'idVenta',
    expectedState: EstadoZapato.vendido,
  );

  /// Elimina una reserva y devuelve sus pares al inventario activo.
  Future<void> deleteReservation(String reservationId) => _deleteOperation(
    operationId: reservationId,
    operationStore: _reservations,
    detailStore: _reservationDetails,
    detailOperationField: 'idReserva',
    expectedState: EstadoZapato.reservado,
  );

  /// Cancela una reserva y libera sus pares sin eliminar el historial.
  Future<void> cancelReservation(String reservationId) async {
    await database.transaction((transaction) async {
      final snapshot = await _reservations
          .record(reservationId)
          .getSnapshot(transaction);
      if (snapshot == null) return;
      final reservation = Reserva.fromJson({
        ...snapshot.value,
        'id': snapshot.key,
      });
      if (reservation.estado == ReservaEstado.cancelado) return;
      final details = await _reservationDetails.find(
        transaction,
        finder: Finder(filter: Filter.equals('idReserva', reservationId)),
      );
      for (final detailSnapshot in details) {
        final detail = Map<String, dynamic>.from(detailSnapshot.value);
        final inventorySnapshot = await _inventory
            .record(detail['idInventario'] as String)
            .getSnapshot(transaction);
        if (inventorySnapshot != null) {
          final item = Inventario.fromJson({
            ...inventorySnapshot.value,
            'id': inventorySnapshot.key,
          });
          if (item.estado == EstadoZapato.reservado) {
            await _inventory
                .record(item.id)
                .put(
                  transaction,
                  item.copyWith(estado: EstadoZapato.activo).toMap(),
                );
          }
        }
      }
      await _reservations
          .record(reservationId)
          .put(
            transaction,
            reservation.copyWith(estado: ReservaEstado.cancelado).toMap(),
          );
    });
  }

  /// Suma un abono a una reserva pendiente sin superar el precio acordado.
  Future<void> addReservationPayment(String reservationId, double amount) async {
    await database.transaction((transaction) async {
      final snapshot = await _reservations
          .record(reservationId)
          .getSnapshot(transaction);
      if (snapshot == null) return;
      final reservation = Reserva.fromJson({
        ...snapshot.value,
        'id': snapshot.key,
      });
      final details = await _reservationDetails.find(
        transaction,
        finder: Finder(filter: Filter.equals('idReserva', reservationId)),
      );
      final total = details.fold<double>(
        0,
        (sum, d) => sum + ((d.value['precioAcordado'] as num?)?.toDouble() ?? 0),
      );
      final updated = reservation.adelanto + amount;
      await _reservations
          .record(reservationId)
          .put(
            transaction,
            reservation
                .copyWith(adelanto: total > 0 && updated > total ? total : updated)
                .toMap(),
          );
    });
  }

  /// Convierte una reserva en venta: marca los pares como vendidos, crea la
  /// venta con sus detalles y elimina la reserva.
  Future<void> completeReservation(String reservationId) async {
    await database.transaction((transaction) async {
      final snapshot = await _reservations
          .record(reservationId)
          .getSnapshot(transaction);
      if (snapshot == null) return;
      final reservation = Reserva.fromJson({
        ...snapshot.value,
        'id': snapshot.key,
      });
      final details = await _reservationDetails.find(
        transaction,
        finder: Finder(filter: Filter.equals('idReserva', reservationId)),
      );
      if (details.isEmpty) {
        throw const InventoryUnavailableException('La reserva no tiene pares.');
      }
      final saleId = DateTime.now().microsecondsSinceEpoch.toString();
      var total = 0.0;
      for (final detailSnapshot in details) {
        final detail = ReservaDetalle.fromJson({
          ...detailSnapshot.value,
          'id': detailSnapshot.key,
        });
        total += detail.precioAcordado;
        final inventorySnapshot = await _inventory
            .record(detail.idInventario)
            .getSnapshot(transaction);
        if (inventorySnapshot != null) {
          final item = Inventario.fromJson({
            ...inventorySnapshot.value,
            'id': inventorySnapshot.key,
          });
          await _inventory
              .record(item.id)
              .put(
                transaction,
                item.copyWith(estado: EstadoZapato.vendido).toMap(),
              );
        }
        final saleDetail = VentaDetalle(
          id: '$saleId-${detail.idInventario}',
          idVenta: saleId,
          idInventario: detail.idInventario,
          precioVentaFinal: detail.precioAcordado,
        );
        await _saleDetails.record(saleDetail.id).put(transaction, saleDetail.toMap());
        await _reservationDetails.record(detailSnapshot.key).delete(transaction);
      }
      final sale = Venta(
        id: saleId,
        idCliente: reservation.idCliente,
        fechaVenta: DateTime.now(),
        metodoPago: 'Efectivo',
        total: total,
      );
      await _sales.record(sale.id).put(transaction, sale.toMap());
      await _reservations.record(reservationId).delete(transaction);
    });
  }

  Future<void> _deleteOperation({
    required String operationId,
    required StoreRef<String, Map<String, dynamic>> operationStore,
    required StoreRef<String, Map<String, dynamic>> detailStore,
    required String detailOperationField,
    required EstadoZapato expectedState,
  }) async {
    await database.transaction((transaction) async {
      final details = await detailStore.find(
        transaction,
        finder: Finder(
          filter: Filter.equals(detailOperationField, operationId),
        ),
      );
      for (final snapshot in details) {
        final detail = Map<String, dynamic>.from(snapshot.value);
        final inventoryId = detail['idInventario'] as String;
        final itemSnapshot = await _inventory
            .record(inventoryId)
            .getSnapshot(transaction);
        if (itemSnapshot != null) {
          final item = Inventario.fromJson({
            ...itemSnapshot.value,
            'id': itemSnapshot.key,
          });
          if (item.estado == expectedState) {
            await _inventory
                .record(item.id)
                .put(
                  transaction,
                  item.copyWith(estado: EstadoZapato.activo).toMap(),
                );
          }
        }
        await detailStore.record(snapshot.key).delete(transaction);
      }
      await operationStore.record(operationId).delete(transaction);
    });
  }
}
