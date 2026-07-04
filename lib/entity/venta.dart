class Venta {
  final String id;
  final String idCliente;
  final DateTime fechaVenta;
  final String metodoPago;
  final double total;

  Venta({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.metodoPago,
    required this.total
  });

  /// Crea una instancia de [Venta] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, idCliente, fechaVenta, metodoPago, total.
  factory Venta.fromMap(Map<String,dynamic> map){
    return Venta(
      id: map["id"] as String,
      idCliente: map["idCliente"] as String,
      fechaVenta: DateTime.parse(map["fechaVenta"] as String),
      metodoPago: map["metodoPago"] as String,
      total: (map["total"] as num).toDouble(),

    );
  }

  /// Convierte la instancia actual de [Venta] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Venta.fromMap].
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "idCliente": idCliente,
      "fechaVenta": fechaVenta.toIso8601String(),
      "metodoPago": metodoPago,
      "total": total
    };
  }

  /// Crea una copia de la instancia actual de [Venta] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Venta copyWith({
    String? id,
    String? idCliente,
    DateTime? fechaVenta,
    String? metodoPago,
    double? total,
  }) {
    return Venta(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      fechaVenta: fechaVenta ?? this.fechaVenta,
      metodoPago: metodoPago ?? this.metodoPago,
      total: total ?? this.total,
    );
  }
}