import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/venta/venta.freezed.dart';
part 'generated/venta/venta.g.dart';

@freezed
class Venta with _$Venta {
  const Venta._();

  const factory Venta({
    required String id,
    required String idCliente,
    required DateTime fechaVenta,
    required String metodoPago,
    required double total,
  }) = _Venta;

  factory Venta.fromJson(Map<String, dynamic> json) => _$VentaFromJson(json);

  factory Venta.fromMap(Map<String, dynamic> map) => Venta.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}