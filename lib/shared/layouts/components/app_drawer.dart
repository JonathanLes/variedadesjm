/// Construye el menú lateral para navegar por catálogos y configuración.
import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/spacing.dart';
import 'drawer_menu_button.dart';
import 'app_logo.dart';

//Importaciones de las páginas que están dentro del menú hamburguesa
import "package:variedadesjm/modules/marca/boundary/pages/marca_page.dart";
import "package:variedadesjm/modules/categoria_zapato/boundary/pages/categoria_zapato_page.dart";
import "package:variedadesjm/modules/cliente/boundary/pages/cliente_page.dart";
import "package:variedadesjm/modules/configuracion/boundary/pages/configuracion_page.dart";
import "package:variedadesjm/modules/reserva/boundary/pages/reserva_page.dart";
import "package:variedadesjm/modules/zapato/boundary/pages/zapato_page.dart";

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // ----------------------------------------------------------------
          // ENCABEZADO DEL DRAWER
          // ----------------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: AppSpacing.xxl,
              bottom: AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.black,
              border: Border(
                bottom: BorderSide(color: AppColors.brand, width: 4.0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                AppLogo(),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),

          // ----------------------------------------------------------------
          // CUERPO DEL DRAWER (Menú dinámico y limpio)
          // ----------------------------------------------------------------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                DrawerMenuButton(
                  icon: Icons.local_offer,
                  title: 'Marca',
                  onTap: () {
                    Navigator.pop(context); // Cierra el menú lateral primero
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarcaPage(),
                      ),
                    );
                  },
                ),

                // Botón de ejemplo 2
                DrawerMenuButton(
                  icon: Icons.category,
                  title: 'Categorías',
                  onTap: () {
                    Navigator.pop(context); // Cierra el menú lateral primero
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriaZapatoPage(),
                      ),
                    );
                  },
                ),
                DrawerMenuButton(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Productos',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ZapatoPage()),
                    );
                  },
                ),

                // Botón de ejemplo 3
                DrawerMenuButton(
                  icon: Icons.people,
                  title: 'Clientes',
                  onTap: () {
                    Navigator.pop(context); // Cierra el menú lateral primero
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClientePage(),
                      ),
                    );
                  },
                ),
                DrawerMenuButton(
                  icon: Icons.settings_outlined,
                  title: 'Configuración',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConfiguracionPage(),
                      ),
                    );
                  },
                ),
                DrawerMenuButton(
                  icon: Icons.bookmark_outline,
                  title: 'Reservas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReservaPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // ----------------------------------------------------------------
          // PIE DEL DRAWER (Cerrar sesión)
          // ----------------------------------------------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppColors.danger),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  print('Cerrando sesión...');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
