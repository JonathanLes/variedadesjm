// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../proveedor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProveedorImpl _$$ProveedorImplFromJson(Map<String, dynamic> json) =>
    _$ProveedorImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String,
      empresa: json['empresa'] as String,
      activo: json['activo'] as bool,
    );

Map<String, dynamic> _$$ProveedorImplToJson(_$ProveedorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'telefono': instance.telefono,
      'empresa': instance.empresa,
      'activo': instance.activo,
    };
