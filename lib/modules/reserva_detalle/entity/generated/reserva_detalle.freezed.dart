// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../reserva_detalle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReservaDetalle _$ReservaDetalleFromJson(Map<String, dynamic> json) {
  return _ReservaDetalle.fromJson(json);
}

/// @nodoc
mixin _$ReservaDetalle {
  String get id => throw _privateConstructorUsedError;
  String get idReserva => throw _privateConstructorUsedError;
  String get idInventario => throw _privateConstructorUsedError;
  double get precioAcordado => throw _privateConstructorUsedError;

  /// Serializes this ReservaDetalle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservaDetalleCopyWith<ReservaDetalle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservaDetalleCopyWith<$Res> {
  factory $ReservaDetalleCopyWith(
    ReservaDetalle value,
    $Res Function(ReservaDetalle) then,
  ) = _$ReservaDetalleCopyWithImpl<$Res, ReservaDetalle>;
  @useResult
  $Res call({
    String id,
    String idReserva,
    String idInventario,
    double precioAcordado,
  });
}

/// @nodoc
class _$ReservaDetalleCopyWithImpl<$Res, $Val extends ReservaDetalle>
    implements $ReservaDetalleCopyWith<$Res> {
  _$ReservaDetalleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idReserva = null,
    Object? idInventario = null,
    Object? precioAcordado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idReserva: null == idReserva
                ? _value.idReserva
                : idReserva // ignore: cast_nullable_to_non_nullable
                      as String,
            idInventario: null == idInventario
                ? _value.idInventario
                : idInventario // ignore: cast_nullable_to_non_nullable
                      as String,
            precioAcordado: null == precioAcordado
                ? _value.precioAcordado
                : precioAcordado // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservaDetalleImplCopyWith<$Res>
    implements $ReservaDetalleCopyWith<$Res> {
  factory _$$ReservaDetalleImplCopyWith(
    _$ReservaDetalleImpl value,
    $Res Function(_$ReservaDetalleImpl) then,
  ) = __$$ReservaDetalleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idReserva,
    String idInventario,
    double precioAcordado,
  });
}

/// @nodoc
class __$$ReservaDetalleImplCopyWithImpl<$Res>
    extends _$ReservaDetalleCopyWithImpl<$Res, _$ReservaDetalleImpl>
    implements _$$ReservaDetalleImplCopyWith<$Res> {
  __$$ReservaDetalleImplCopyWithImpl(
    _$ReservaDetalleImpl _value,
    $Res Function(_$ReservaDetalleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReservaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idReserva = null,
    Object? idInventario = null,
    Object? precioAcordado = null,
  }) {
    return _then(
      _$ReservaDetalleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idReserva: null == idReserva
            ? _value.idReserva
            : idReserva // ignore: cast_nullable_to_non_nullable
                  as String,
        idInventario: null == idInventario
            ? _value.idInventario
            : idInventario // ignore: cast_nullable_to_non_nullable
                  as String,
        precioAcordado: null == precioAcordado
            ? _value.precioAcordado
            : precioAcordado // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservaDetalleImpl extends _ReservaDetalle {
  const _$ReservaDetalleImpl({
    required this.id,
    required this.idReserva,
    required this.idInventario,
    required this.precioAcordado,
  }) : super._();

  factory _$ReservaDetalleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservaDetalleImplFromJson(json);

  @override
  final String id;
  @override
  final String idReserva;
  @override
  final String idInventario;
  @override
  final double precioAcordado;

  @override
  String toString() {
    return 'ReservaDetalle(id: $id, idReserva: $idReserva, idInventario: $idInventario, precioAcordado: $precioAcordado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservaDetalleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idReserva, idReserva) ||
                other.idReserva == idReserva) &&
            (identical(other.idInventario, idInventario) ||
                other.idInventario == idInventario) &&
            (identical(other.precioAcordado, precioAcordado) ||
                other.precioAcordado == precioAcordado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, idReserva, idInventario, precioAcordado);

  /// Create a copy of ReservaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservaDetalleImplCopyWith<_$ReservaDetalleImpl> get copyWith =>
      __$$ReservaDetalleImplCopyWithImpl<_$ReservaDetalleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservaDetalleImplToJson(this);
  }
}

abstract class _ReservaDetalle extends ReservaDetalle {
  const factory _ReservaDetalle({
    required final String id,
    required final String idReserva,
    required final String idInventario,
    required final double precioAcordado,
  }) = _$ReservaDetalleImpl;
  const _ReservaDetalle._() : super._();

  factory _ReservaDetalle.fromJson(Map<String, dynamic> json) =
      _$ReservaDetalleImpl.fromJson;

  @override
  String get id;
  @override
  String get idReserva;
  @override
  String get idInventario;
  @override
  double get precioAcordado;

  /// Create a copy of ReservaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservaDetalleImplCopyWith<_$ReservaDetalleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
