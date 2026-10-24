/// Proveedores: lista con búsqueda, alta, edición y eliminación.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:variedadesjm/modules/proveedor/controller/proveedor_controller.dart';
import 'package:variedadesjm/modules/proveedor/entity/proveedor.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

class ProveedorPage extends ConsumerStatefulWidget {
  const ProveedorPage({super.key});

  @override
  ConsumerState<ProveedorPage> createState() => _ProveedorPageState();
}

class _ProveedorPageState extends ConsumerState<ProveedorPage> {
  String _query = '';

  void _openForm([Proveedor? proveedor]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProveedorForm(proveedor: proveedor),
    );
  }

  Future<void> _delete(Proveedor p) async {
    final ok = await confirmDelete(
      context,
      title: '¿Eliminar proveedor?',
      message: '¿Seguro que deseas eliminar a "${p.nombre}"?',
    );
    if (!ok || !mounted) return;
    try {
      await ref.read(proveedorActionsProvider).eliminar(p.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proveedor "${p.nombre}" eliminado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar el proveedor.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(proveedoresProvider);
    return AdminPage(
      title: 'Proveedores',
      subtitle: 'Proveedores de Variedades JM',
      addLabel: 'Nuevo proveedor',
      onAdd: _openForm,
      children: [
        TextField(
          onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          decoration: const InputDecoration(
            hintText: 'Buscar por nombre, empresa o teléfono',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 14),
        estado.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('No se pudieron cargar los proveedores: $e'),
          data: (lista) {
            final visibles = lista.where((p) {
              if (_query.isEmpty) return true;
              return p.nombre.toLowerCase().contains(_query) ||
                  p.empresa.toLowerCase().contains(_query) ||
                  p.telefono.contains(_query);
            }).toList();
            if (visibles.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(lista.isEmpty
                      ? 'Aún no has registrado proveedores.'
                      : 'Ningún proveedor coincide con la búsqueda.'),
                ),
              );
            }
            return Column(
              children: [
                for (final p in visibles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AdminItemCard(
                      leading: AdminAvatar(
                        text: p.nombre.isEmpty ? '?' : p.nombre[0].toUpperCase(),
                      ),
                      title: p.nombre,
                      details: [
                        if (p.empresa.isNotEmpty)
                          AdminDetail(p.empresa, icon: Icons.business_outlined),
                        AdminDetail(p.telefono, icon: Icons.phone_outlined),
                      ],
                      onEdit: () => _openForm(p),
                      onDelete: () => _delete(p),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ProveedorForm extends ConsumerStatefulWidget {
  final Proveedor? proveedor;

  const _ProveedorForm({this.proveedor});

  @override
  ConsumerState<_ProveedorForm> createState() => _ProveedorFormState();
}

class _ProveedorFormState extends ConsumerState<_ProveedorForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _empresa;
  late final TextEditingController _telefono;
  final _mask = MaskTextInputFormatter(
    mask: '####-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  bool _saving = false;

  bool get _editing => widget.proveedor != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.proveedor?.nombre ?? '');
    _empresa = TextEditingController(text: widget.proveedor?.empresa ?? '');
    _telefono = TextEditingController(
      text: widget.proveedor == null ? '' : _mask.maskText(widget.proveedor!.telefono),
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _empresa.dispose();
    _telefono.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final id = widget.proveedor?.id ?? 'prov_${DateTime.now().microsecondsSinceEpoch}';
      await ref.read(proveedorActionsProvider).guardar(
            Proveedor(
              id: id,
              nombre: _nombre.text.trim(),
              empresa: _empresa.text.trim(),
              telefono: _telefono.text.trim(),
              activo: widget.proveedor?.activo ?? true,
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar el proveedor.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _editing ? 'Editar proveedor' : 'Nuevo proveedor',
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombre,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Escribe el nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _empresa,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Empresa (opcional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                inputFormatters: [_mask],
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (v) => (v == null || v.length != 9)
                    ? 'Escribe los 8 dígitos del teléfono'
                    : null,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(_saving ? 'Guardando...' : 'Guardar proveedor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
