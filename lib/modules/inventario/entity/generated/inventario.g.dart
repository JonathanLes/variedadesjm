// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../inventario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventarioImpl _$$InventarioImplFromJson(Map<String, dynamic> json) =>
    _$InventarioImpl(
      id: json['id'] as String,
      idZapato: json['idZapato'] as String,
      codigo: json['codigo'] as String,
      talla: (json['talla'] as num).toDouble(),
      cm: (json['cm'] as num).toDouble(),
      color: json['color'] as String?,
      precioCompra: (json['precioCompra'] as num).toDouble(),
      fechaCompra: DateTime.parse(json['fechaCompra'] as String),
      estado: $enumDecode(_$EstadoZapatoEnumMap, json['estado']),
    );

Map<String, dynamic> _$$InventarioImplToJson(_$InventarioImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idZapato': instance.idZapato,
      'codigo': instance.codigo,
      'talla': instance.talla,
      'cm': instance.cm,
      'color': instance.color,
      'precioCompra': instance.precioCompra,
      'fechaCompra': instance.fechaCompra.toIso8601String(),
      'estado': _$EstadoZapatoEnumMap[instance.estado]!,
    };

const _$EstadoZapatoEnumMap = {
  EstadoZapato.activo: 'activo',
  EstadoZapato.reservado: 'reservado',
  EstadoZapato.vendido: 'vendido',
};
