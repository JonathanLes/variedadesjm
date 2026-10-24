/// Lista de reservas con búsqueda, filtros rápidos y barra de abono.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/reserva/boundary/pages/reserva_detail_page.dart';
import 'package:variedadesjm/modules/reserva/controller/reserva_resumen_provider.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';

enum _Filter { activas, porVencer, canceladas }

enum _Sort { fecha, saldo, nombre }

/// Muestra las reservas pendientes y canceladas sin datos de ejemplo.
class ReservaPage extends ConsumerStatefulWidget {
  const ReservaPage({super.key});

  @override
  ConsumerState<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends ConsumerState<ReservaPage> {
  final _search = TextEditingController();
  _Filter _filter = _Filter.activas;
  _Sort _sort = _Sort.fecha;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<ReservaResumen> _apply(List<ReservaResumen> all) {
    final query = _search.text.trim().toLowerCase();
    final list = all.where((r) {
      final inFilter = switch (_filter) {
        _Filter.activas => r.pendiente,
        _Filter.porVencer => r.porVencer,
        _Filter.canceladas => !r.pendiente,
      };
      final inQuery = query.isEmpty ||
          r.clienteNombre.toLowerCase().contains(query) ||
          r.telefono.contains(query);
      return inFilter && inQuery;
    }).toList();
    switch (_sort) {
      case _Sort.fecha:
        list.sort((a, b) => b.reserva.fechaReserva.compareTo(a.reserva.fechaReserva));
      case _Sort.saldo:
        list.sort((a, b) => b.restante.compareTo(a.restante));
      case _Sort.nombre:
        list.sort((a, b) => a.clienteNombre.compareTo(b.clienteNombre));
    }
    return list;
  }

  Future<void> _openSort() async {
    final selected = await showModalBottomSheet<_Sort>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Ordenar por',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ),
            for (final entry in const {
              _Sort.fecha: 'Fecha de reserva (más reciente)',
              _Sort.saldo: 'Saldo restante (mayor primero)',
              _Sort.nombre: 'Nombre del cliente (A-Z)',
            }.entries)
              ListTile(
                leading: Icon(_sort == entry.key
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked),
                title: Text(entry.value),
                onTap: () => Navigator.pop(context, entry.key),
              ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _sort = selected);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reservasResumenProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reservas')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudieron cargar las reservas: $error')),
        data: (all) {
          final list = _apply(all);
          final active = all.where((r) => r.pendiente).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Buscar nombre o teléfono',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Ordenar',
                    onPressed: _openSort,
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text('Activas · $active'),
                    selected: _filter == _Filter.activas,
                    onSelected: (_) => setState(() => _filter = _Filter.activas),
                  ),
                  ChoiceChip(
                    label: const Text('Por vencer'),
                    selected: _filter == _Filter.porVencer,
                    onSelected: (_) => setState(() => _filter = _Filter.porVencer),
                  ),
                  ChoiceChip(
                    label: const Text('Canceladas'),
                    selected: _filter == _Filter.canceladas,
                    onSelected: (_) => setState(() => _filter = _Filter.canceladas),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: Text('No hay reservas que mostrar.')),
                )
              else
                for (final item in list) _ReservaCard(item: item),
            ],
          );
        },
      ),
    );
  }
}

class _ReservaCard extends StatelessWidget {
  final ReservaResumen item;
  const _ReservaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = item.total <= 0 ? 0.0 : (item.abonado / item.total).clamp(0.0, 1.0);
    final image = item.imagenPath;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReservaDetailPage(reservaId: item.reserva.id)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: scheme.primary.withValues(alpha: .08),
                        child: image != null && File(image).existsSync()
                            ? Image.file(File(image), fit: BoxFit.cover)
                            : Icon(Icons.inventory_2_outlined, color: scheme.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.clienteNombre,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                          Text('${item.telefono}  ·  ${shortDate(item.reserva.fechaReserva)}',
                              style: const TextStyle(fontSize: 12)),
                          Text(
                            item.items.map((i) => i.nombre).join(', '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (item.porVencer)
                      const Icon(Icons.schedule_rounded, color: AppColors.danger, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    color: AppColors.warning,
                    backgroundColor: AppColors.warning.withValues(alpha: .18),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Abonado ${money(item.abonado)} de ${money(item.total)}',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Restante', style: TextStyle(fontSize: 11)),
                        Text(money(item.restante),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.warning)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
