import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/cliente/controller/cliente_controller.dart';
import 'package:variedadesjm/modules/cliente/boundary/widgets/cliente_card.dart';
import 'package:variedadesjm/modules/cliente/boundary/widgets/nuevo_cliente_button.dart';
import 'package:variedadesjm/modules/cliente/boundary/pages/cliente_form_bottom_sheet.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_sort_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Página principal del módulo de clientes.
class ClientePage extends ConsumerWidget {
  const ClientePage({super.key});

  /// Abre el formulario modal para editar el cliente seleccionado
  void _onEditCliente(BuildContext context, Cliente cliente) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClienteFormBottomSheet(clienteAEditar: cliente),
    );
  }

  /// Muestra diálogo de confirmación previo a eliminar
  void _onDeleteCliente(BuildContext context, WidgetRef ref, Cliente cliente) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Eliminar cliente?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar a "${cliente.nombre} ${cliente.apellido}"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref
                    .read(clienteControllerProvider.notifier)
                    .eliminarCliente(cliente.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Cliente "${cliente.nombre}" eliminado correctamente',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar cliente: $e'),
                      backgroundColor: AppColors.brand,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clienteStateAsync = ref.watch(clienteControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clientes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Gestiona la información de tus clientes',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.graphite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Búsqueda
              AppSearchBar(
                hintText: 'Buscar por nombre, apellido o teléfono...',
                onChanged: (query) => ref
                    .read(clienteControllerProvider.notifier)
                    .buscarClientes(query),
              ),
              const SizedBox(height: 16),

              // 3. Fila Botón Nuevo y Ordenamiento
              clienteStateAsync.maybeWhen(
                data: (estado) => Row(
                  children: [
                    const Expanded(child: NuevoClienteButton()),
                    const SizedBox(width: 12),
                    AppSortFilter(
                      currentSort: estado.filtros.sortDirection,
                      onSortChanged: (sort) {
                        ref
                            .read(clienteControllerProvider.notifier)
                            .cambiarOrden(sort);
                      },
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => const SizedBox.shrink(),
                orElse: () => const NuevoClienteButton(),
              ),

              const SizedBox(height: 20),

              // 4. Lista con Tarjetas
              clienteStateAsync.when(
                data: (estado) {
                  if (estado.clientes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          'No se encontraron clientes registrados.',
                          style: TextStyle(
                            color: AppColors.graphite,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: estado.clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = estado.clientes[index];
                      final isEven = index % 2 == 0;
                      return ClienteCard(
                        cliente: cliente,
                        avatarColor: isEven
                            ? AppColors.brand
                            : AppColors.black,
                        onEdit: () => _onEditCliente(context, cliente),
                        onDelete: () => _onDeleteCliente(context, ref, cliente),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: AppColors.brand,
                    ),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error al obtener clientes: $error',
                      style: const TextStyle(color: AppColors.brand),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 5. Paginación
              clienteStateAsync.maybeWhen(
                data: (estado) => Center(
                  child: AppPagination(
                    currentPage: estado.filtros.page,
                    totalItems: estado.totalItems,
                    pageSize: estado.filtros.pageSize,
                    itemName: 'clientes',
                    onPageChanged: (nuevaPagina) {
                      ref
                          .read(clienteControllerProvider.notifier)
                          .cambiarPagina(nuevaPagina);
                    },
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
