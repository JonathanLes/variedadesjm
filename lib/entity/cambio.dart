class Cambio {
  final String id;
  final String idVentaDetalleOriginal;
  final String idInventarioNuevo;
  final String motivo;
  final double montoExcedente;
  final DateTime fecha;

  Cambio({
    required this.id,
    required this.idVentaDetalleOriginal,
    required this.idInventarioNuevo,
    required this.motivo,
    required this.montoExcedente,
    required this.fecha,
  });

  /// Crea una instancia de [Cambio] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves: id, idVentaDetalleOriginal, 
  /// idInventarioNuevo, motivo, montoExcedente y fecha.
  factory Cambio.fromMap(Map<String, dynamic> map) {
    return Cambio(
      id: map["id"] as String,
      idVentaDetalleOriginal: map["idVentaDetalleOriginal"] as String,
      idInventarioNuevo: map["idInventarioNuevo"] as String,
      motivo: map["motivo"] as String,
      montoExcedente: (map["montoExcedente"] as num).toDouble(),
      fecha: DateTime.parse(map["fecha"] as String),
    );
  }

  /// Convierte la instancia actual de [Cambio] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Cambio.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idVentaDetalleOriginal': idVentaDetalleOriginal,
      'idInventarioNuevo': idInventarioNuevo,
      'motivo': motivo,
      'montoExcedente': montoExcedente,
      'fecha': fecha.toIso8601String(),
    };
  }

  /// Crea una copia de la instancia actual de [Cambio] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Cambio copyWith({
    String? id,
    String? idVentaDetalleOriginal,
    String? idInventarioNuevo,
    String? motivo,
    double? montoExcedente,
    DateTime? fecha,
  }) {
    return Cambio(
      id: id ?? this.id,
      idVentaDetalleOriginal: idVentaDetalleOriginal ?? this.idVentaDetalleOriginal,
      idInventarioNuevo: idInventarioNuevo ?? this.idInventarioNuevo,
      motivo: motivo ?? this.motivo,
      montoExcedente: montoExcedente ?? this.montoExcedente,
      fecha: fecha ?? this.fecha,
    );
  }
}