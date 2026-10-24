/// Formulario para registrar un gasto real en la base local.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/shared/data/app_record_writer.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/widgets/forms/form_section.dart';

/// Valida y persiste un gasto sin datos precargados.
class GastoFormPage extends ConsumerStatefulWidget {
  const GastoFormPage({super.key});

  @override
  ConsumerState<GastoFormPage> createState() => _GastoFormPageState();
}

class _GastoFormPageState extends ConsumerState<GastoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  String _payment = 'Efectivo';
  bool _saving = false;

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final database = await ref.read(sembastDatabaseProvider.future);
      final gasto = Gasto(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        descripcion: _description.text.trim(),
        monto: double.parse(_amount.text.trim().replaceAll(',', '.')),
        fechaGasto: DateTime.now(),
        idCategoriaGasto: 'general',
        metodoPago: _payment,
      );
      await writeRecord(
        database: database,
        storeName: SembastStores.gasto,
        id: gasto.id,
        value: gasto.toMap(),
      );
      ref.invalidate(gastosProvider);
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nuevo gasto')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FormSection(
            title: 'Información del gasto',
            children: [
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Concepto'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa un concepto'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Monto'),
                validator: (value) {
                  final amount = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  return amount == null || amount <= 0
                      ? 'Ingresa un monto válido'
                      : null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _payment,
                decoration: const InputDecoration(labelText: 'Método de pago'),
                items: const ['Efectivo', 'Transferencia', 'Tarjeta']
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _payment = value!),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Guardando...' : 'Registrar gasto'),
          ),
        ],
      ),
    ),
  );
}
