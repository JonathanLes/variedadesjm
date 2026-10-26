import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Aviso informativo que se adapta al modo claro y oscuro.
class InventarioInfoBanner extends StatelessWidget {
  final String text;

  const InventarioInfoBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.tint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.brand.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: context.brand, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
