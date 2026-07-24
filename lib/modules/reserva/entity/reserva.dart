import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/reserva.freezed.dart';
part 'generated/reserva.g.dart';

@freezed
class Reserva with _$Reserva {
  const Reserva._();

  const factory Reserva({
    required String id,
    required String idCliente,
    required DateTime fechaReserva,
    required DateTime fechaVencimiento,
    required double adelanto,
    required ReservaEstado estado,
  }) = _Reserva;

  factory Reserva.fromJson(Map<String, dynamic> json) => _$ReservaFromJson(json);

  factory Reserva.fromMap(Map<String, dynamic> map) => Reserva.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

/// Se ha definido un ciclo de vida para las reservas
/// se han dejado dos valores, pendiente y cancelado, de ser
/// necesario se agregaran más estados
enum ReservaEstado {
  pendiente,
  cancelado,
}