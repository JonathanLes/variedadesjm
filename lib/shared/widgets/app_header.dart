import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/spacing.dart';
import 'app_notification_button.dart'; 

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(
          bottom: BorderSide(
            color: AppColors.racingRed,
            width: 3.0, 
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ÍCONO DE MENÚ (Izquierda)
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.white, size: 32),
            onPressed: () {
              // Esta instrucción buscará el Drawer en el AppLayout y lo abrirá
              Scaffold.of(context).openDrawer();
            },
          ),

          // LOGOTIPO (Centro)
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/logo.png', 
                height: 50, 
                // errorBuilder muestra un texto temporal si la imagen aún no existe
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'VARIEDADES JM',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),

          // BOTÓN DE NOTIFICACIONES (Derecha)
          const AppNotificationButton(),
        ],
      ),
    );
  }
}