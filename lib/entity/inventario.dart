class Inventario {
  final String id;
  final String idZapato;
  final String codigo;
  final double talla;
  final double cm;
  final String? color;
  final double precioCompra;
  final DateTime fechaCompra;
  final EstadoZapato estado;

  Inventario({
    required this.id,
    required this.idZapato,
    required this.codigo,
    required this.talla,
    required this.cm,
    this.color,
    required this.precioCompra,
    required this.fechaCompra,
    required this.estado,
  });

  /// Crea una instancia de [Inventario] a partir de un mapa de datos.
  /// Este factory se utiliza para deserializar la información proveniente
  /// de una base de datos (como Sembast o SQLite) o de una respuesta JSON.
  /// Se espera que el [map] contenga las llaves id, idZapato, codigo, talla
  /// cm, color, precioCompra y estado.
  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      id: map["id"] as String,
      idZapato: map["idZapato"] as String,
      codigo: map["codigo"] as String,
      talla: (map["talla"] as num).toDouble(),
      cm: (map["cm"] as num).toDouble(),
      color: map["color"] as String?,
      precioCompra: (map["precioCompra"] as num).toDouble(),
      fechaCompra: DateTime.parse(map["fechaCompra"] as String),
      estado: EstadoZapato.values.byName(map["estado"] as String),
    );
  }

  /// Convierte la instancia actual de [Inventario] en un `Map<String, dynamic>`.
  /// Útil para serializar el objeto antes de persistirlo en una base de datos
  /// o enviarlo a través de una petición de red. Las llaves generadas
  /// coinciden exactamente con las requeridas por el método [Inventario.fromMap].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "idZapato": idZapato,
      "codigo": codigo,
      "talla": talla,
      "cm": cm,
      "color": color,
      "precioCompra": precioCompra,
      "fechaCompra": fechaCompra.toIso8601String(),
      "estado": estado.name,
    };
  }

  /// Crea una copia de la instancia actual de [Inventario] modificando únicamente
  /// los campos que se pasen como argumentos. Los campos que no se especifiquen
  /// conservarán su valor original.
  Inventario copyWith({
    String? id,
    String? idZapato,
    String? codigo,
    double? talla,
    double? cm,
    String? color,
    double? precioCompra,
    DateTime? fechaCompra,
    EstadoZapato? estado,
  }) {
    return Inventario(
      id: id ?? this.id,
      idZapato: idZapato ?? this.idZapato,
      codigo: codigo ?? this.codigo,
      talla: talla ?? this.talla,
      cm: cm ?? this.cm,
      color: color ?? this.color,
      precioCompra: precioCompra ?? this.precioCompra,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      estado: estado ?? this.estado,
    );
  }
}

/// Se maneja un ciclo de vida para el calzado dentro de la tienda
/// de esa manera se tiene un control del flujo o del proceso
/// que con lleva cada zapato, durante su instancia en el negocio
enum EstadoZapato{
  activo,
  reservado,
  vendido
}