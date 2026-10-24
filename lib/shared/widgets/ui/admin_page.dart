import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Esqueleto común de las pantallas de Administración (marcas, categorías,
/// clientes...): barra con flecha atrás, descripción, contenido y un único
/// botón "+" flotante para crear un registro nuevo.
class AdminPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String addLabel;
  final VoidCallback onAdd;
  final List<Widget> children;

  const AdminPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.addLabel,
    required this.onAdd,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: Text(addLabel),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
        children: [
          Text(subtitle, style: const TextStyle(fontSize: 13.5)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

/// Círculo con la inicial (o un ícono) que encabeza cada tarjeta.
class AdminAvatar extends StatelessWidget {
  final String text;
  final IconData? icon;

  const AdminAvatar({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: 22,
      backgroundColor: scheme.primary.withValues(alpha: .1),
      child: icon != null
          ? Icon(icon, color: scheme.primary, size: 22)
          : Text(
              text,
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
    );
  }
}

/// Tarjeta de un registro: toda ella abre la edición y deja a la vista
/// los botones de editar y eliminar (nada escondido).
class AdminItemCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final List<Widget> details;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminItemCard({
    super.key,
    required this.leading,
    required this.title,
    this.details = const [],
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                    ),
                    ...details,
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar',
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, color: scheme.primary, size: 22),
              ),
              IconButton(
                tooltip: 'Eliminar',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Línea secundaria de una tarjeta, con ícono opcional.
class AdminDetail extends StatelessWidget {
  final String text;
  final IconData? icon;

  const AdminDetail(this.text, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: muted),
            const SizedBox(width: 5),
          ],
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, color: muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mensaje centrado para listas vacías o con errores.
class AdminMessage extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isError;

  const AdminMessage(this.text, {super.key, this.icon = Icons.inbox_outlined, this.isError = false});

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.danger : Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color.withValues(alpha: .7)),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}

/// Diálogo de confirmación para eliminar. Devuelve `true` si se confirma.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text(message),
      actions: [
        TextButton(
          style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 44),
            backgroundColor: AppColors.danger,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  return result ?? false;
}
