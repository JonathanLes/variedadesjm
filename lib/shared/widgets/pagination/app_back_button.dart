import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Un widget de botón de retroceso genérico y reutilizable.
///
/// Muestra un botón con una flecha hacia la izquierda. Por defecto,
/// al presionarlo ejecuta `Navigator.pop(context)` para volver a la
/// pantalla anterior, pero este comportamiento puede ser sobreescrito
/// utilizando el parámetro [onPressed].
class AppBackButton extends StatelessWidget {
  /// Callback opcional que se ejecuta al presionar el botón.
  /// Si es nulo, se ejecutará `Navigator.pop(context)`.
  final VoidCallback? onPressed;

  /// Color opcional para el ícono de la flecha. 
  /// Si no se provee, utiliza [AppColors.graphite].
  final Color? iconColor;

  /// Crea una instancia de [AppBackButton].
  const AppBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Si onPressed es nulo, ejecuta la acción de retroceso por defecto
      onTap: onPressed ?? () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      // Usamos el mismo radio que en AppAlphabetFilter y AppSortFilter
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            // ignore: deprecated_member_use
            color: AppColors.grey.withOpacity(0.2), 
            width: 1.0,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded, // Una flecha moderna y limpia
          color: iconColor ?? AppColors.graphite,
          size: 20,
        ),
      ),
    );
  }
}