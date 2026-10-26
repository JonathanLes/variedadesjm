import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/categoria_zapato/service/categoria_zapato_service.dart';

/// Formulario modal para la creación y edición de categorías de zapatos.
class CategoriaZapatoFormBottomSheet extends ConsumerStatefulWidget {
  final CategoriaZapato? categoriaAEditar;

  const CategoriaZapatoFormBottomSheet({
    super.key,
    this.categoriaAEditar,
  });

  @override
  ConsumerState<CategoriaZapatoFormBottomSheet> createState() =>
      _CategoriaZapatoFormBottomSheetState();
}

class _CategoriaZapatoFormBottomSheetState
    extends ConsumerState<CategoriaZapatoFormBottomSheet> {
  late final TextEditingController _nombreController;
  bool _isSubmitting = false;

  bool get _isEditing => widget.categoriaAEditar != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.categoriaAEditar?.nombreCategoria ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _isSubmitting = true);

    try {
      final controller = ref.read(categoriaZapatoControllerProvider.notifier);

      if (_isEditing) {
        await controller.actualizarCategoria(
          widget.categoriaAEditar!.id,
          _nombreController.text,
        );
      } else {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        await controller.crearCategoria(id, _nombreController.text);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on CategoryNameRequiredException catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on CategoryNameTooShortException catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on CategoryNameTooLongException catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on CategoryAlreadyExistsException catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on CategoryNotFoundException catch (e) {
      _mostrarSnackBar(e.mensaje);
    } catch (e) {
      _mostrarSnackBar('Ocurrió un error inesperado. Intenta nuevamente.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _mostrarSnackBar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: context.line,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isEditing ? 'Actualizar categoría' : 'Nueva categoría',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: context.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isEditing
                  ? 'Modifica los datos de la categoría'
                  : 'Ingresa los datos de la nueva categoría',
              style: TextStyle(
                fontSize: 14,
                color: context.muted,
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Nombre de la categoría ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.ink,
                ),
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: AppColors.danger),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                hintText: 'Ej. ZAPATOS_DE_VESTIR',
                hintStyle: TextStyle(color: context.muted),
                filled: true,
                fillColor: context.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.line),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'El nombre se guardará en mayúsculas y sin espacios.',
              style: TextStyle(
                fontSize: 12,
                color: context.muted,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.tint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.line),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info,
                    color: Color(0xFFB71C1C),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reglas del nombre',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB71C1C),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Obligatorio\n'
                          '• Mínimo 2 caracteres\n'
                          '• Máximo 50 caracteres\n'
                          '• No se permiten nombres duplicados',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: context.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.tint,
                        foregroundColor: context.ink,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save, size: 20),
                      label: Text(
                        _isEditing ? 'Actualizar' : 'Guardar',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}