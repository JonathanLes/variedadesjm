import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/cliente/controller/cliente_controller.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Formulario modal desplegable para registrar o editar un cliente.
class ClienteFormBottomSheet extends ConsumerStatefulWidget {
  final Cliente? clienteAEditar;

  const ClienteFormBottomSheet({
    super.key,
    this.clienteAEditar,
  });

  @override
  ConsumerState<ClienteFormBottomSheet> createState() => _ClienteFormBottomSheetState();
}

class _ClienteFormBottomSheetState extends ConsumerState<ClienteFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _direccionController;
  bool _isLoading = false;

  bool get _isEditing => widget.clienteAEditar != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.clienteAEditar?.nombre ?? '');
    _apellidoController = TextEditingController(text: widget.clienteAEditar?.apellido ?? '');
    _telefonoController = TextEditingController(text: widget.clienteAEditar?.telefono ?? '');
    _direccionController = TextEditingController(text: widget.clienteAEditar?.direccion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final controller = ref.read(clienteControllerProvider.notifier);

      if (_isEditing) {
        await controller.actualizarCliente(
          widget.clienteAEditar!.id,
          _nombreController.text.trim(),
          _apellidoController.text.trim(),
          _telefonoController.text.trim(),
          _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
        );
      } else {
        final String id = DateTime.now().millisecondsSinceEpoch.toString();
        await controller.crearCliente(
          id,
          _nombreController.text.trim(),
          _apellidoController.text.trim(),
          _telefonoController.text.trim(),
          _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Cliente actualizado exitosamente' : 'Cliente guardado exitosamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.racingRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera del Modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Actualizar Cliente' : 'Nuevo Cliente',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),

              // Campo Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Campo Apellido
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'El apellido es obligatorio' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Campo Teléfono
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'El teléfono es obligatorio' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Campo Dirección
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Botones de Acción
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _guardarCliente,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.racingRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                _isEditing ? 'Actualizar' : 'Guardar',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}