import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/inventario/inventario.freezed.dart';
part 'generated/inventario/inventario.g.dart';

@freezed
class Inventario with _$Inventario {
  const Inventario._();

  const factory Inventario({
    required String id,
    required String idZapato,
    required String codigo,
    required double talla,
    required double cm,
    String? color,
    required double precioCompra,
    required DateTime fechaCompra,
    required EstadoZapato estado,
  }) = _Inventario;

  factory Inventario.fromJson(Map<String, dynamic> json) => _$InventarioFromJson(json);

  factory Inventario.fromMap(Map<String, dynamic> map) => Inventario.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

/// Se maneja un ciclo de vida para el calzado dentro de la tienda
/// de esa manera se tiene un control del flujo o del proceso
/// que con lleva cada zapato, durante su instancia en el negocio
enum EstadoZapato {
  activo,
  reservado,
  vendido,
}