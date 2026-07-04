class CategoriaGasto {
  final String id;
  final String nombreCategoriaGasto;
  final bool activo; 

  CategoriaGasto({
    required this.id,
    required this.nombreCategoriaGasto,
    required this.activo,
  });

  /// Crea una instancia de [CategoriaGasto] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id y nombreCategoriaGasto.
  factory CategoriaGasto.fromMap(Map<String, dynamic> map) {
    return CategoriaGasto(
      id: map["id"] as String,
      nombreCategoriaGasto: map["nombreCategoriaGasto"] as String,
      activo: map["activo"] as bool,
    );
  }

  /// Convierte la instancia actual de [CategoriaGasto] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [CategoriaGasto.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCategoriaGasto': nombreCategoriaGasto,
      'estado': activo,
    };
  }

  /// Crea una copia de la instancia actual de [CategoriaGasto] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  CategoriaGasto copyWith({
    String? id,
    String? nombreCategoriaGasto,
    bool? activo,
  }) {
    return CategoriaGasto(
      id: id ?? this.id,
      nombreCategoriaGasto: nombreCategoriaGasto ?? this.nombreCategoriaGasto,
      activo: activo ?? this.activo,
    );
  }
}