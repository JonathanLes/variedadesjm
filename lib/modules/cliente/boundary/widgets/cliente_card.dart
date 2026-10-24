import 'package:flutter/material.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Tarjeta individual para mostrar el resumen y acciones de cada cliente.
class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color avatarColor;

  const ClienteCard({
    super.key,
    required this.cliente,
    required this.onEdit,
    required this.onDelete,
    this.avatarColor = AppColors.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Column(
        children: [
          // Fila Superior: Datos del cliente
          Row(
            children: [
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
            ],
          ),
          const SizedBox(height: 14),

          // Fila Inferior: Botones de Acción (Editar / Eliminar)
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.brand,
                  ),
                  label: const Text(
                    'Editar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.brand,
                  ),
                  label: const Text(
                    'Eliminar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}