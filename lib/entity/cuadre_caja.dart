class CuadreCaja {
  final String id;
  final DateTime fecha;
  final double saldoInicial;
  final double totalIngresos;
  final double totalGastos;
  final double saldoEsperado;
  final double saldoFisico;
  final double diferencia;
  final String? idUsuario;

  CuadreCaja({
    required this.id,
    required this.fecha,
    required this.saldoInicial,
    required this.totalIngresos,
    required this.totalGastos,
    required this.saldoEsperado,
    required this.saldoFisico,
    required this.diferencia,
    this.idUsuario

  });

  /// Crea una instancia de [CuadreCaja] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves: id, fecha, saldoInicial, 
  /// totalIngresos, totalGastos, saldoEsperado, saldoFisico, diferencia e idUsuario.
  factory CuadreCaja.fromMap(Map<String, dynamic> map) {
    return CuadreCaja(
      id: map["id"] as String,
      fecha: DateTime.parse(map["fecha"] as String),
      saldoInicial: (map["saldoInicial"] as num).toDouble(),
      totalIngresos: (map["totalIngresos"] as num).toDouble(),
      totalGastos: (map["totalGastos"] as num).toDouble(),
      saldoEsperado: (map["saldoEsperado"] as num).toDouble(),
      saldoFisico: (map["saldoFisico"] as num).toDouble(),
      diferencia: (map["diferencia"] as num).toDouble(),
      idUsuario: map["idUsuario"] as String?
    );
  }

  /// Convierte la instancia actual de [CuadreCaja] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [CuadreCaja.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'saldoInicial': saldoInicial,
      'totalIngresos': totalIngresos,
      'totalGastos': totalGastos,
      'saldoEsperado': saldoEsperado,
      'saldoFisico': saldoFisico,
      'diferencia': diferencia,
      'idUsuario': idUsuario
    };
  }

  /// Crea una copia de la instancia actual de [CuadreCaja] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  CuadreCaja copyWith({
    String? id,
    DateTime? fecha,
    double? saldoInicial,
    double? totalIngresos,
    double? totalGastos,
    double? saldoEsperado,
    double? saldoFisico,
    double? diferencia,
    String? idUsuario,
  }) {
    return CuadreCaja(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      saldoInicial: saldoInicial ?? this.saldoInicial,
      totalIngresos: totalIngresos ?? this.totalIngresos,
      totalGastos: totalGastos ?? this.totalGastos,
      saldoEsperado: saldoEsperado ?? this.saldoEsperado,
      saldoFisico: saldoFisico ?? this.saldoFisico,
      diferencia: diferencia ?? this.diferencia,
      idUsuario: idUsuario ?? this.idUsuario
    );
  }
}