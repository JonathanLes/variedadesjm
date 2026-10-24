/// Menú de Administración: acceso a los catálogos base del negocio con contadores.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/pages/categoria_zapato_page.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/cliente/boundary/pages/cliente_page.dart';
import 'package:variedadesjm/modules/marca/boundary/pages/marca_page.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/reserva/boundary/pages/reserva_page.dart';
import 'package:variedadesjm/modules/reserva/controller/reserva_resumen_provider.dart';
import 'package:variedadesjm/modules/zapato/boundary/pages/zapato_page.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

class AdministracionPage extends ConsumerWidget {
  const AdministracionPage({super.key});

  void _open(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marcas = ref.watch(marcasCatalogoProvider).valueOrNull?.length;
    final categorias = ref.watch(categoriasZapatoCatalogoProvider).valueOrNull?.length;
    final productos = ref.watch(zapatosCatalogoProvider).valueOrNull?.length;
    final clientes = ref.watch(clientesProvider).valueOrNull?.length;
    final activas = ref
        .watch(reservasResumenProvider)
        .valueOrNull
        ?.where((r) => r.pendiente)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Organiza la información base de tu negocio.'),
          const SizedBox(height: 14),
          _AdminTile(
            icon: Icons.sell_outlined,
            title: 'Marcas',
            subtitle: 'Registra las marcas del calzado',
            count: marcas?.toString(),
            onTap: () => _open(context, const MarcaPage()),
          ),
          _AdminTile(
            icon: Icons.category_outlined,
            title: 'Categorías',
            subtitle: 'Registra las categorías del calzado',
            count: categorias?.toString(),
            onTap: () => _open(context, const CategoriaZapatoPage()),
          ),
          _AdminTile(
            icon: Icons.shopping_bag_outlined,
            title: 'Productos',
            subtitle: 'Modelos del catálogo con su foto y precio',
            count: productos?.toString(),
            onTap: () => _open(context, const ZapatoPage()),
          ),
          _AdminTile(
            icon: Icons.people_outline,
            title: 'Clientes',
            subtitle: 'Clientes de Variedades JM',
            count: clientes?.toString(),
            onTap: () => _open(context, const ClientePage()),
          ),
          _AdminTile(
            icon: Icons.event_available_outlined,
            title: 'Reservas',
            subtitle: 'Administra las reservas y sus abonos',
            count: activas == null ? null : (activas == 1 ? '1 activa' : '$activas activas'),
            highlight: true,
            onTap: () => _open(context, const ReservaPage()),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? count;
  final bool highlight;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.count,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = highlight ? AppColors.warning : scheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: tone.withValues(alpha: .12),
                  child: Icon(icon, color: tone, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 12.5)),
                    ],
                  ),
                ),
                if (count != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tone.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(count!,
                        style: TextStyle(
                            color: tone, fontSize: 12.5, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
