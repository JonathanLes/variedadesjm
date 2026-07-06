// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../cuadre_caja.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CuadreCaja _$CuadreCajaFromJson(Map<String, dynamic> json) {
  return _CuadreCaja.fromJson(json);
}

/// @nodoc
mixin _$CuadreCaja {
  String get id => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;
  double get saldoInicial => throw _privateConstructorUsedError;
  double get totalIngresos => throw _privateConstructorUsedError;
  double get totalGastos => throw _privateConstructorUsedError;
  double get saldoEsperado => throw _privateConstructorUsedError;
  double get saldoFisico => throw _privateConstructorUsedError;
  double get diferencia => throw _privateConstructorUsedError;
  String? get idUsuario => throw _privateConstructorUsedError;

  /// Serializes this CuadreCaja to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CuadreCaja
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CuadreCajaCopyWith<CuadreCaja> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CuadreCajaCopyWith<$Res> {
  factory $CuadreCajaCopyWith(
    CuadreCaja value,
    $Res Function(CuadreCaja) then,
  ) = _$CuadreCajaCopyWithImpl<$Res, CuadreCaja>;
  @useResult
  $Res call({
    String id,
    DateTime fecha,
    double saldoInicial,
    double totalIngresos,
    double totalGastos,
    double saldoEsperado,
    double saldoFisico,
    double diferencia,
    String? idUsuario,
  });
}

/// @nodoc
class _$CuadreCajaCopyWithImpl<$Res, $Val extends CuadreCaja>
    implements $CuadreCajaCopyWith<$Res> {
  _$CuadreCajaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CuadreCaja
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? saldoInicial = null,
    Object? totalIngresos = null,
    Object? totalGastos = null,
    Object? saldoEsperado = null,
    Object? saldoFisico = null,
    Object? diferencia = null,
    Object? idUsuario = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fecha: null == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            saldoInicial: null == saldoInicial
                ? _value.saldoInicial
                : saldoInicial // ignore: cast_nullable_to_non_nullable
                      as double,
            totalIngresos: null == totalIngresos
                ? _value.totalIngresos
                : totalIngresos // ignore: cast_nullable_to_non_nullable
                      as double,
            totalGastos: null == totalGastos
                ? _value.totalGastos
                : totalGastos // ignore: cast_nullable_to_non_nullable
                      as double,
            saldoEsperado: null == saldoEsperado
                ? _value.saldoEsperado
                : saldoEsperado // ignore: cast_nullable_to_non_nullable
                      as double,
            saldoFisico: null == saldoFisico
                ? _value.saldoFisico
                : saldoFisico // ignore: cast_nullable_to_non_nullable
                      as double,
            diferencia: null == diferencia
                ? _value.diferencia
                : diferencia // ignore: cast_nullable_to_non_nullable
                      as double,
            idUsuario: freezed == idUsuario
                ? _value.idUsuario
                : idUsuario // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CuadreCajaImplCopyWith<$Res>
    implements $CuadreCajaCopyWith<$Res> {
  factory _$$CuadreCajaImplCopyWith(
    _$CuadreCajaImpl value,
    $Res Function(_$CuadreCajaImpl) then,
  ) = __$$CuadreCajaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime fecha,
    double saldoInicial,
    double totalIngresos,
    double totalGastos,
    double saldoEsperado,
    double saldoFisico,
    double diferencia,
    String? idUsuario,
  });
}

