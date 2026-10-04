import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/inventario/controller/inventario_controller.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';

import '../widgets/inventario_info_banner.dart';

class InventarioFormPage extends ConsumerStatefulWidget {
  final Inventario? item;

  const InventarioFormPage({super.key, this.item});

  @override
  ConsumerState<InventarioFormPage> createState() => _InventarioFormPageState();
}

class _InventarioFormPageState extends ConsumerState<InventarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioVentaController = TextEditingController();
  final _tallaController = TextEditingController();
  final _cmController = TextEditingController();
  final _colorController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _fechaCompraController = TextEditingController();

  String? _idZapato;
  String? _idMarca;
  String? _idCategoria;
  DateTime _fechaCompra = DateTime.now();
  XFile? _imagenSeleccionada;
  String? _imagenActualPath;
  bool _guardando = false;

  bool get _editando => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _fechaCompraController.text = _formatearFecha(_fechaCompra);
    if (item != null) {
      _idZapato = item.idZapato;
      _tallaController.text = item.talla.toString();
      _cmController.text = item.cm.toString();
      _colorController.text = item.color ?? '';
      _precioCompraController.text = item.precioCompra.toString();
      _fechaCompra = item.fechaCompra;
      _fechaCompraController.text = _formatearFecha(_fechaCompra);
      Future.microtask(_cargarDatosModelo);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _modeloController,
      _descripcionController,
      _precioVentaController,
      _tallaController,
      _cmController,
      _colorController,
      _precioCompraController,
      _fechaCompraController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  Future<void> _seleccionarImagen() async {
    try {
      final imagen = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (imagen == null || !mounted) return;

      final directory = await getApplicationDocumentsDirectory();
      final extension = imagen.name.contains('.')
          ? imagen.name.split('.').last
          : 'jpg';
      final destino = File(
        '${directory.path}/zapato_${DateTime.now().microsecondsSinceEpoch}.$extension',
      );
      await File(imagen.path).copy(destino.path);
      if (!mounted) return;
      setState(() {
        _imagenSeleccionada = XFile(destino.path);
        _imagenActualPath = destino.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen seleccionada correctamente.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo seleccionar la imagen: $error')),
        );
      }
    }
  }

  Future<void> _cargarDatosModelo() async {
    final zapatos = await ref.read(zapatosCatalogoProvider.future);
    if (!mounted) return;
    final zapato = zapatos.where((item) => item.id == _idZapato).firstOrNull;
    if (zapato == null) return;
    setState(() {
      _modeloController.text = zapato.modelo;
      _descripcionController.text = zapato.descripcion ?? '';
      _precioVentaController.text = zapato.precioVentaSugerido.toString();
      _idMarca = zapato.idMarca;
      _idCategoria = zapato.idCategoria;
      _imagenActualPath = zapato.imagenPath;
    });
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _fechaCompra.isAfter(DateTime.now())
          ? DateTime.now()
          : _fechaCompra,
    );
    if (fecha != null) {
      setState(() {
        _fechaCompra = fecha;
        _fechaCompraController.text = _formatearFecha(fecha);
      });
    }
  }

  Future<void> _guardarInventario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    try {
      var idZapato = _idZapato;
      final zapatoController = ref.read(zapatoControllerProvider.notifier);
      final descripcion = _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text;
      final imagenPath = _imagenActualPath;

      if (_editando) {
        if (idZapato == null || _idMarca == null || _idCategoria == null) {
          throw StateError('No se encontraron los datos del modelo.');
        }
        await zapatoController.actualizarZapato(
          id: idZapato,
          modelo: _modeloController.text,
          idMarca: _idMarca!,
          idCategoria: _idCategoria!,
          precio: double.parse(_precioVentaController.text),
          descripcion: descripcion,
          imagenPath: imagenPath,
        );
      } else {
        final nuevoIdZapato = DateTime.now().microsecondsSinceEpoch.toString();
        await zapatoController.crearZapato(
          id: nuevoIdZapato,
          modelo: _modeloController.text,
          idMarca: _idMarca!,
          idCategoria: _idCategoria!,
          precio: double.parse(_precioVentaController.text),
          descripcion: descripcion,
          imagenPath: imagenPath,
        );
        idZapato = nuevoIdZapato;
      }

      final controller = ref.read(inventarioControllerProvider.notifier);
      if (_editando) {
        await controller.actualizarInventario(
          id: widget.item!.id,
          idZapato: idZapato,
          talla: double.parse(_tallaController.text),
          cm: double.parse(_cmController.text),
          precioCompra: double.parse(_precioCompraController.text),
          fechaCompra: _fechaCompra,
          color: _colorController.text.trim().isEmpty
              ? null
              : _colorController.text,
        );
      } else {
        await controller.crearInventario(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          idZapato: idZapato,
          talla: double.parse(_tallaController.text),
          cm: double.parse(_cmController.text),
          precioCompra: double.parse(_precioCompraController.text),
          fechaCompra: _fechaCompra,
          color: _colorController.text.trim().isEmpty
              ? null
              : _colorController.text,
        );
      }
      if (mounted) {
        Navigator.pop(
          context,
          _editando
              ? 'Inventario actualizado correctamente.'
              : 'Inventario guardado correctamente.',
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar el inventario: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final marcas = ref.watch(marcasCatalogoProvider);
    final categorias = ref.watch(categoriasZapatoCatalogoProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppBackButton(),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editando ? 'Editar Inventario' : 'Registrar Nuevo Par',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Administra tus existencias',
                        style: TextStyle(fontSize: 14, color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              InventarioInfoBanner(
                text: _editando
                    ? 'Puedes actualizar los datos del modelo y del par. El código de inventario se conservará.'
                    : 'Se creará el modelo y se agregará una unidad al inventario. El código se generará automáticamente.',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildNuevoModelo(marcas, categorias),
              const SizedBox(height: AppSpacing.md),
              _buildDatosPar(),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardarInventario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.racingRed,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _guardando
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(_editando ? 'Guardar Cambios' : 'Registrar Par'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNuevoModelo(
    AsyncValue<List<Marca>> marcas,
    AsyncValue<List<CategoriaZapato>> categorias,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Datos del modelo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        _campoTexto(
          _modeloController,
          'Nombre del modelo *',
          'Ej. Air Force 1',
          validator: (value) => value == null || value.trim().length < 2
              ? 'Introduce al menos 2 caracteres'
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMarcaDropdown(marcas)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildCategoriaDropdown(categorias)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _campoTexto(
          _precioVentaController,
          'Precio de venta sugerido *',
          '0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixText: '\$ ',
          validator: _validarNumero,
        ),
        const SizedBox(height: AppSpacing.md),
        _campoTexto(
          _descripcionController,
          'Descripción',
          'Detalles adicionales...',
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _seleccionarImagen,
          icon: const Icon(Icons.add_a_photo),
          label: Text(
            _imagenSeleccionada == null ? 'Añadir imagen' : 'Cambiar imagen',
          ),
        ),
        if (_imagenSeleccionada != null || _imagenActualPath != null) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(height: 120, width: 120, child: _buildImagenModelo()),
        ],
      ],
    );
  }

  Widget _buildImagenModelo() {
    if (_imagenSeleccionada != null) {
      return FutureBuilder(
        future: _imagenSeleccionada!.readAsBytes(),
        builder: (context, snapshot) => snapshot.hasData
            ? Image.memory(snapshot.data!, fit: BoxFit.cover)
            : const CircularProgressIndicator(),
      );
    }
    return Image.file(
      File(_imagenActualPath!),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, color: AppColors.grey),
    );
  }

  Widget _buildDatosPar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Datos del par',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _campoTexto(
                _tallaController,
                'Talla *',
                'Ej. 9',
                validator: _validarNumero,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _campoTexto(
                _cmController,
                'Medida en CM *',
                'Ej. 27.5',
                validator: _validarNumero,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _campoTexto(_colorController, 'Color', 'Ej. NEGRO'),
        const SizedBox(height: AppSpacing.md),
        _campoTexto(
          _precioCompraController,
          'Precio de compra *',
          '0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixText: '\$ ',
          validator: _validarNumero,
        ),
        const SizedBox(height: AppSpacing.md),
        _campoTexto(
          _fechaCompraController,
          'Fecha de compra *',
          '',
          readOnly: true,
          suffixIcon: const Icon(Icons.calendar_today),
          onTap: _seleccionarFecha,
          validator: (value) =>
              value == null || value.isEmpty ? 'Selecciona una fecha' : null,
        ),
      ],
    );
  }

  Widget _buildMarcaDropdown(AsyncValue<List<Marca>> marcas) =>
      _buildRelacionDropdown<Marca>(
        label: 'Marca *',
        value: _idMarca,
        values: marcas,
        id: (item) => item.id,
        name: (item) => item.nombreMarca,
        onChanged: (value) => setState(() => _idMarca = value),
      );

  Widget _buildCategoriaDropdown(
    AsyncValue<List<CategoriaZapato>> categorias,
  ) => _buildRelacionDropdown<CategoriaZapato>(
    label: 'Categoría *',
    value: _idCategoria,
    values: categorias,
    id: (item) => item.id,
    name: (item) => item.nombreCategoria,
    onChanged: (value) => setState(() => _idCategoria = value),
  );

  Widget _buildRelacionDropdown<T>({
    required String label,
    required String? value,
    required AsyncValue<List<T>> values,
    required String Function(T) id,
    required String Function(T) name,
    required ValueChanged<String?> onChanged,
  }) {
    return _section(
      title: label,
      child: values.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('No se pudo cargar: $error'),
        data: (items) => DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          hint: const Text('Seleccionar'),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: id(item),
                  child: Text(name(item)),
                ),
              )
              .toList(),
          onChanged: items.isEmpty ? null : onChanged,
          validator: (selected) =>
              selected == null ? 'Selecciona una opción' : null,
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }

  Widget _campoTexto(
    TextEditingController controller,
    String label,
    String hint, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? prefixText,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return _section(
      title: label,
      child: TextFormField(
        controller: controller,
        textCapitalization: label == 'Color'
            ? TextCapitalization.characters
            : TextCapitalization.sentences,
        onChanged: label == 'Color'
            ? (value) {
                final uppercase = value.toUpperCase();
                if (value != uppercase) {
                  controller.value = controller.value.copyWith(
                    text: uppercase,
                    selection: TextSelection.collapsed(
                      offset: uppercase.length,
                    ),
                  );
                }
              }
            : null,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint.isEmpty ? null : hint,
          prefixText: prefixText,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  String? _validarNumero(String? value) {
    final numero = double.tryParse(value?.trim() ?? '');
    return numero == null || numero <= 0
        ? 'Introduce un número mayor que cero'
        : null;
  }
}
