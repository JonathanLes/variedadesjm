// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../reserva.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservaImpl _$$ReservaImplFromJson(Map<String, dynamic> json) =>
    _$ReservaImpl(
      id: json['id'] as String,
      idCliente: json['idCliente'] as String,
      fechaReserva: DateTime.parse(json['fechaReserva'] as String),
      fechaVencimiento: DateTime.parse(json['fechaVencimiento'] as String),
      adelanto: (json['adelanto'] as num).toDouble(),
      estado: $enumDecode(_$ReservaEstadoEnumMap, json['estado']),
    );

Map<String, dynamic> _$$ReservaImplToJson(_$ReservaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idCliente': instance.idCliente,
      'fechaReserva': instance.fechaReserva.toIso8601String(),
      'fechaVencimiento': instance.fechaVencimiento.toIso8601String(),
      'adelanto': instance.adelanto,
      'estado': _$ReservaEstadoEnumMap[instance.estado]!,
    };

const _$ReservaEstadoEnumMap = {
  ReservaEstado.pendiente: 'pendiente',
  ReservaEstado.cancelado: 'cancelado',
};
