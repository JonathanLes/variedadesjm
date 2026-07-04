class Reserva {
  final String id;
  final String idCliente;
  final DateTime fechaReserva;
  final DateTime fechaVencimiento;
  final double adelanto;
  final ReservaEstado estado;

  Reserva({
    required this.id,
    required this.idCliente,
    required this.fechaReserva,
    required this.fechaVencimiento,
    required this.adelanto,
    required this.estado
  });

  /// Crea una instancia de [Reserva] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, idCliente, fechaReserva,
  /// fechaVencimiento, adelanto, estado.
  factory Reserva.fromMap(Map<String,dynamic> map){
    return Reserva(
      id: map["id"] as String,
      idCliente: map["idCliente"] as String,
      fechaReserva: DateTime.parse(map["fechaReserva"] as String),
      fechaVencimiento: DateTime.parse(map["fechaVencimiento"] as String),
      adelanto: (map["adelanto"] as num).toDouble(),
      estado: ReservaEstado.values.byName(map["estado"] as String)
    );
  }

  /// Convierte la instancia actual de [Reserva] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Reserva.fromMap].
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "idCliente": idCliente,
      "fechaReserva": fechaReserva.toIso8601String(),
      "fechaVencimiento": fechaVencimiento.toIso8601String(),
      "adelanto": adelanto,
      "estado": estado.name
    };
  }

  /// Crea una copia de la instancia actual de [Reserva] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Reserva copyWith({
    String? id,
    String? idCliente,
    DateTime? fechaReserva,
    DateTime? fechaVencimiento,
    double? adelanto,
    ReservaEstado? estado,
  }) {
    return Reserva(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      adelanto: adelanto ?? this.adelanto,
      estado: estado ?? this.estado,
    );
  }
}

/// Se ha definido un ciclo de vida para las reservas
/// se han dejado dos valores, pendiente y cancelado, de ser
/// necesario se agregaran más estados
enum ReservaEstado{
  pendiente,
  cancelado,
}