// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../gasto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GastoImpl _$$GastoImplFromJson(Map<String, dynamic> json) => _$GastoImpl(
  id: json['id'] as String,
  descripcion: json['descripcion'] as String,
  monto: (json['monto'] as num).toDouble(),
  fechaGasto: DateTime.parse(json['fechaGasto'] as String),
  idCategoriaGasto: json['idCategoriaGasto'] as String,
  metodoPago: json['metodoPago'] as String,
);

Map<String, dynamic> _$$GastoImplToJson(_$GastoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descripcion': instance.descripcion,
      'monto': instance.monto,
      'fechaGasto': instance.fechaGasto.toIso8601String(),
      'idCategoriaGasto': instance.idCategoriaGasto,
      'metodoPago': instance.metodoPago,
    };
