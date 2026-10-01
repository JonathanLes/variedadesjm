import 'package:flutter/material.dart';
import '../themes/colors.dart';

import 'components/app_header.dart';
import 'components/app_bottom_navigation.dart';
import 'components/app_drawer.dart';

//Páginas del layout
import '../../modules/inventario/boundary/pages/inventario_page.dart';

class AppLayout extends StatelessWidget {
  // Esta variable es la magia del layout: recibirá la vista que queramos
  // mostrar en el centro (Home, Ventas, Gastos, etc.)
  final Widget child;

  final int currentIndex;

  const AppLayout({
    super.key,
    required this.child,
    this.currentIndex = 0,
  });

  void _navegar(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget? paginaDestino;

    switch (index) {
      case 0:
        // paginaDestino = const InicioPage(); // Descomentar cuando la crees
        break;
      case 1:
        // paginaDestino = const VentasPage(); // Descomentar cuando la crees
        break;
      case 2:
        // paginaDestino = const GastosPage(); // Descomentar cuando la crees
        break;
      case 3:
        paginaDestino = const InventarioPage(); // Aquí conectamos tu nueva pantalla
        break;
      case 4:
        // paginaDestino = const ReportePage(); // Descomentar cuando la crees
        break;
    }

    // 4. Si hay una página válida a la que ir, usamos pushReplacement 
    // para no apilar pantallas infinitamente en la memoria al usar el menú inferior
    if (paginaDestino != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => paginaDestino!,
          transitionDuration: Duration.zero, // Transición instantánea (opcional)
        ),
      );
    }
  }

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
        currentIndex: currentIndex, // Le pasamos el índice dinámico
        onItemTapped: (index) => _navegar(context, index), // Conectamos el switch
      ),
    );
  }
}