class Compra {
  final String id;
  final String idProveedor;
  final DateTime fechaCompra;
  final double total;

  Compra({
    required this.id,
    required this.idProveedor,
    required this.fechaCompra,
    required this.total,
  });

  /// Crea una instancia de [Compra] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves: id, idProveedor, fechaCompra y total.
  factory Compra.fromMap(Map<String, dynamic> map) {
    return Compra(
      id: map["id"] as String,
      idProveedor: map["idProveedor"] as String,
      fechaCompra: DateTime.parse(map["fechaCompra"] as String),
      total: (map["total"] as num).toDouble(),
    );
  }

  /// Convierte la instancia actual de [Compra] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Compra.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idProveedor': idProveedor,
      'fechaCompra': fechaCompra.toIso8601String(),
      'total': total,
    };
  }

  /// Crea una copia de la instancia actual de [Compra] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Compra copyWith({
    String? id,
    String? idProveedor,
    DateTime? fechaCompra,
    double? total,
  }) {
    return Compra(
      id: id ?? this.id,
      idProveedor: idProveedor ?? this.idProveedor,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      total: total ?? this.total,
    );
  }
}