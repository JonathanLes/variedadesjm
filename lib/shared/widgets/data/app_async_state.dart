import 'package:flutter/material.dart';

/// Estandariza estados de carga, error y ausencia de datos en las páginas.
class AppAsyncState<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(T data) builder;
  final String emptyMessage;
  final bool Function(T data)? isEmpty;

  const AppAsyncState({
    super.key,
    required this.snapshot,
    required this.builder,
    this.emptyMessage = 'Todavía no hay registros.',
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('No se pudieron cargar los datos: ${snapshot.error}'));
    }
    final data = snapshot.data;
    if (data == null || (isEmpty?.call(data) ?? false)) {
      return Center(child: Text(emptyMessage));
    }
    return builder(data);
  }
}
