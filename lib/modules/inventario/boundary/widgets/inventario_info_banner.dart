import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class InventarioInfoBanner extends StatelessWidget {
  final String text;

  const InventarioInfoBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}