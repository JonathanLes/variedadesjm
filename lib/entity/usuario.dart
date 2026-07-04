class Usuario{
  final String id;
  final String nombre;
  final String pinCifrado;
  final UsuarioRol rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.pinCifrado,
    required this.rol
  });

  /// Crea una instancia de [Usuario] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves: id, nombre, pinCifrado y rol.
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map["id"] as String,
      nombre: map["nombre"] as String,
      pinCifrado: map["pinCifrado"] as String,
      rol: UsuarioRol.values.byName(map["rol"] as String),
    );
  }

  /// Convierte la instancia actual de [Usuario] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Usuario.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'pinCifrado': pinCifrado,
      'rol': rol.name, 
    };
  }

  /// Crea una copia de la instancia actual de [Usuario] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Usuario copyWith({
    String? id,
    String? nombre,
    String? pinCifrado,
    UsuarioRol? rol,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      pinCifrado: pinCifrado ?? this.pinCifrado,
      rol: rol ?? this.rol,
    );
  }
}

/// Define los niveles de acceso y privilegios estáticos dentro del sistema.
/// Utilizar este enumerador garantiza la seguridad de la aplicación al evitar 
/// errores tipográficos en la base de datos y permite evaluar fácilmente 
/// qué pantallas o botones mostrar en la interfaz de usuario dependiendo 
/// de la persona que inicie sesión.
enum UsuarioRol{
  admministrador,
  vendedor
}