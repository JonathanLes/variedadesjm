// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../cambio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CambioImpl _$$CambioImplFromJson(Map<String, dynamic> json) => _$CambioImpl(
  id: json['id'] as String,
  idVentaDetalleOriginal: json['idVentaDetalleOriginal'] as String,
  idInventarioNuevo: json['idInventarioNuevo'] as String,
  motivo: json['motivo'] as String,
  montoExcedente: (json['montoExcedente'] as num).toDouble(),
  fecha: DateTime.parse(json['fecha'] as String),
);

Map<String, dynamic> _$$CambioImplToJson(_$CambioImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idVentaDetalleOriginal': instance.idVentaDetalleOriginal,
      'idInventarioNuevo': instance.idInventarioNuevo,
      'motivo': instance.motivo,
      'montoExcedente': instance.montoExcedente,
      'fecha': instance.fecha.toIso8601String(),
    };
