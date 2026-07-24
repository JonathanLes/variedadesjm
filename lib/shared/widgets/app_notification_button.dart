import 'package:flutter/material.dart';
import '../themes/colors.dart';

class AppNotificationButton extends StatelessWidget {
  final bool hasNotifications; 

  const AppNotificationButton({
    super.key,
    this.hasNotifications = true, // Por defecto lo dejamos en true 
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.white,
            size: 28,
          ),
          onPressed: () {
            // Aquí irá la lógica cuando el usuario toque la campana
            print('Abrir notificaciones');
          },
        ),
        
        // 2. El punto rojo (solo se dibuja si hasNotifications es true)
        if (hasNotifications)
          Positioned(
            right: 12, // Ajustamos la posición hacia la esquina superior derecha
            top: 12,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.racingRed,
                shape: BoxShape.circle, 
              ),
            ),
          ),
      ],
    );
  }
}