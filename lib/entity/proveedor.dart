class Proveedor {
  final String id;
  final String nombre;
  final String telefono;
  final String empresa;
  final bool activo;

  Proveedor({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.empresa,
    required this.activo
  });

  /// Crea una instancia de [Proveedor] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, nombre, telefono, empresa.
  factory Proveedor.fromMap(Map<String, dynamic> map) {
    return Proveedor(
      id: map["id"] as String,
      nombre: map["nombre"] as String,
      telefono: map["telefono"] as String,
      empresa: map["empresa"] as String,
      activo: map["activo"] as bool
    );
  }

  /// Convierte la instancia actual de [Proveedor] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Proveedor.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'empresa': empresa,
      'activo': activo
    };
  }

  /// Crea una copia de la instancia actual de [Proveedor] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Proveedor copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? empresa,
    bool? activo
  }) {
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      empresa: empresa ?? this.empresa,
      activo: activo ?? this.activo
    );
  }
}