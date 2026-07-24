// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reserva_detalle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservaDetalleImpl _$$ReservaDetalleImplFromJson(Map<String, dynamic> json) =>
    _$ReservaDetalleImpl(
      id: json['id'] as String,
      idReserva: json['idReserva'] as String,
      idInventario: json['idInventario'] as String,
      precioAcordado: (json['precioAcordado'] as num).toDouble(),
    );

Map<String, dynamic> _$$ReservaDetalleImplToJson(
  _$ReservaDetalleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'idReserva': instance.idReserva,
  'idInventario': instance.idInventario,
  'precioAcordado': instance.precioAcordado,
};
