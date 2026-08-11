import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/layouts/components/app_logo.dart';
import '../../themes/colors.dart';
import '../../themes/spacing.dart';
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
          // LOGOTIPO (Centro)
          const Expanded(
            child: Center(
              // Simplemente mandamos a llamar a nuestro componente AppLogo directamente
              child: AppLogo(
                height: 40,
                width: 40,
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