import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart'; 

class CategoriaZapatoSearchBar extends ConsumerWidget {
  const CategoriaZapatoSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSearchBar(
      hintText: 'Buscar categoría...',
      onChanged: (query) {
        ref.read(categoriaZapatoControllerProvider.notifier).buscarCategorias(query);
      },
    );
  }
}