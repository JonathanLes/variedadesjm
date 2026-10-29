/// Menú de Configuración: colores, copias de seguridad y políticas de privacidad.
import 'package:flutter/material.dart';
import 'package:variedadesjm/modules/backup/boundary/pages/backup_page.dart';
import 'package:variedadesjm/modules/configuracion/boundary/pages/colores_page.dart';
import 'package:variedadesjm/modules/configuracion/boundary/pages/politicas_privacidad_page.dart';

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({super.key});

  void _open(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Ajusta la app a tus necesidades.'),
          const SizedBox(height: 14),
          _ConfigTile(
            icon: Icons.palette_outlined,
            title: 'Colores de la app',
            subtitle: 'Elige la paleta de colores',
            onTap: () => _open(context, const ColoresPage()),
          ),
          _ConfigTile(
            icon: Icons.backup_outlined,
            title: 'Copias de seguridad',
            subtitle: 'Guarda y restaura los datos de tu negocio',
            onTap: () => _open(context, const BackupPage()),
          ),
          _ConfigTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Políticas de privacidad',
            subtitle: 'Cómo se tratan tus datos',
            onTap: () => _open(context, const PoliticasPrivacidadPage()),
          ),
        ],
      ),
    );
  }
}

class _ConfigTile extends StatelessWidget {
  const _ConfigTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: scheme.primary.withValues(alpha: .12),
                  child: Icon(icon, color: scheme.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 15.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 12.5)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
