import 'package:flutter/material.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

/// Tarjeta de un cliente: iniciales, nombre, teléfono y dirección.
class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClienteCard({
    super.key,
    required this.cliente,
    required this.onEdit,
    required this.onDelete,
  });

  String get _iniciales {
    final n = cliente.nombre.trim();
    final a = cliente.apellido.trim();
    return '${n.isNotEmpty ? n[0] : ''}${a.isNotEmpty ? a[0] : ''}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final direccion = cliente.direccion?.trim() ?? '';
    return AdminItemCard(
      leading: AdminAvatar(text: _iniciales.isEmpty ? '?' : _iniciales),
      title: '${cliente.nombre} ${cliente.apellido}',
      details: [
        AdminDetail(cliente.telefono, icon: Icons.phone_outlined),
        if (direccion.isNotEmpty) AdminDetail(direccion, icon: Icons.location_on_outlined),
      ],
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
