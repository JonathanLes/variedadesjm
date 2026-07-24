// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../cambio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Cambio _$CambioFromJson(Map<String, dynamic> json) {
  return _Cambio.fromJson(json);
}

/// @nodoc
mixin _$Cambio {
  String get id => throw _privateConstructorUsedError;
  String get idVentaDetalleOriginal => throw _privateConstructorUsedError;
  String get idInventarioNuevo => throw _privateConstructorUsedError;
  String get motivo => throw _privateConstructorUsedError;
  double get montoExcedente => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;

  /// Serializes this Cambio to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cambio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CambioCopyWith<Cambio> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CambioCopyWith<$Res> {
  factory $CambioCopyWith(Cambio value, $Res Function(Cambio) then) =
      _$CambioCopyWithImpl<$Res, Cambio>;
  @useResult
  $Res call({
    String id,
    String idVentaDetalleOriginal,
    String idInventarioNuevo,
    String motivo,
    double montoExcedente,
    DateTime fecha,
  });
}

/// @nodoc
class _$CambioCopyWithImpl<$Res, $Val extends Cambio>
    implements $CambioCopyWith<$Res> {
  _$CambioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cambio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idVentaDetalleOriginal = null,
    Object? idInventarioNuevo = null,
    Object? motivo = null,
    Object? montoExcedente = null,
    Object? fecha = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idVentaDetalleOriginal: null == idVentaDetalleOriginal
                ? _value.idVentaDetalleOriginal
                : idVentaDetalleOriginal // ignore: cast_nullable_to_non_nullable
                      as String,
            idInventarioNuevo: null == idInventarioNuevo
                ? _value.idInventarioNuevo
                : idInventarioNuevo // ignore: cast_nullable_to_non_nullable
                      as String,
            motivo: null == motivo
                ? _value.motivo
                : motivo // ignore: cast_nullable_to_non_nullable
                      as String,
            montoExcedente: null == montoExcedente
                ? _value.montoExcedente
                : montoExcedente // ignore: cast_nullable_to_non_nullable
                      as double,
            fecha: null == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CambioImplCopyWith<$Res> implements $CambioCopyWith<$Res> {
  factory _$$CambioImplCopyWith(
    _$CambioImpl value,
    $Res Function(_$CambioImpl) then,
  ) = __$$CambioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idVentaDetalleOriginal,
    String idInventarioNuevo,
    String motivo,
    double montoExcedente,
    DateTime fecha,
  });
}

/// @nodoc
class __$$CambioImplCopyWithImpl<$Res>
    extends _$CambioCopyWithImpl<$Res, _$CambioImpl>
    implements _$$CambioImplCopyWith<$Res> {
  __$$CambioImplCopyWithImpl(
    _$CambioImpl _value,
    $Res Function(_$CambioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Cambio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idVentaDetalleOriginal = null,
    Object? idInventarioNuevo = null,
    Object? motivo = null,
    Object? montoExcedente = null,
    Object? fecha = null,
  }) {
    return _then(
      _$CambioImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idVentaDetalleOriginal: null == idVentaDetalleOriginal
            ? _value.idVentaDetalleOriginal
            : idVentaDetalleOriginal // ignore: cast_nullable_to_non_nullable
                  as String,
        idInventarioNuevo: null == idInventarioNuevo
            ? _value.idInventarioNuevo
            : idInventarioNuevo // ignore: cast_nullable_to_non_nullable
                  as String,
        motivo: null == motivo
            ? _value.motivo
            : motivo // ignore: cast_nullable_to_non_nullable
                  as String,
        montoExcedente: null == montoExcedente
            ? _value.montoExcedente
            : montoExcedente // ignore: cast_nullable_to_non_nullable
                  as double,
        fecha: null == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CambioImpl extends _Cambio {
  const _$CambioImpl({
    required this.id,
    required this.idVentaDetalleOriginal,
    required this.idInventarioNuevo,
    required this.motivo,
    required this.montoExcedente,
    required this.fecha,
  }) : super._();

  factory _$CambioImpl.fromJson(Map<String, dynamic> json) =>
      _$$CambioImplFromJson(json);

  @override
  final String id;
  @override
  final String idVentaDetalleOriginal;
  @override
  final String idInventarioNuevo;
  @override
  final String motivo;
  @override
  final double montoExcedente;
  @override
  final DateTime fecha;

  @override
  String toString() {
    return 'Cambio(id: $id, idVentaDetalleOriginal: $idVentaDetalleOriginal, idInventarioNuevo: $idInventarioNuevo, motivo: $motivo, montoExcedente: $montoExcedente, fecha: $fecha)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CambioImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idVentaDetalleOriginal, idVentaDetalleOriginal) ||
                other.idVentaDetalleOriginal == idVentaDetalleOriginal) &&
            (identical(other.idInventarioNuevo, idInventarioNuevo) ||
                other.idInventarioNuevo == idInventarioNuevo) &&
            (identical(other.motivo, motivo) || other.motivo == motivo) &&
            (identical(other.montoExcedente, montoExcedente) ||
                other.montoExcedente == montoExcedente) &&
            (identical(other.fecha, fecha) || other.fecha == fecha));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idVentaDetalleOriginal,
    idInventarioNuevo,
    motivo,
    montoExcedente,
    fecha,
  );

  /// Create a copy of Cambio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CambioImplCopyWith<_$CambioImpl> get copyWith =>
      __$$CambioImplCopyWithImpl<_$CambioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CambioImplToJson(this);
  }
}

abstract class _Cambio extends Cambio {
  const factory _Cambio({
    required final String id,
    required final String idVentaDetalleOriginal,
    required final String idInventarioNuevo,
    required final String motivo,
    required final double montoExcedente,
    required final DateTime fecha,
  }) = _$CambioImpl;
  const _Cambio._() : super._();

  factory _Cambio.fromJson(Map<String, dynamic> json) = _$CambioImpl.fromJson;

  @override
  String get id;
  @override
  String get idVentaDetalleOriginal;
  @override
  String get idInventarioNuevo;
  @override
  String get motivo;
  @override
  double get montoExcedente;
  @override
  DateTime get fecha;

  /// Create a copy of Cambio
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CambioImplCopyWith<_$CambioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
