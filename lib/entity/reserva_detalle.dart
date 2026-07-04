class ReservaDetalle {
  final String id;
  final String idReserva;
  final String idInventario;
  final double precioAcordado;

  ReservaDetalle({
    required this.id,
    required this.idReserva,
    required this.idInventario,
    required this.precioAcordado
  });

  /// Crea una instancia de [ReservaDetalle] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, idReserva, idInventario, precioAcordado.
  factory ReservaDetalle.fromMap(Map<String,dynamic> map){
    return ReservaDetalle(
      id: map["id"] as String,
      idReserva: map["idReserva"] as String,
      idInventario: map["idInventario"] as String,
      precioAcordado: (map["precioAcordado"] as num).toDouble()
    );
  }

  /// Convierte la instancia actual de [ReservaDetalle] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [ReservaDetalle.fromMap].
  Map<String,dynamic> toMap(){
    return {
      'id': id,
      "idReserva": idReserva,
      "idInventario": idInventario,
      "precioAcordado": precioAcordado
    };
  }

  /// Crea una copia de la instancia actual de [ReservaDetalle] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  ReservaDetalle copyWith({
    String? id,
    String? idReserva,
    String? idInventario,
    double? precioAcordado,
  }) {
    return ReservaDetalle(
      id: id ?? this.id,
      idReserva: idReserva ?? this.idReserva,
      idInventario: idInventario ?? this.idInventario,
      precioAcordado: precioAcordado ?? this.precioAcordado,
    );
  }
}