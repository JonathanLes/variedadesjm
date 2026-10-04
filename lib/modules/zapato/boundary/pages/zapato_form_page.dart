import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
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
  XFile? _imagenSeleccionada;
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
      setState(() => _imagenSeleccionada = imagen);
    }
  }

  Future<void> _guardarModelo() async {
    if (!_formKey.currentState!.validate() ||
        _idMarca == null ||
        _idCategoria == null) {
      return;
    }

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
            imagenPath: _imagenSeleccionada?.path,
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
    return precio == null || precio <= 0
        ? 'Introduce un precio mayor que cero'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final marcas = ref.watch(marcasCatalogoProvider);
    final categorias = ref.watch(categoriasZapatoCatalogoProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: const BackButton(color: AppColors.white),
        title: const Text(
          'Registrar Modelo',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _seleccionarImagen,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: _imagenSeleccionada == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: AppColors.grey,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text(
                                'Añadir Imagen',
                                style: TextStyle(color: AppColors.grey),
                              ),
                            ],
                          )
                        : FutureBuilder(
                            future: _imagenSeleccionada!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Nombre del modelo *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ej. Air Force 1',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Introduce el nombre del modelo'
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
              const Text(
                'Precio de venta sugerido *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                validator: _validarPrecio,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Detalles adicionales...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardarModelo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.racingRed,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _guardando
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : const Text('Guardar Modelo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarcaDropdown(AsyncValue<List<Marca>> marcas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Marca *', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.xs),
        marcas.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('No se pudieron cargar las marcas: $error'),
          data: (state) => DropdownButtonFormField<String>(
            initialValue: _idMarca,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text('Seleccionar'),
            items: state
                .map(
                  (marca) => DropdownMenuItem(
                    value: marca.id,
                    child: Text(marca.nombreMarca),
                  ),
                )
                .toList(),
            onChanged: state.isEmpty
                ? null
                : (value) => setState(() => _idMarca = value),
            validator: (value) => value == null ? 'Selecciona una marca' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriaDropdown(AsyncValue<List<CategoriaZapato>> categorias) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría *',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        categorias.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text('No se pudieron cargar las categorías: $error'),
          data: (state) => DropdownButtonFormField<String>(
            initialValue: _idCategoria,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text('Seleccionar'),
            items: state
                .map(
                  (categoria) => DropdownMenuItem(
                    value: categoria.id,
                    child: Text(categoria.nombreCategoria),
                  ),
                )
                .toList(),
            onChanged: state.isEmpty
                ? null
                : (value) => setState(() => _idCategoria = value),
            validator: (value) =>
                value == null ? 'Selecciona una categoría' : null,
          ),
        ),
      ],
    );
  }
}
