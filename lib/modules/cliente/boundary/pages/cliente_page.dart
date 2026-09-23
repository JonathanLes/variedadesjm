import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/cliente/controller/cliente_controller.dart';
import 'package:variedadesjm/modules/cliente/boundary/widgets/cliente_card.dart';
import 'package:variedadesjm/modules/cliente/boundary/widgets/nuevo_cliente_button.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_sort_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Vista exclusiva del contenido de Clientes (sin header global ni filtro alfabético).
class ClientePage extends ConsumerWidget {
  const ClientePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clienteState = ref.watch(clienteControllerProvider);
    final controller = ref.read(clienteControllerProvider.notifier);

    return clienteState.when(
      data: (estado) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y Subtítulo del módulo
              const Text(
                'Clientes',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Gestiona la información de tus clientes',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.graphite,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Barra de búsqueda con Debounce
              AppSearchBar(
                hintText: 'Buscar por nombre, apellido o teléfono...',
                onChanged: (query) => controller.buscarClientes(query),
              ),
              const SizedBox(height: AppSpacing.md),

              // Control de Ordenamiento
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppSortFilter(
                    currentSort: estado.filtros.sortDirection,
                    onSortChanged: (sort) => controller.cambiarOrden(sort),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Botón "+ Nuevo cliente" (Abre modal)
              const NuevoClienteButton(),
              const SizedBox(height: AppSpacing.md),

              // Lista dinámica de Clientes
              if (estado.clientes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text(
                      'No se encontraron clientes registrados.',
                      style: TextStyle(color: AppColors.graphite, fontSize: 15),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: estado.clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = estado.clientes[index];
                    final isEven = index % 2 == 0;
                    return ClienteCard(
                      cliente: cliente,
                      avatarColor: isEven ? AppColors.racingRed : AppColors.black,
                      onTap: () {
                        // TODO: Implementar vista de detalle/edición si aplica
                      },
                    );
                  },
                ),
              const SizedBox(height: AppSpacing.md),

              // Controles de Paginación
              AppPagination(
                currentPage: estado.filtros.page,
                totalItems: estado.totalItems,
                pageSize: estado.filtros.pageSize,
                itemName: 'clientes',
                onPageChanged: (nuevaPagina) => controller.cambiarPagina(nuevaPagina),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: AppColors.racingRed),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error al obtener clientes: $error',
            style: const TextStyle(color: AppColors.racingRed),
          ),
        ),
      ),
    );
  }
}