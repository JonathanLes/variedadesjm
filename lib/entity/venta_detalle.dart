class VentaDetalle {
  final String id;
  final String idVenta;
  final String idInventario;
  final double precioVentaFinal;

  VentaDetalle({
    required this.id,
    required this.idVenta,
    required this.idInventario,
    required this.precioVentaFinal
  });

  /// Crea una instancia de [VentaDetalle] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, idVenta, idInventario, precioVentaFinal.
  factory VentaDetalle.fromMap(Map<String,dynamic> map){
    return VentaDetalle(
      id: map["id"] as String,
      idVenta: map["idVenta"] as String,
      idInventario: map["idInventario"] as String,
      precioVentaFinal: (map["precioVentaFinal"] as num).toDouble(),

    );
  }

  /// Convierte la instancia actual de [VentaDetalle] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [VentaDetalle.fromMap].
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "idVenta": idVenta,
      "idInventario": idInventario,
      "precioVentaFinal": precioVentaFinal,
    };
  }

  /// Crea una copia de la instancia actual de [VentaDetalle] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  VentaDetalle copyWith({
    String? id,
    String? idVenta,
    String? idInventario,
    double? precioVentaFinal,
  }) {
    return VentaDetalle(
      id: id ?? this.id,
      idVenta: idVenta ?? this.idVenta,
      idInventario: idInventario ?? this.idInventario,
      precioVentaFinal: precioVentaFinal ?? this.precioVentaFinal,
    );
  }
}