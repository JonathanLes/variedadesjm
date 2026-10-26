import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/data/catalog_queries.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/image_store.dart';
import 'package:variedadesjm/shared/widgets/forms/paged_picker.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';
import '../../controller/zapato_controller.dart';

class ZapatoFormPage extends ConsumerStatefulWidget {
  const ZapatoFormPage({super.key});

  @override
  ConsumerState<ZapatoFormPage> createState() => _ZapatoFormPageState();
}

class _ZapatoFormPageState extends ConsumerState<ZapatoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController();
  String? _imagenGuardadaPath;
  String? _idMarca;
  String? _idCategoria;
  bool _guardando = false;

  @override
  void dispose() {
    _modeloController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (imagen != null && mounted) {
      // Se copia a una carpeta permanente: la ruta del picker es temporal.
      final ruta = await persistShoeImage(imagen);
      if (!mounted) return;
      setState(() => _imagenGuardadaPath = ruta);
    }
  }

  Future<void> _guardarModelo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    try {
      await ref
          .read(zapatoControllerProvider.notifier)
          .crearZapato(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            modelo: _modeloController.text,
            idMarca: _idMarca!,
            idCategoria: _idCategoria!,
            precio: double.parse(_precioController.text.trim()),
            descripcion: _descripcionController.text,
            imagenPath: _imagenGuardadaPath,
          );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar el modelo: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  String? _validarPrecio(String? value) {
    final precio = double.tryParse(value?.trim() ?? '');
    return precio == null || precio <= 0 ? 'Introduce un precio mayor que cero' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar modelo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: 96,
                            height: 96,
                            child: ShoeImage(path: _imagenGuardadaPath, iconSize: 34),
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
                                label: Text(_imagenGuardadaPath == null
                                    ? 'Añadir foto'
                                    : 'Cambiar foto'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _etiqueta('Nombre del modelo'),
                    TextFormField(
                      controller: _modeloController,
                      decoration: const InputDecoration(
                        hintText: 'Ej. Air Force 1',
                        prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Introduce el nombre del modelo'
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
                      resolve:
                          catalogResolve(ref, store: SembastStores.marca, field: 'nombreMarca'),
                      onChanged: (id) => setState(() => _idMarca = id),
                    ),
                    const SizedBox(height: 14),
                    PagedPickerField(
                      label: 'Categoría',
                      icon: Icons.category_outlined,
                      value: _idCategoria,
                      requiredMessage: 'Selecciona una categoría',
                      emptyHelp:
                          'Aún no hay categorías. Créalas en Administración > Categorías.',
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
                    _etiqueta('Precio de venta sugerido'),
                    TextFormField(
                      controller: _precioController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: '0.00', prefixText: '\$ '),
                      validator: _validarPrecio,
                    ),
                    const SizedBox(height: 14),
                    _etiqueta('Descripción (opcional)'),
                    TextFormField(
                      controller: _descripcionController,
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'Detalles adicionales...'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardarModelo,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Icon(Icons.check_rounded),
              label: const Text('Guardar modelo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _etiqueta(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(texto, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      );
}
