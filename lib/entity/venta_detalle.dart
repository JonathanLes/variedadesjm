import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/venta_detalle/venta_detalle.freezed.dart';
part 'generated/venta_detalle/venta_detalle.g.dart';

@freezed
class VentaDetalle with _$VentaDetalle {
  const VentaDetalle._();

  const factory VentaDetalle({
    required String id,
    required String idVenta,
    required String idInventario,
    required double precioVentaFinal,
  }) = _VentaDetalle;

  factory VentaDetalle.fromJson(Map<String, dynamic> json) => _$VentaDetalleFromJson(json);

  factory VentaDetalle.fromMap(Map<String, dynamic> map) => VentaDetalle.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}