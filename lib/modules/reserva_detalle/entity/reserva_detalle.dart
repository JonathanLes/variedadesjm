import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/reserva_detalle.freezed.dart';
part 'generated/reserva_detalle.g.dart';

@freezed
class ReservaDetalle with _$ReservaDetalle {
  const ReservaDetalle._();

  const factory ReservaDetalle({
    required String id,
    required String idReserva,
    required String idInventario,
    required double precioAcordado,
  }) = _ReservaDetalle;

  factory ReservaDetalle.fromJson(Map<String, dynamic> json) => _$ReservaDetalleFromJson(json);

  factory ReservaDetalle.fromMap(Map<String, dynamic> map) => ReservaDetalle.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}