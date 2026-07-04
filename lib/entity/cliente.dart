class Cliente {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String? direccion;

  Cliente({
    required this.id, 
    required this.nombre,
    required this.apellido,
    required this.telefono,
    this.direccion
  });

  /// Crea una instancia de [Cliente] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, nombre, apellido, telefono
  /// y dirección.
  factory Cliente.fromMap(Map<String,dynamic> map){
    return Cliente(
      id: map["id"] as String,
      nombre: map["nombre"] as String,
      apellido: map["apellido"] as String,
      telefono: map["telefono"] as String,
      direccion: map["direccion"] as String?
    );
  }

  /// Convierte la instancia actual de [Cliente] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Cliente.fromMap].
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      "telefono": telefono,
      "direccion": direccion
    };
  }

  /// Crea una copia de la instancia actual de [Cliente] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Cliente copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
    );
  }
}