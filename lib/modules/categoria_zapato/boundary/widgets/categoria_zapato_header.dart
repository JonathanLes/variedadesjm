import "package:flutter/material.dart";
import 'package:variedadesjm/shared/themes/colors.dart';

class CategoriaZapatoHeader extends StatelessWidget {
  const CategoriaZapatoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categorías",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.ink,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Administra las categorías de zapatos",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}