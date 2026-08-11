import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart'; 

class MarcaSearchBar extends ConsumerWidget {
  const MarcaSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSearchBar(
      hintText: 'Buscar marca...',
      onChanged: (query) {
        // Delegamos la búsqueda al controlador de Riverpod
        ref.read(marcaControllerProvider.notifier).buscarMarcas(query);
      },
    );
  }
}