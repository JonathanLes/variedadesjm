/// Presenta el resumen operativo del día usando únicamente datos persistidos.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/gasto/boundary/pages/gasto_page.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/venta/boundary/pages/venta_form_page.dart';
import 'package:variedadesjm/modules/venta/boundary/pages/venta_page.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/ui/section_header.dart';

/// Dashboard principal de Variedades JM: resumen del día seleccionado.
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  DateTime _day = DateTime.now();
  bool _expanded = false;

  void _moveDay(int delta) {
    final next = DateTime(_day.year, _day.month, _day.day + delta);
    if (next.isAfter(DateTime.now())) return;
    setState(() => _day = next);
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dashboardDataProvider);
    final details = ref.watch(ventaDetallesProvider);
    final models = ref.watch(zapatosCatalogoProvider);
    final failed = [data, details, models].where((a) => a.hasError);
    final ready = data.hasValue && details.hasValue && models.hasValue;

    return AppLayout(
      currentIndex: 0,
      child: failed.isNotEmpty
          ? Center(child: Text('No se pudo cargar el resumen: ${failed.first.error}'))
          : !ready
              ? const Center(child: CircularProgressIndicator())
              : _content(context, data.requireValue, details.requireValue, models.requireValue),
    );
  }

  Widget _content(BuildContext context, DashboardData data,
    List<VentaDetalle> details,
    List<Zapato> models,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final stockById = {for (final item in data.existencias) item.id: item};
    final modelById = {for (final model in models) model.id: model};

    final sales = data.ventas.where((v) => sameDay(v.fechaVenta, _day)).toList();
    final saleIds = sales.map((v) => v.id).toSet();
    final lines = details.where((d) => saleIds.contains(d.idVenta)).toList();
    final expenses = data.gastos.where((g) => sameDay(g.fechaGasto, _day)).toList();

    final salesTotal = sales.fold<double>(0, (sum, v) => sum + v.total);
    final cost = lines.fold<double>(
      0,
      (sum, d) => sum + (stockById[d.idInventario]?.precioCompra ?? 0),
    );
    final expensesTotal = expenses.fold<double>(0, (sum, g) => sum + g.monto);
    final operating = salesTotal - cost;
    final net = operating - expensesTotal;

    final pendingToday = data.reservas
        .where((r) => r.estado == ReservaEstado.pendiente && sameDay(r.fechaReserva, _day))
        .length;
    final pending = data.reservas.where((r) => r.estado == ReservaEstado.pendiente);
    final inventoryValue = data.existencias
        .where((i) => i.estado == EstadoZapato.activo)
        .fold<double>(0, (sum, i) => sum + i.precioCompra);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text('Inicio',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: scheme.primary)),
        const Text('Resumen del día'),
        const SizedBox(height: 12),
        _DateSelector(
          day: _day,
          onPrevious: () => _moveDay(-1),
          onNext: sameDay(_day, DateTime.now()) ? null : () => _moveDay(1),
        ),
        const SizedBox(height: 12),
        _NetProfitCard(
          net: net,
          sales: salesTotal,
          expenses: expensesTotal,
          pairs: lines.length,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text('Ver más detalles',
                        style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
                    Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: scheme.primary),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (pendingToday > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pendingToday == 1 ? '1 reserva hoy' : '$pendingToday reservas hoy',
                  style: const TextStyle(
                      color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
        if (_expanded)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _DetailRow('Valor del inventario (a costo)', money(inventoryValue)),
                  _DetailRow('Costo de lo vendido', money(cost)),
                  _DetailRow('Utilidad operativa', money(operating)),
                  _DetailRow('Reservas pendientes', '${pending.length}'),
                  _DetailRow('Abonos recibidos', money(pending.fold<double>(0, (s, r) => s + r.adelanto))),
                ],
              ),
            ),
          ),
        if (sales.isEmpty && expenses.isEmpty)
          _EmptyDay(onSell: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VentaFormPage()),
              ))
        else ...[
          SectionHeader(
            title: 'Ventas del día',
            actionLabel: 'Ver todas',
            onAction: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const VentaPage())),
          ),
          Card(
            child: lines.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Sin ventas en este día.'),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < lines.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        _SaleRow(
                          name: modelById[stockById[lines[i].idInventario]?.idZapato]?.modelo ??
                              'Par vendido',
                          detail: _detail(stockById[lines[i].idInventario]),
                          price: lines[i].precioVentaFinal,
                          profit: lines[i].precioVentaFinal -
                              (stockById[lines[i].idInventario]?.precioCompra ?? 0),
                        ),
                      ],
                    ],
                  ),
          ),
          SectionHeader(
            title: 'Gastos del día',
            actionLabel: 'Ver todos',
            onAction: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const GastoPage())),
          ),
          Card(
            child: expenses.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Sin gastos en este día.'),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < expenses.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.danger.withValues(alpha: .12),
                            foregroundColor: AppColors.danger,
                            child: const Icon(Icons.receipt_long_outlined, size: 16),
                          ),
                          title: Text(expenses[i].descripcion),
                          trailing: Text('-${money(expenses[i].monto)}',
                              style: const TextStyle(
                                  color: AppColors.danger, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ],
    );
  }

  static String _detail(Inventario? item) {
    if (item == null) return '';
    return [if ((item.color ?? '').isNotEmpty) item.color!, 'Talla ${item.talla}'].join(' · ');
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime day;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  const _DateSelector({required this.day, required this.onPrevious, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Día anterior',
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: scheme.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(longDate(day),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Día siguiente',
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _NetProfitCard extends StatelessWidget {
  final double net;
  final double sales;
  final double expenses;
  final int pairs;

  const _NetProfitCard({
    required this.net,
    required this.sales,
    required this.expenses,
    required this.pairs,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget metric(String label, String value) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ganancia neta de hoy',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(money(net),
              style: const TextStyle(
                  color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: [
              metric('Ventas', money(sales)),
              metric('Gastos', money(expenses)),
              metric('Pares vendidos', '$pairs'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class _SaleRow extends StatelessWidget {
  final String name;
  final String detail;
  final double price;
  final double profit;

  const _SaleRow({
    required this.name,
    required this.detail,
    required this.price,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(money(price), style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(
            '${profit >= 0 ? '+' : '-'}${money(profit.abs())}',
            style: TextStyle(
              color: profit >= 0 ? AppColors.success : AppColors.danger,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  final VoidCallback onSell;
  const _EmptyDay({required this.onSell});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: scheme.primary.withValues(alpha: .10),
                foregroundColor: scheme.primary,
                child: const Icon(Icons.inventory_2_outlined, size: 32),
              ),
              const SizedBox(height: 14),
              const Text('Aún no hay movimientos este día',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Cuando registres una venta o un gasto aparecerá aquí.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(190, 44),
                ),
                onPressed: onSell,
                icon: const Icon(Icons.sell_outlined),
                label: const Text('Registrar venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
