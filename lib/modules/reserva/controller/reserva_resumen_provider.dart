/// Une reservas con cliente, pares y precios para mostrarlas en las pantallas.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/reserva_detalle/entity/reserva_detalle.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';

/// Un par dentro de una reserva, con su modelo y precio acordado.
class ReservaItem {
  final Inventario? inventario;
  final Zapato? zapato;
  final double precio;

  const ReservaItem({this.inventario, this.zapato, required this.precio});

  String get nombre => zapato?.modelo ?? 'Par sin modelo';
  String get codigo => inventario?.codigo ?? '';
  String get detalle {
    final partes = <String>[
      if ((inventario?.color ?? '').isNotEmpty) inventario!.color!,
      if (inventario != null) 'Talla ${inventario!.talla}',
    ];
    return partes.join(' · ');
  }
}

/// Reserva lista para mostrar: cliente, pares, total, abonado y restante.
class ReservaResumen {
  final Reserva reserva;
  final Cliente? cliente;
  final List<ReservaItem> items;

  const ReservaResumen({
    required this.reserva,
    required this.cliente,
    required this.items,
  });

  String get clienteNombre => cliente == null
      ? 'Cliente general'
      : '${cliente!.nombre} ${cliente!.apellido}';
  String get telefono => cliente?.telefono ?? '';
  double get total => items.fold(0, (sum, i) => sum + i.precio);
  double get abonado => reserva.adelanto;
  double get restante =>
      (total - abonado).clamp(0, double.infinity).toDouble();
  bool get pagada => items.isNotEmpty && restante <= 0;
  bool get pendiente => reserva.estado == ReservaEstado.pendiente;

  /// Pendiente y vence en los próximos 3 días (o ya venció).
  bool get porVencer =>
      pendiente &&
      reserva.fechaVencimiento.difference(DateTime.now()).inDays <= 3;

  String? get imagenPath =>
      items.map((i) => i.zapato?.imagenPath).whereType<String>().firstOrNull;
}

/// Todas las reservas con sus datos relacionados ya resueltos.
final reservasResumenProvider = FutureProvider<List<ReservaResumen>>((
  ref,
) async {
  final reservas = await ref.watch(reservasProvider.future);
  final detalles = await ref.watch(reservaDetallesProvider.future);
  final clientes = await ref.watch(clientesProvider.future);
  final existencias = await ref.watch(existenciasProvider.future);
  final zapatos = await ref.watch(zapatosCatalogoProvider.future);

  final inventarioPorId = {for (final i in existencias) i.id: i};
  final zapatoPorId = {for (final z in zapatos) z.id: z};
  final clientePorId = {for (final c in clientes) c.id: c};
  final detallesPorReserva = <String, List<ReservaDetalle>>{};
  for (final d in detalles) {
    detallesPorReserva.putIfAbsent(d.idReserva, () => []).add(d);
  }

  return reservas.map((r) {
    final items = (detallesPorReserva[r.id] ?? []).map((d) {
      final inv = inventarioPorId[d.idInventario];
      return ReservaItem(
        inventario: inv,
        zapato: inv == null ? null : zapatoPorId[inv.idZapato],
        precio: d.precioAcordado,
      );
    }).toList();
    return ReservaResumen(
      reserva: r,
      cliente: clientePorId[r.idCliente],
      items: items,
    );
  }).toList();
});
