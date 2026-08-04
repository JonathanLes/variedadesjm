import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart';

/// Formulario modal para la creación y edición de marcas.
class MarcaFormBottomSheet extends ConsumerStatefulWidget {
  final Marca? marcaAEditar;

  const MarcaFormBottomSheet({
    super.key,
    this.marcaAEditar,
  });

  @override
  ConsumerState<MarcaFormBottomSheet> createState() => _MarcaFormBottomSheetState();
}

class _MarcaFormBottomSheetState extends ConsumerState<MarcaFormBottomSheet> {
  late final TextEditingController _nombreController;
  bool _isSubmitting = false;

  bool get _isEditing => widget.marcaAEditar != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.marcaAEditar?.nombreMarca ?? '',
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
      final controller = ref.read(marcaControllerProvider.notifier);

      if (_isEditing) {
        await controller.actualizarMarca(
          widget.marcaAEditar!.id,
          _nombreController.text,
        );
      } else {
        // Generamos un ID único temporal o definitivo (ej. usando timestamp)
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        await controller.crearMarca(id, _nombreController.text);
      }

      if (mounted) {
        Navigator.of(context).pop(); // Cerramos el modal tras guardar exitosamente
      }
    } on BrandNameRequeridedExpection catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on BrandNameTooShortExpection catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on BrandNameTooLongExpection catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on BrandAlreadyExistsExpection catch (e) {
      _mostrarSnackBar(e.mensaje);
    } on BrandNotFoundExpection catch (e) {
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
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inset para elevar la ventana cuando el teclado virtual aparece
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
            // Tirador central (drag handle)
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título y Subtítulo
            Text(
              _isEditing ? 'Actualizar marca' : 'Nueva marca',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isEditing
                  ? 'Modifica los datos de la marca'
                  : 'Ingresa los datos de la nueva marca',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Campo: Nombre de la marca
            RichText(
              text: const TextSpan(
                text: 'Nombre de la marca ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                hintText: 'Ej. NIKE',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'El nombre se guardará en mayúsculas automáticamente.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Caja Informativa: Reglas del nombre
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF2F2), // Fondo rosado claro
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF8D7DA)),
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
                      children: const [
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
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botones de Acción (Cancelar / Guardar)
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
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        backgroundColor: const Color(0xFFB71C1C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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