// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../venta_detalle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VentaDetalleImpl _$$VentaDetalleImplFromJson(Map<String, dynamic> json) =>
    _$VentaDetalleImpl(
      id: json['id'] as String,
      idVenta: json['idVenta'] as String,
      idInventario: json['idInventario'] as String,
      precioVentaFinal: (json['precioVentaFinal'] as num).toDouble(),
    );

Map<String, dynamic> _$$VentaDetalleImplToJson(_$VentaDetalleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idVenta': instance.idVenta,
      'idInventario': instance.idInventario,
      'precioVentaFinal': instance.precioVentaFinal,
    };
