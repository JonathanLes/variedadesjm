import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/usuario/usuario.freezed.dart';
part 'generated/usuario/usuario.g.dart';

@freezed
class Usuario with _$Usuario {
  const Usuario._();

  const factory Usuario({
    required String id,
    required String nombre,
    required String pinCifrado,
    required UsuarioRol rol,
  }) = _Usuario;

  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

/// Define los niveles de acceso y privilegios estáticos dentro del sistema.
/// Utilizar este enumerador garantiza la seguridad de la aplicación al evitar 
/// errores tipográficos en la base de datos y permite evaluar fácilmente 
/// qué pantallas o botones mostrar en la interfaz de usuario dependiendo 
/// de la persona que inicie sesión.
enum UsuarioRol {
  admministrador,
  vendedor,
}