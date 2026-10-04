import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
// Se asume la ruta correcta de tu AppSearchBar
// import 'package:variedadesjm/shared/widgets/app_search_bar.dart'; 

import '../../controller/inventario_controller.dart';
import '../../../zapato/controller/zapato_controller.dart';

class InventarioFilterModal extends ConsumerStatefulWidget {
  const InventarioFilterModal({super.key});

  /// Muestra el modal de filtros deslizable desde la parte inferior de la pantalla.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const InventarioFilterModal(),
    );
  }

  @override
  ConsumerState<InventarioFilterModal> createState() => _InventarioFilterModalState();
}

class _InventarioFilterModalState extends ConsumerState<InventarioFilterModal> {
  final _queryController = TextEditingController();
  final _scrollController = ScrollController();
  final _queryFocusNode = FocusNode();
  String? _idZapato;

  @override
  void initState() {
    super.initState();
    _queryFocusNode.addListener(_handleQueryFocus);
  }

  void _handleQueryFocus() {
    if (!_queryFocusNode.hasFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _queryFocusNode.removeListener(_handleQueryFocus);
    _queryController.dispose();
    _scrollController.dispose();
    _queryFocusNode.dispose();
    super.dispose();
  }

  /// Limpia los filtros activos y cierra el modal.
  Future<void> _limpiarFiltros(BuildContext context) async {
    await ref.read(inventarioControllerProvider.notifier).aplicarFiltrosEspeciales();
    await ref.read(inventarioControllerProvider.notifier).buscarInventario('');
    if (context.mounted) Navigator.pop(context);
  }

  /// Aplica la búsqueda escrita y cierra el modal cuando termina de recargar la lista.
  Future<void> _aplicarFiltros(BuildContext context) async {
    await ref.read(inventarioControllerProvider.notifier).aplicarFiltrosEspeciales(
      idZapato: _idZapato,
    );
    await ref.read(inventarioControllerProvider.notifier).buscarInventario(_queryController.text);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final modelos = ref.watch(zapatosCatalogoProvider);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final availableHeight =
        MediaQuery.sizeOf(context).height - viewInsets.bottom - AppSpacing.md;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: availableHeight.clamp(0.0, double.infinity),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtros avanzados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Búsqueda general', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _queryController,
            focusNode: _queryFocusNode,
            textCapitalization: TextCapitalization.characters,
            scrollPadding: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Buscar por código o color...',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Modelo de zapato', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          modelos.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('No se pudieron cargar los modelos: $error'),
            data: (items) => DropdownButtonFormField<String>(
              initialValue: _idZapato,
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: items
                  .map((zapato) => DropdownMenuItem<String>(
                        value: zapato.id,
                        child: Text(zapato.modelo),
                      ))
                  .toList(),
              onChanged: items.isEmpty ? null : (val) => setState(() => _idZapato = val),
              hint: const Text('Todos los modelos'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _limpiarFiltros(context),
                  child: const Text('Limpiar', style: TextStyle(color: AppColors.graphite)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _aplicarFiltros(context),
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: const Text('Aplicar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.racingRed,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}