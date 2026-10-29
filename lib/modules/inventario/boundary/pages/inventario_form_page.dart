import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/modules/inventario/controller/inventario_controller.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/data/catalog_queries.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/photo_picker.dart';
import 'package:variedadesjm/shared/widgets/forms/paged_picker.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';

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
    final ruta = await pickShoePhoto(context);
    if (ruta == null || !mounted) return;
    setState(() => _imagenActualPath = ruta);
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
    return Scaffold(
      appBar: AppBar(title: Text(_editando ? 'Editar par' : 'Registrar par')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            InventarioInfoBanner(
              text: _editando
                  ? 'Puedes actualizar los datos del modelo y del par. El código de inventario se conserva.'
                  : 'Se creará el modelo y se agregará una unidad al inventario. El código se genera automáticamente.',
            ),
            const SizedBox(height: 14),
            _tarjeta(
              titulo: 'Modelo',
              icono: Icons.shopping_bag_outlined,
              hijos: [
                _foto(),
                const SizedBox(height: 16),
                _campo(
                  _modeloController,
                  'Nombre del modelo',
                  hint: 'Ej. Air Force 1',
                  icono: Icons.label_outline_rounded,
                  validator: (value) => value == null || value.trim().length < 2
                      ? 'Escribe al menos 2 caracteres'
                      : null,
                ),
                const SizedBox(height: 14),
                PagedPickerField(
                  label: 'Marca',
                  icon: Icons.sell_outlined,
                  value: _idMarca,
                  requiredMessage: 'Selecciona una marca',
                  emptyHelp: 'Aún no hay marcas. Créalas en Administración > Marcas.',
                  fetch: catalogFetch(ref, store: SembastStores.marca, field: 'nombreMarca'),
                  resolve: catalogResolve(ref, store: SembastStores.marca, field: 'nombreMarca'),
                  onChanged: (id) => setState(() => _idMarca = id),
                ),
                const SizedBox(height: 14),
                PagedPickerField(
                  label: 'Categoría',
                  icon: Icons.category_outlined,
                  value: _idCategoria,
                  requiredMessage: 'Selecciona una categoría',
                  emptyHelp: 'Aún no hay categorías. Créalas en Administración > Categorías.',
                  fetch: catalogFetch(
                    ref,
                    store: SembastStores.categoriaZapato,
                    field: 'nombreCategoria',
                  ),
                  resolve: catalogResolve(
                    ref,
                    store: SembastStores.categoriaZapato,
                    field: 'nombreCategoria',
                  ),
                  onChanged: (id) => setState(() => _idCategoria = id),
                ),
                const SizedBox(height: 14),
                _campo(
                  _precioVentaController,
                  'Precio de venta sugerido',
                  hint: '0.00',
                  prefijo: '\$ ',
                  teclado: const TextInputType.numberWithOptions(decimal: true),
                  validator: _validarNumero,
                ),
                const SizedBox(height: 14),
                _campo(
                  _descripcionController,
                  'Descripción (opcional)',
                  hint: 'Detalles adicionales...',
                  lineas: 3,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _tarjeta(
              titulo: 'Par',
              icono: Icons.inventory_2_outlined,
              hijos: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _campo(
                        _tallaController,
                        'Talla',
                        hint: 'Ej. 9',
                        teclado: const TextInputType.numberWithOptions(decimal: true),
                        validator: _validarNumero,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _campo(
                        _cmController,
                        'Medida en cm',
                        hint: 'Ej. 27.5',
                        teclado: const TextInputType.numberWithOptions(decimal: true),
                        validator: _validarNumero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _campo(
                  _colorController,
                  'Color (opcional)',
                  hint: 'Ej. NEGRO',
                  mayusculas: true,
                ),
                const SizedBox(height: 14),
                _campo(
                  _precioCompraController,
                  'Precio de compra',
                  hint: '0.00',
                  prefijo: '\$ ',
                  teclado: const TextInputType.numberWithOptions(decimal: true),
                  validator: _validarNumero,
                ),
                const SizedBox(height: 14),
                _campo(
                  _fechaCompraController,
                  'Fecha de compra',
                  icono: Icons.calendar_today_outlined,
                  soloLectura: true,
                  alTocar: _seleccionarFecha,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Selecciona una fecha' : null,
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardarInventario,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(_editando ? 'Guardar cambios' : 'Registrar par'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta({
    required String titulo,
    required IconData icono,
    required List<Widget> hijos,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: context.tint,
                  child: Icon(icono, size: 18, color: context.brand),
                ),
                const SizedBox(width: 10),
                Text(titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 16),
            ...hijos,
          ],
        ),
      ),
    );
  }

  Widget _foto() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 96,
            height: 96,
            child: ShoeImage(path: _imagenActualPath, iconSize: 34),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Foto del modelo',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('Ayuda a reconocer el par al vender.',
                  style: TextStyle(fontSize: 12.5, color: context.muted)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _seleccionarImagen,
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
                icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                label: Text(_imagenActualPath == null ? 'Tomar o añadir foto' : 'Cambiar foto'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _campo(
    TextEditingController controller,
    String etiqueta, {
    String? hint,
    IconData? icono,
    String? prefijo,
    TextInputType? teclado,
    String? Function(String?)? validator,
    bool soloLectura = false,
    VoidCallback? alTocar,
    int lineas = 1,
    bool mayusculas = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: soloLectura,
          onTap: alTocar,
          maxLines: lineas,
          keyboardType: teclado,
          textCapitalization:
              mayusculas ? TextCapitalization.characters : TextCapitalization.sentences,
          inputFormatters: mayusculas
              ? [
                  TextInputFormatter.withFunction(
                    (old, value) => value.copyWith(text: value.text.toUpperCase()),
                  ),
                ]
              : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefijo,
            prefixIcon: icono == null ? null : Icon(icono, size: 20),
          ),
          validator: validator,
        ),
      ],
    );
  }

  String? _validarNumero(String? value) {
    final numero = double.tryParse(value?.trim() ?? '');
    return numero == null || numero <= 0 ? 'Introduce un número mayor que cero' : null;
  }
}
