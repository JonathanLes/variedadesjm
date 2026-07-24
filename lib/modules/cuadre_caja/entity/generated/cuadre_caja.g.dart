// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../cuadre_caja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CuadreCajaImpl _$$CuadreCajaImplFromJson(Map<String, dynamic> json) =>
    _$CuadreCajaImpl(
      id: json['id'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      saldoInicial: (json['saldoInicial'] as num).toDouble(),
      totalIngresos: (json['totalIngresos'] as num).toDouble(),
      totalGastos: (json['totalGastos'] as num).toDouble(),
      saldoEsperado: (json['saldoEsperado'] as num).toDouble(),
      saldoFisico: (json['saldoFisico'] as num).toDouble(),
      diferencia: (json['diferencia'] as num).toDouble(),
      idUsuario: json['idUsuario'] as String?,
    );

Map<String, dynamic> _$$CuadreCajaImplToJson(_$CuadreCajaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha.toIso8601String(),
      'saldoInicial': instance.saldoInicial,
      'totalIngresos': instance.totalIngresos,
      'totalGastos': instance.totalGastos,
      'saldoEsperado': instance.saldoEsperado,
      'saldoFisico': instance.saldoFisico,
      'diferencia': instance.diferencia,
      'idUsuario': instance.idUsuario,
    };
