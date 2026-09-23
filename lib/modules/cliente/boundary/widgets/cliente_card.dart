import 'package:flutter/material.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Tarjeta individual para mostrar el resumen de datos de un cliente.
class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback? onTap;
  final Color avatarColor;

  const ClienteCard({
    super.key,
    required this.cliente,
    this.onTap,
    this.avatarColor = AppColors.racingRed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.grey.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // 1. Círculo de avatar con ícono de cliente
              CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor,
                child: const Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // 2. Información del cliente (Nombre, Teléfono, Dirección)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cliente.nombre} ${cliente.apellido}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: AppColors.graphite,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cliente.telefono,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.graphite,
                          ),
                        ),
                      ],
                    ),
                    if (cliente.direccion != null && cliente.direccion!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.graphite,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              cliente.direccion!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.graphite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // 3. Flecha lateral indicando navegabilidad
              const Icon(
                Icons.chevron_right,
                color: AppColors.black,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}