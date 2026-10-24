import 'package:flutter/material.dart';

/// Tarjeta compacta para mostrar registros de los módulos administrativos.
class RecordListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final Color? color;
  final VoidCallback? onLongPress;

  const RecordListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    this.color,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: onLongPress,
        leading: CircleAvatar(
          backgroundColor: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: .12),
          foregroundColor: color ?? Theme.of(context).colorScheme.primary,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: Text(trailing, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
