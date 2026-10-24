import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/cliente/controller/cliente_controller.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Formulario modal desplegable tipo [BottomSheet] para crear o editar un [Cliente].
///
/// Si [clienteAEditar] no es nulo, el formulario precargará la información existente
/// para su edición. De lo contrario, funcionará en modo de registro de nuevo cliente.
class ClienteFormBottomSheet extends ConsumerStatefulWidget {
  /// Instancia opcional de [Cliente] a editar.
  final Cliente? clienteAEditar;

  const ClienteFormBottomSheet({
    super.key,
    this.clienteAEditar,
  });

  @override
  ConsumerState<ClienteFormBottomSheet> createState() => _ClienteFormBottomSheetState();
}

/// Estado interno de [ClienteFormBottomSheet] encargado de gestionar los
/// controladores de formulario, la aplicación de máscaras y la persistencia de datos.
class _ClienteFormBottomSheetState extends ConsumerState<ClienteFormBottomSheet> {
  /// Clave global para la validación de los campos del formulario.
  final _formKey = GlobalKey<FormState>();

  /// Controlador de texto para el campo del nombre del cliente.
  late final TextEditingController _nombreController;

  /// Controlador de texto para el campo del apellido del cliente.
  late final TextEditingController _apellidoController;

  /// Controlador de texto para el campo del número telefónico.
  late final TextEditingController _telefonoController;

  /// Controlador de texto para el campo opcional de la dirección.
  late final TextEditingController _direccionController;

  /// Bandera de estado que indica si se está ejecutando una petición asíncrona de guardado.
  bool _isLoading = false;

  /// Formateador de texto para aplicar una máscara numérica al número telefónico (ej: 7000-0000).
  final _telefonoMaskFormatter = MaskTextInputFormatter(
    mask: '####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  /// Evalúa si el modal se encuentra en modo edición o creación.
  bool get _isEditing => widget.clienteAEditar != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.clienteAEditar?.nombre ?? '');
    _apellidoController = TextEditingController(text: widget.clienteAEditar?.apellido ?? '');
    
    // Si existe un teléfono precargado, se le aplica la máscara al inicializar.
    final telefonoInicial = widget.clienteAEditar?.telefono ?? '';
    _telefonoController = TextEditingController(
      text: _telefonoMaskFormatter.maskText(telefonoInicial),
    );

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

  /// Valida y procesa los datos del formulario enviándolos al [ClienteController].
  ///
  /// En caso de éxito, cierra el modal y muestra un [SnackBar] de confirmación.
  /// Si ocurre un error, muestra un mensaje explicativo en pantalla.
  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final controller = ref.read(clienteControllerProvider.notifier);
      final telefonoIngresado = _telefonoController.text.trim();

      if (_isEditing) {
        await controller.actualizarCliente(
          widget.clienteAEditar!.id,
          _nombreController.text.trim(),
          _apellidoController.text.trim(),
          telefonoIngresado,
          _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
        );
      } else {
        final String id = DateTime.now().millisecondsSinceEpoch.toString();
        await controller.crearCliente(
          id,
          _nombreController.text.trim(),
          _apellidoController.text.trim(),
          telefonoIngresado,
          _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Cliente actualizado exitosamente' : 'Cliente guardado exitosamente',
            ),
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
            backgroundColor: AppColors.brand,
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
              // Cabecera del Modal con Título y Botón de Cierre
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

              // Campo Teléfono con Máscara
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                inputFormatters: [_telefonoMaskFormatter],
                decoration: const InputDecoration(
                  labelText: 'Teléfono *',
                  hintText: '0000-0000',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El teléfono es obligatorio';
                  }
                  if (value.length < 9) {
                    return 'Ingresa un número de teléfono válido (8 dígitos)';
                  }
                  return null;
                },
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

              // Botones de Acción (Cancelar / Guardar)
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
                          backgroundColor: AppColors.brand,
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