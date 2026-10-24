import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/cliente/controller/cliente_controller.dart';
import 'package:variedadesjm/modules/cliente/boundary/widgets/cliente_card.dart';
import 'package:variedadesjm/modules/cliente/boundary/pages/cliente_form_bottom_sheet.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_sort_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

/// Página principal del módulo de clientes.
class ClientePage extends ConsumerWidget {
  const ClientePage({super.key});

  /// Abre el formulario modal para crear un cliente (o editar si se pasa uno).
  void _openForm(BuildContext context, [Cliente? cliente]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClienteFormBottomSheet(clienteAEditar: cliente),
    );
  }

  /// Pide confirmación y elimina el cliente.
  Future<void> _onDeleteCliente(BuildContext context, WidgetRef ref, Cliente cliente) async {
    final ok = await confirmDelete(
      context,
      title: '¿Eliminar cliente?',
      message: '¿Estás seguro de que deseas eliminar a "${cliente.nombre} ${cliente.apellido}"?',
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(clienteControllerProvider.notifier).eliminarCliente(cliente.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cliente "${cliente.nombre}" eliminado correctamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar cliente: $e'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clienteStateAsync = ref.watch(clienteControllerProvider);
    final notifier = ref.read(clienteControllerProvider.notifier);

    return AdminPage(
      title: 'Clientes',
      subtitle: 'Gestiona la información de tus clientes',
      addLabel: 'Nuevo cliente',
      onAdd: () => _openForm(context),
      children: [
        Row(
          children: [
            Expanded(
              child: AppSearchBar(
                hintText: 'Buscar por nombre o teléfono',
                onChanged: notifier.buscarClientes,
              ),
            ),
            clienteStateAsync.maybeWhen(
              data: (estado) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AppSortFilter(
                  currentSort: estado.filtros.sortDirection,
                  onSortChanged: notifier.cambiarOrden,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        clienteStateAsync.when(
          data: (estado) {
            if (estado.clientes.isEmpty) {
              return const AdminMessage(
                'No se encontraron clientes registrados.',
                icon: Icons.people_outline,
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: estado.clientes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final cliente = estado.clientes[index];
                return ClienteCard(
                  cliente: cliente,
                  onEdit: () => _openForm(context, cliente),
                  onDelete: () => _onDeleteCliente(context, ref, cliente),
                );
              },
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 44),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => AdminMessage(
            'Error al obtener clientes: $error',
            icon: Icons.error_outline,
            isError: true,
          ),
        ),
        const SizedBox(height: 16),
        clienteStateAsync.maybeWhen(
          data: (estado) => Center(
            child: AppPagination(
              currentPage: estado.filtros.page,
              totalItems: estado.totalItems,
              pageSize: estado.filtros.pageSize,
              itemName: 'clientes',
              onPageChanged: notifier.cambiarPagina,
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
