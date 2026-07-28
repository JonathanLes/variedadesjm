import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final double width;

  const AppLogo({
    super.key,
    this.height = 80.0, // Tamaño por defecto para el drawer
    this.width = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Aquí invocamos el archivo vectorial
        SvgPicture.asset(
          'assets/app_logo.svg',
          height: height,
          width: width,
        ),
        // Le agregamos el texto que lleva debajo
        const SizedBox(height: 8.0),
        const Text(
          'VARIEDADES JM',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white, 
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}