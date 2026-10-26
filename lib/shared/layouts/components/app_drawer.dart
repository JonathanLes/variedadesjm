/// Menú lateral: tarjeta de marca, Administración, Configuración y salida.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_app_state_providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../themes/colors.dart';

import 'package:variedadesjm/modules/administracion/boundary/pages/administracion_page.dart';
import 'package:variedadesjm/modules/configuracion/boundary/pages/configuracion_page.dart';
import 'package:variedadesjm/modules/finanzas/boundary/pages/finanzas_page.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.pop(context); // Cierra el menú lateral primero
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _confirmExit(BuildContext context) async {
    final salir = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Salir de la aplicación?',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Tus datos quedan guardados en este dispositivo.'),
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
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (salir == true) SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: scheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Tarjeta de marca
            Container(
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/app_logo.svg', height: 44, width: 44),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Variedades JM',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 2),
                        Text('Calza a la moda y con nosotros',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                children: [
                  _DarkModeTile(
                    isDark: ref.watch(themeModeProvider) == ThemeMode.dark,
                    onChanged: (dark) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(dark ? ThemeMode.dark : ThemeMode.light),
                  ),
                  _DrawerItem(
                    icon: Icons.tune_rounded,
                    title: 'Administración',
                    subtitle: 'Marcas, categorías, productos, clientes y reservas.',
                    onTap: () => _open(context, const AdministracionPage()),
                  ),
                  _DrawerItem(
                    icon: Icons.insights_rounded,
                    title: 'Finanzas',
                    subtitle: 'Estados financieros, razones y flujo de efectivo.',
                    onTap: () => _open(context, const FinanzasPage()),
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    subtitle: 'Ajusta la app a tus necesidades.',
                    onTap: () => _open(context, const ConfiguracionPage()),
                  ),
                ],
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
                title: const Text('Salir de la aplicación',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.danger)),
                onTap: () => _confirmExit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: scheme.primary.withValues(alpha: .05),
        leading: CircleAvatar(
          backgroundColor: scheme.primary.withValues(alpha: .1),
          child: Icon(icon, color: scheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

/// Interruptor del modo oscuro (primera opción del menú).
class _DarkModeTile extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _DarkModeTile({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => onChanged(!isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: scheme.primary.withValues(alpha: .05),
        leading: CircleAvatar(
          backgroundColor: scheme.primary.withValues(alpha: .1),
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: scheme.primary,
          ),
        ),
        title: const Text('Modo oscuro',
            style: TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(
          isDark ? 'Activado' : 'Desactivado',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Switch(value: isDark, onChanged: onChanged),
      ),
    );
  }
}
