class CategoriaZapato {
  final String id;
  final String nombreCategoria;

  CategoriaZapato({
    required this.id,
    required this.nombreCategoria
  });

  /// Crea una instancia de [CategoriaZapato] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id y nombreCategoria.
  factory CategoriaZapato.fromMap(Map<String,dynamic> map){
    return CategoriaZapato(
      id: map["id"] as String,
      nombreCategoria: map["nombreCategoria"] as String,
    );
  }

  /// Convierte la instancia actual de [CategoriaZapato] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [CategoriaZapato.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCategoria': nombreCategoria,
    };
  }

  /// Crea una copia de la instancia actual de [CategoriaZapato] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  CategoriaZapato copyWith({
    String? id,
    String? nombreCategoria,
  }) {
    return CategoriaZapato(
      id: id ?? this.id,
      nombreCategoria: nombreCategoria ?? this.nombreCategoria,
    );
  }
}