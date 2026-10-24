import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

/// Widget encargado de renderizar el listado reactivo de marcas.
class MarcasListView extends ConsumerWidget {
  final void Function(Marca marca) onEdit;
  final void Function(Marca marca) onDelete;

  const MarcasListView({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marcasState = ref.watch(marcaControllerProvider);
    // Cuántos modelos tiene cada marca (si aún no carga, se muestra 0).
    final modelos = ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [];

    return marcasState.when(
      data: (estado) {
        final marcas = estado.marcas;
        if (marcas.isEmpty) {
          return const AdminMessage('No se encontraron marcas', icon: Icons.sell_outlined);
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: marcas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final marca = marcas[index];
            final total = modelos.where((m) => m.idMarca == marca.id).length;
            return AdminItemCard(
              leading: AdminAvatar(
                text: marca.nombreMarca.isNotEmpty ? marca.nombreMarca[0].toUpperCase() : '?',
              ),
              title: marca.nombreMarca,
              details: [
                AdminDetail(
                  total == 1 ? '1 modelo registrado' : '$total modelos registrados',
                  icon: Icons.inventory_2_outlined,
                ),
              ],
              onEdit: () => onEdit(marca),
              onDelete: () => onDelete(marca),
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 44),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AdminMessage(
        'Error al cargar las marcas: $error',
        icon: Icons.error_outline,
        isError: true,
      ),
    );
  }
}
