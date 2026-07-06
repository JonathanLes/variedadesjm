// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClienteImpl _$$ClienteImplFromJson(Map<String, dynamic> json) =>
    _$ClienteImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      telefono: json['telefono'] as String,
      direccion: json['direccion'] as String?,
    );

Map<String, dynamic> _$$ClienteImplToJson(_$ClienteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
    };
