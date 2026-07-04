class Zapato {
  final String id;
  final String modelo;
  final String? descripcion;
  final String idMarca;
  final String idCategoria;
  final double precioVentaSugerido;
  final String? imagenPath;

  Zapato({
    required this.id,
    required this.modelo,
    this.descripcion,
    required this.idMarca,
    required this.idCategoria,
    required this.precioVentaSugerido,
    this.imagenPath
  });

  /// Crea una instancia de [Zapato] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, modelo, descripcion, idMarca, 
  /// idCategoria, precioVentaSugerido e imagenPath.
  factory Zapato.fromMap(Map<String,dynamic> map){
    return Zapato(
      id: map["id"] as String,
      modelo: map["modelo"] as String,
      descripcion: map["descripcion"] as String?,
      idMarca: map["idMarca"]  as String,
      idCategoria: map["idCategoria"] as String,
      precioVentaSugerido: (map["precioVentaSugerido"] as num).toDouble(),
      imagenPath: map["imagenPath"] as String?
    );
  }

  /// Convierte la instancia actual de [Zapato] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Zapato.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "modelo": modelo,
      "descripcion": descripcion,
      "idMarca": idMarca,
      "idCategoria": idCategoria,
      "precioVentaSugerido": precioVentaSugerido,
      "imagenPath": imagenPath
    };
  }

  /// Crea una copia de la instancia actual de [Zapato] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Zapato copyWith({
    String? id,
    String? modelo,
    String? descripcion,
    String? idMarca,
    String? idCategoria,
    double? precioVentaSugerido,
    String? imagenPath,
  }) {
    return Zapato(
      id: id ?? this.id,
      modelo: modelo ?? this.modelo,
      descripcion: descripcion ?? this.descripcion,
      idMarca: idMarca ?? this.idMarca,
      idCategoria: idCategoria ?? this.idCategoria,
      precioVentaSugerido: precioVentaSugerido ?? this.precioVentaSugerido,
      imagenPath: imagenPath ?? this.imagenPath,
    );
  }
}