/// @nodoc
class __$$CuadreCajaImplCopyWithImpl<$Res>
    extends _$CuadreCajaCopyWithImpl<$Res, _$CuadreCajaImpl>
    implements _$$CuadreCajaImplCopyWith<$Res> {
  __$$CuadreCajaImplCopyWithImpl(
    _$CuadreCajaImpl _value,
    $Res Function(_$CuadreCajaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CuadreCaja
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? saldoInicial = null,
    Object? totalIngresos = null,
    Object? totalGastos = null,
    Object? saldoEsperado = null,
    Object? saldoFisico = null,
    Object? diferencia = null,
    Object? idUsuario = freezed,
  }) {
    return _then(
      _$CuadreCajaImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fecha: null == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        saldoInicial: null == saldoInicial
            ? _value.saldoInicial
            : saldoInicial // ignore: cast_nullable_to_non_nullable
                  as double,
        totalIngresos: null == totalIngresos
            ? _value.totalIngresos
            : totalIngresos // ignore: cast_nullable_to_non_nullable
                  as double,
        totalGastos: null == totalGastos
            ? _value.totalGastos
            : totalGastos // ignore: cast_nullable_to_non_nullable
                  as double,
        saldoEsperado: null == saldoEsperado
            ? _value.saldoEsperado
            : saldoEsperado // ignore: cast_nullable_to_non_nullable
                  as double,
        saldoFisico: null == saldoFisico
            ? _value.saldoFisico
            : saldoFisico // ignore: cast_nullable_to_non_nullable
                  as double,
        diferencia: null == diferencia
            ? _value.diferencia
            : diferencia // ignore: cast_nullable_to_non_nullable
                  as double,
        idUsuario: freezed == idUsuario
            ? _value.idUsuario
            : idUsuario // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CuadreCajaImpl extends _CuadreCaja {
  const _$CuadreCajaImpl({
    required this.id,
    required this.fecha,
    required this.saldoInicial,
    required this.totalIngresos,
    required this.totalGastos,
    required this.saldoEsperado,
    required this.saldoFisico,
    required this.diferencia,
    this.idUsuario,
  }) : super._();

  factory _$CuadreCajaImpl.fromJson(Map<String, dynamic> json) =>
      _$$CuadreCajaImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime fecha;
  @override
  final double saldoInicial;
  @override
  final double totalIngresos;
  @override
  final double totalGastos;
  @override
  final double saldoEsperado;
  @override
  final double saldoFisico;
  @override
  final double diferencia;
  @override
  final String? idUsuario;

  @override
  String toString() {
    return 'CuadreCaja(id: $id, fecha: $fecha, saldoInicial: $saldoInicial, totalIngresos: $totalIngresos, totalGastos: $totalGastos, saldoEsperado: $saldoEsperado, saldoFisico: $saldoFisico, diferencia: $diferencia, idUsuario: $idUsuario)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CuadreCajaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.saldoInicial, saldoInicial) ||
                other.saldoInicial == saldoInicial) &&
            (identical(other.totalIngresos, totalIngresos) ||
                other.totalIngresos == totalIngresos) &&
            (identical(other.totalGastos, totalGastos) ||
                other.totalGastos == totalGastos) &&
            (identical(other.saldoEsperado, saldoEsperado) ||
                other.saldoEsperado == saldoEsperado) &&
            (identical(other.saldoFisico, saldoFisico) ||
                other.saldoFisico == saldoFisico) &&
            (identical(other.diferencia, diferencia) ||
                other.diferencia == diferencia) &&
            (identical(other.idUsuario, idUsuario) ||
                other.idUsuario == idUsuario));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fecha,
    saldoInicial,
    totalIngresos,
    totalGastos,
    saldoEsperado,
    saldoFisico,
    diferencia,
    idUsuario,
  );

  /// Create a copy of CuadreCaja
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CuadreCajaImplCopyWith<_$CuadreCajaImpl> get copyWith =>
      __$$CuadreCajaImplCopyWithImpl<_$CuadreCajaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CuadreCajaImplToJson(this);
  }
}

abstract class _CuadreCaja extends CuadreCaja {
  const factory _CuadreCaja({
    required final String id,
    required final DateTime fecha,
    required final double saldoInicial,
    required final double totalIngresos,
    required final double totalGastos,
    required final double saldoEsperado,
    required final double saldoFisico,
    required final double diferencia,
    final String? idUsuario,
  }) = _$CuadreCajaImpl;
  const _CuadreCaja._() : super._();

  factory _CuadreCaja.fromJson(Map<String, dynamic> json) =
      _$CuadreCajaImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get fecha;
  @override
  double get saldoInicial;
  @override
  double get totalIngresos;
  @override
  double get totalGastos;
  @override
  double get saldoEsperado;
  @override
  double get saldoFisico;
  @override
  double get diferencia;
  @override
  String? get idUsuario;

  /// Create a copy of CuadreCaja
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CuadreCajaImplCopyWith<_$CuadreCajaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
