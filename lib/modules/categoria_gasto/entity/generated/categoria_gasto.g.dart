// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../categoria_gasto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoriaGastoImpl _$$CategoriaGastoImplFromJson(Map<String, dynamic> json) =>
    _$CategoriaGastoImpl(
      id: json['id'] as String,
      nombreCategoriaGasto: json['nombreCategoriaGasto'] as String,
      activo: json['activo'] as bool,
    );

Map<String, dynamic> _$$CategoriaGastoImplToJson(
  _$CategoriaGastoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nombreCategoriaGasto': instance.nombreCategoriaGasto,
  'activo': instance.activo,
};
