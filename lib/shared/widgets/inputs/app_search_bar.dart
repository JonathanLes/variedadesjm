import 'dart:async';
import 'package:flutter/material.dart';

/// Un campo de texto de búsqueda genérico y reutilizable para la aplicación.
/// 
/// Este widget proporciona una barra de búsqueda visualmente estilizada con un
/// ícono de lupa, un botón dinámico para limpiar el texto y un mecanismo de **debounce**
/// integrado. 
/// 
/// El debounce retrasa la emisión del evento de búsqueda hasta que el 
/// usuario deje de escribir durante 500 milisegundos, optimizando el rendimiento
/// al evitar llamadas excesivas a la base de datos local (Sembast) o la API.

class AppSearchBar extends StatefulWidget {
  /// El texto de sugerencia que aparece cuando el campo de búsqueda está vacío.
  final String hintText;

  /// Callback que se ejecuta cuando el texto de búsqueda cambia.
  /// 
  /// Este evento se dispara de forma segura **después** del tiempo de 
  /// debounce (500 ms), entregando el [String] final que escribió el usuario.
  final ValueChanged<String> onChanged;

  /// Crea una instancia de [AppSearchBar].
  ///
  /// El parámetro [onChanged] es obligatorio para poder delegar la instrucción 
  /// de búsqueda a los controladores (Riverpod).
  const AppSearchBar({
    super.key,
    this.hintText = 'Buscar...',
    required this.onChanged,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  /// Controlador interno que maneja la entrada y limpieza del texto.
  late final TextEditingController _searchController;
  
  /// Temporizador utilizado para gestionar el retraso (debounce) de las teclas.
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // Es crucial cancelar el temporizador al destruir el widget para 
    // evitar llamadas en segundo plano o fugas de memoria (memory leaks).
    _debounce?.cancel(); 
    _searchController.dispose();
    super.dispose();
  }

  /// Procesa los cambios en el texto y aplica el retraso (debounce).
  /// 
  /// Reinicia el temporizador de 500ms cada vez que se ingresa un nuevo carácter.
  /// Solo cuando el temporizador finaliza sin interrupciones, se notifica al widget padre.
  void _onSearchChanged(String query) {
    // Actualiza la vista para renderizar u ocultar el botón "X"
    setState(() {}); 

    // Si hay un temporizador activo, lo cancelamos
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Iniciamos la cuenta regresiva
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(query);
    });
  }

  /// Borra el contenido actual del campo y emite una orden de búsqueda vacía.
  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 22,
          ),
          // El sufijo solo se dibuja si el controlador tiene texto escrito
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.close, size: 20),
                color: Colors.grey.shade600,
                onPressed: _clearSearch,
                tooltip: 'Limpiar búsqueda',
              )
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}