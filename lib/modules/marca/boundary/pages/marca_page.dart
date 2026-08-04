import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart';

// Importación de tus widgets individuales
import 'package:variedadesjm/modules/marca/boundary/widgets/marca_header.dart';
import 'package:variedadesjm/modules/marca/boundary/widgets/marca_search_bar.dart';
import 'package:variedadesjm/modules/marca/boundary/widgets/nueva_marca_button.dart';
import 'package:variedadesjm/modules/marca/boundary/widgets/marca_list_view.dart';
import 'package:variedadesjm/modules/marca/boundary/pages/marca_form_bottom_sheet.dart';

/// Página principal del módulo de gestión de marcas.
class MarcaPage extends ConsumerWidget {
  const MarcaPage({super.key});

  /// Abre el formulario modal reutilizable pre-cargado con la marca a editar
  void _onEditMarca(BuildContext context, Marca marca) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MarcaFormBottomSheet(marcaAEditar: marca),
    );
  }

  /// Muestra un diálogo de confirmación antes de eliminar la marca
  void _onDeleteMarca(BuildContext context, WidgetRef ref, Marca marca) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '¿Eliminar marca?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar la marca "${marca.nombreMarca}"?',
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
              backgroundColor: const Color(0xFFB71C1C),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Cierra el diálogo
              _ejecutarEliminacion(context, ref, marca);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Llama al controller para eliminar la marca y gestiona las excepciones de negocio
  Future<void> _ejecutarEliminacion(
    BuildContext context,
    WidgetRef ref,
    Marca marca,
  ) async {
    try {
      await ref.read(marcaControllerProvider.notifier).eliminarMarca(marca.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Marca "${marca.nombreMarca}" eliminada correctamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on BrandInUseExpection catch (e) {
      _mostrarSnackBarError(context, e.mensaje);
    } on BrandNotFoundExpection catch (e) {
      _mostrarSnackBarError(context, e.mensaje);
    } catch (e) {
      _mostrarSnackBarError(
        context,
        'Ocurrió un error inesperado al eliminar la marca.',
      );
    }
  }

  void _mostrarSnackBarError(BuildContext context, String mensaje) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MarcaHeader(),
              const SizedBox(height: 16),
              const MarcaSearchBar(),
              const SizedBox(height: 16),
              const NuevaMarcaButton(),
              const SizedBox(height: 20),
              MarcasListView(
                onEdit: (marca) => _onEditMarca(context, marca),
                onDelete: (marca) => _onDeleteMarca(context, ref, marca),
              ),
            ],
          ),
        ),
      ),
    );
  }
}