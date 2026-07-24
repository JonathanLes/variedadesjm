// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../compra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompraImpl _$$CompraImplFromJson(Map<String, dynamic> json) => _$CompraImpl(
  id: json['id'] as String,
  idProveedor: json['idProveedor'] as String,
  fechaCompra: DateTime.parse(json['fechaCompra'] as String),
  total: (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$$CompraImplToJson(_$CompraImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idProveedor': instance.idProveedor,
      'fechaCompra': instance.fechaCompra.toIso8601String(),
      'total': instance.total,
    };
