import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/cambio/cambio.freezed.dart';
part 'generated/cambio/cambio.g.dart';

@freezed
class Cambio with _$Cambio {
  const Cambio._();

  const factory Cambio({
    required String id,
    required String idVentaDetalleOriginal,
    required String idInventarioNuevo,
    required String motivo,
    required double montoExcedente,
    required DateTime fecha,
  }) = _Cambio;

  factory Cambio.fromJson(Map<String, dynamic> json) => _$CambioFromJson(json);

  factory Cambio.fromMap(Map<String, dynamic> map) => Cambio.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}