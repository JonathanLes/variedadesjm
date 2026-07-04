class Marca {
  final String id;
  final String nombreMarca;

  Marca({
    required this.id,
    required this.nombreMarca
  });

  /// Crea una instancia de [Marca] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id y nombreMarca.
  factory Marca.fromMap(Map<String,dynamic> map){
    return Marca(
      id: map["id"] as String,
      nombreMarca: map["nombreMarca"] as String,
    );
  }

  /// Convierte la instancia actual de [Marca] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Marca.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreMarca': nombreMarca,
    };
  }

  /// Crea una copia de la instancia actual de [Marca] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Marca copyWith({
    String? id,
    String? nombreMarca,
  }) {
    return Marca(
      id: id ?? this.id,
      nombreMarca: nombreMarca ?? this.nombreMarca,
    );
  }
}