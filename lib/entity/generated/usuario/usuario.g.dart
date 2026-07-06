// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsuarioImpl _$$UsuarioImplFromJson(Map<String, dynamic> json) =>
    _$UsuarioImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      pinCifrado: json['pinCifrado'] as String,
      rol: $enumDecode(_$UsuarioRolEnumMap, json['rol']),
    );

Map<String, dynamic> _$$UsuarioImplToJson(_$UsuarioImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'pinCifrado': instance.pinCifrado,
      'rol': _$UsuarioRolEnumMap[instance.rol]!,
    };

const _$UsuarioRolEnumMap = {
  UsuarioRol.admministrador: 'admministrador',
  UsuarioRol.vendedor: 'vendedor',
};
