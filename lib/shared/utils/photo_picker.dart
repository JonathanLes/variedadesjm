/// Elegir una foto de zapato: tomarla con la cámara o escogerla de la galería.
library;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:variedadesjm/shared/utils/image_store.dart';

/// Muestra las opciones Cámara/Galería y devuelve la ruta permanente de la foto,
/// o null si se cancela. Los errores (p. ej. permiso denegado) se avisan con un SnackBar.
Future<String?> pickShoePhoto(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Tomar foto'),
            subtitle: const Text('Usar la cámara del dispositivo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Elegir de la galería'),
            subtitle: const Text('Seleccionar una foto existente'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;

  try {
    final imagen = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (imagen == null) return null;
    // Se copia a una carpeta permanente: la caché del selector la borra Android.
    return await persistShoeImage(imagen);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(source == ImageSource.camera
              ? 'No se pudo usar la cámara. Revisa el permiso de cámara de la app.'
              : 'No se pudo seleccionar la imagen: $error'),
        ),
      );
    }
    return null;
  }
}
