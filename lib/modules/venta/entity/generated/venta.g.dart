// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../venta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VentaImpl _$$VentaImplFromJson(Map<String, dynamic> json) => _$VentaImpl(
  id: json['id'] as String,
  idCliente: json['idCliente'] as String,
  fechaVenta: DateTime.parse(json['fechaVenta'] as String),
  metodoPago: json['metodoPago'] as String,
  total: (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$$VentaImplToJson(_$VentaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idCliente': instance.idCliente,
      'fechaVenta': instance.fechaVenta.toIso8601String(),
      'metodoPago': instance.metodoPago,
      'total': instance.total,
    };
