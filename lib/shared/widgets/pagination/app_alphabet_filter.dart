import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Un widget de filtro alfabético desplegable y genérico.
///
/// Este componente muestra un botón principal que, al ser presionado, 
/// revela una cuadrícula con todas las letras del abecedario (incluyendo la Ñ).
/// Permite al usuario seleccionar una letra específica o limpiar el filtro 
/// seleccionando la opción "Todas las letras".
class AppAlphabetFilter extends StatefulWidget {
  /// La letra actualmente seleccionada. 
  /// Si es [null], significa que no hay ningún filtro alfabético activo.
  final String? selectedLetter;

  /// Callback que se ejecuta cuando el usuario selecciona una letra o limpia el filtro.
  /// Retorna un [String] con la letra, o [null] si seleccionó "Todas las letras".
  final ValueChanged<String?> onChanged;

  /// Crea una instancia de [AppAlphabetFilter].
  const AppAlphabetFilter({
    super.key,
    required this.selectedLetter,
    required this.onChanged,
  });

  @override
  State<AppAlphabetFilter> createState() => _AppAlphabetFilterState();
}

class _AppAlphabetFilterState extends State<AppAlphabetFilter> {
  /// Controla si la cuadrícula de letras está visible u oculta.
  bool _isExpanded = false;

  /// Lista estática del abecedario español (incluye la Ñ).
  static const List<String> _alphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
    'J', 'K', 'L', 'M', 'N', 'Ñ', 'O', 'P', 'Q',
    'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];

  /// Alterna el estado de expansión del menú desplegable.
  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Maneja la selección de una letra.
  /// 
  /// Notifica al widget padre mediante el callback [onChanged] y 
  /// cierra automáticamente el menú desplegable.
  void _handleSelection(String? letter) {
    widget.onChanged(letter);
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determinamos si hay una letra activa para cambiar los colores del botón principal
    final bool hasSelection = widget.selectedLetter != null;
    final Color borderColor = hasSelection ? AppColors.racingRed : AppColors.grey;
    final Color textColor = hasSelection ? AppColors.racingRed : AppColors.graphite;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Etiqueta superior
        const Text(
          'Filtrar por letra',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.graphite,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // 2. Botón principal (Header)
        InkWell(
          onTap: _toggleExpand,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, 
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedLetter ?? 'Todas las letras',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                // Rotación animada del ícono de la flecha
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Cuerpo desplegable (Grid de letras)
        // AnimatedSize permite que la cuadrícula se deslice suavemente al aparecer
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: !_isExpanded
              ? const SizedBox.shrink()
              : Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botón para limpiar el filtro
                      InkWell(
                        onTap: () => _handleSelection(null),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(
                            'Todas las letras',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: widget.selectedLetter == null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: widget.selectedLetter == null
                                  ? AppColors.racingRed
                                  : AppColors.graphite,
                            ),
                          ),
                        ),
                      ),
                      
                      // Cuadrícula de botones de letras
                      Wrap(
                        spacing: 8.0, // Espacio horizontal entre cuadritos
                        runSpacing: 8.0, // Espacio vertical entre cuadritos
                        children: _alphabet.map((letter) {
                          final bool isSelected = widget.selectedLetter == letter;
                          
                          return InkWell(
                            onTap: () => _handleSelection(letter),
                            borderRadius: BorderRadius.circular(6.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.racingRed 
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: isSelected 
                                      ? AppColors.racingRed 
                                      : AppColors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected 
                                      ? AppColors.white 
                                      : AppColors.graphite,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}