import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/spacing.dart';
import '../widgets/drawer_menu_bottom.dart'; 
import '../widgets/app_logo.dart';


//Importaciones de las páginas que están dentro del menú hamburguesa
import "package:variedadesjm/modules/marca/boundary/pages/marca_page.dart";


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
                bottom: BorderSide(
                  color: AppColors.racingRed,
                  width: 4.0,
                ),
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
                    Navigator.pop(context);
                    print('Navegar a Categorías');
                  },
                ),

                // Botón de ejemplo 3
                DrawerMenuButton(
                  icon: Icons.people,
                  title: 'Proveedores',
                  onTap: () {
                    Navigator.pop(context);
                    print('Navegar a Proveedores');
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
                leading: const Icon(Icons.logout, color: AppColors.racingRed),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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