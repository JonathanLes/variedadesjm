/// Políticas de privacidad de Variedades JM.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

const _responsable = 'Jonathan Javier Mejía Ramírez';
const _correo = 'javierramrez509@gmail.com';

class PoliticasPrivacidadPage extends StatelessWidget {
  const PoliticasPrivacidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Políticas de privacidad')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text('Variedades JM',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: context.brand)),
          Text('Última actualización: octubre de 2026',
              style: TextStyle(fontSize: 12.5, color: context.muted)),
          const SizedBox(height: 14),
          const _Seccion('1. Responsable',
              'El responsable del tratamiento de los datos de esta aplicación es $_responsable.'),
          const _Seccion('2. Qué información se maneja',
              'La aplicación registra la información que tú ingresas para administrar tu '
              'negocio: productos, marcas, categorías, inventario, ventas, reservas, gastos, '
              'proveedores y clientes (nombre, teléfono y dirección cuando los registras), '
              'además de las fotos de los zapatos.'),
          const _Seccion('3. Dónde se guarda',
              'Toda la información se almacena únicamente en tu dispositivo. La aplicación '
              'no envía tus datos a servidores del responsable ni de terceros, y no incluye '
              'publicidad ni herramientas de análisis o rastreo.'),
          const _Seccion('4. Permisos del dispositivo',
              '• Cámara y galería: solo para tomar o elegir fotos de los zapatos cuando tú lo '
              'decides.\n'
              '• Carpeta de almacenamiento: solo para guardar y leer las copias de seguridad '
              'en la carpeta que tú elijas.'),
          const _Seccion('5. Copias de seguridad',
              'Las copias se guardan en la carpeta que seleccionas. Quien tenga acceso a esa '
              'carpeta podrá ver su contenido, por lo que te recomendamos guardarlas en un '
              'lugar seguro. Eres responsable de resguardarlas y de eliminar las que ya no '
              'necesites.'),
          const _Seccion('6. Datos de tus clientes',
              'Si registras datos personales de tus clientes, eres responsable de usarlos '
              'solo para fines de tu negocio (por ejemplo, contactar sobre una reserva) y de '
              'protegerlos adecuadamente.'),
          const _Seccion('7. Tus derechos',
              'Puedes consultar, modificar o eliminar la información en cualquier momento '
              'desde la aplicación. Al desinstalarla se elimina la información guardada en '
              'el dispositivo, salvo las copias de seguridad que hayas creado.'),
          const _Seccion('8. Cambios a estas políticas',
              'Estas políticas pueden actualizarse para reflejar mejoras de la aplicación. '
              'La fecha de última actualización se indica al inicio.'),
          const SizedBox(height: 4),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contacto',
                      style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text(_responsable),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Expanded(child: SelectableText(_correo)),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 20),
                        tooltip: 'Copiar correo',
                        onPressed: () async {
                          await Clipboard.setData(const ClipboardData(text: _correo));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Correo copiado')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo, this.texto);

  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(texto, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}
