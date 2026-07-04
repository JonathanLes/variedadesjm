class Gasto {
  final String id;
  final String descripcion;
  final double monto;
  final DateTime fechaGasto;
  final String idCategoriaGasto;
  final String metodoPago;

  Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.fechaGasto,
    required this.idCategoriaGasto,
    required this.metodoPago,
  });

  /// Crea una instancia de [Gasto] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves: id, descripcion, monto, 
  /// fechaGasto, idCategoriaGasto y metodoPago.
  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map["id"] as String,
      descripcion: map["descripcion"] as String,
      monto: (map["monto"] as num).toDouble(), 
      fechaGasto: DateTime.parse(map["fechaGasto"] as String),
      idCategoriaGasto: map["idCategoriaGasto"] as String,
      metodoPago: map["metodoPago"] as String,
    );
  }

  /// Convierte la instancia actual de [Gasto] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Gasto.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'monto': monto,
      'fechaGasto': fechaGasto.toIso8601String(),
      'idCategoriaGasto': idCategoriaGasto,
      'metodoPago': metodoPago,
    };
  }

  /// Crea una copia de la instancia actual de [Gasto] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Gasto copyWith({
    String? id,
    String? descripcion,
    double? monto,
    DateTime? fechaGasto,
    String? idCategoriaGasto,
    String? metodoPago,
  }) {
    return Gasto(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      fechaGasto: fechaGasto ?? this.fechaGasto,
      idCategoriaGasto: idCategoriaGasto ?? this.idCategoriaGasto,
      metodoPago: metodoPago ?? this.metodoPago,
    );
  }
}