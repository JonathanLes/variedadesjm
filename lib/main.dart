import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart'; 

void main() {
  runApp(
    const ProviderScope(child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zapatos Americanos',
      debugShowCheckedModeBanner: false, // Esto quita la etiqueta de "DEBUG" de la esquina superior derecha
      theme: ThemeData(
        // Puedes dejar esto vacío por ahora, ya que estamos manejando 
        // nuestros propios colores en el archivo colors.dart
      ),
      // Aquí es donde ocurre la magia: cambiamos MyHomePage por nuestro AppLayout
      home: const AppLayout(
        // Como AppLayout exige un "child" (el contenido del centro), 
        // le pasamos un texto temporal por ahora.
        child: Center(
          child: Text(
            '¡Bienvenido! Aquí irá el contenido del Dashboard.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}