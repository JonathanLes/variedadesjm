import 'package:flutter/material.dart';
import '../themes/colors.dart';

import 'components/app_header.dart';
import 'components/app_bottom_navigation.dart';
import 'components/app_drawer.dart';

class AppLayout extends StatelessWidget {
  // Esta variable es la magia del layout: recibirá la vista que queramos
  // mostrar en el centro (Home, Ventas, Gastos, etc.)
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      //-----------------------------------------------------------------
      // ZONA MENÚ HAMBURGUESA
      //-----------------------------------------------------------------
      drawer: const AppDrawer(), 

      // ----------------------------------------------------------------
      // ZONA SUPERIOR (Header)
      // ----------------------------------------------------------------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), 
        child: SafeArea( 
          child: const AppHeader(), 
        ),
      ),

      // ----------------------------------------------------------------
      //  ZONA CENTRAL (Contenido)
      // ----------------------------------------------------------------
      // Aquí se inyecta la vista que le pasemos al layout. 
      body: child,

      // ----------------------------------------------------------------
      //  ZONA INFERIOR (Bottom Navigation)
      // ----------------------------------------------------------------
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, 
        onItemTapped: (index) {
          // Aquí podemos manejar la navegación entre vistas según el índice
          print('Pestaña seleccionada: $index');
        },
      ),
    );
  }
}