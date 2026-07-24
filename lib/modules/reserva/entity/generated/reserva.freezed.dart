// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../reserva.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Reserva _$ReservaFromJson(Map<String, dynamic> json) {
  return _Reserva.fromJson(json);
}

/// @nodoc
mixin _$Reserva {
  String get id => throw _privateConstructorUsedError;
  String get idCliente => throw _privateConstructorUsedError;
  DateTime get fechaReserva => throw _privateConstructorUsedError;
  DateTime get fechaVencimiento => throw _privateConstructorUsedError;
  double get adelanto => throw _privateConstructorUsedError;
  ReservaEstado get estado => throw _privateConstructorUsedError;

  /// Serializes this Reserva to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reserva
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservaCopyWith<Reserva> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservaCopyWith<$Res> {
  factory $ReservaCopyWith(Reserva value, $Res Function(Reserva) then) =
      _$ReservaCopyWithImpl<$Res, Reserva>;
  @useResult
  $Res call({
    String id,
    String idCliente,
    DateTime fechaReserva,
    DateTime fechaVencimiento,
    double adelanto,
    ReservaEstado estado,
  });
}

/// @nodoc
class _$ReservaCopyWithImpl<$Res, $Val extends Reserva>
    implements $ReservaCopyWith<$Res> {
  _$ReservaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reserva
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idCliente = null,
    Object? fechaReserva = null,
    Object? fechaVencimiento = null,
    Object? adelanto = null,
    Object? estado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idCliente: null == idCliente
                ? _value.idCliente
                : idCliente // ignore: cast_nullable_to_non_nullable
                      as String,
            fechaReserva: null == fechaReserva
                ? _value.fechaReserva
                : fechaReserva // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fechaVencimiento: null == fechaVencimiento
                ? _value.fechaVencimiento
                : fechaVencimiento // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            adelanto: null == adelanto
                ? _value.adelanto
                : adelanto // ignore: cast_nullable_to_non_nullable
                      as double,
            estado: null == estado
                ? _value.estado
                : estado // ignore: cast_nullable_to_non_nullable
                      as ReservaEstado,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservaImplCopyWith<$Res> implements $ReservaCopyWith<$Res> {
  factory _$$ReservaImplCopyWith(
    _$ReservaImpl value,
    $Res Function(_$ReservaImpl) then,
  ) = __$$ReservaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idCliente,
    DateTime fechaReserva,
    DateTime fechaVencimiento,
    double adelanto,
    ReservaEstado estado,
  });
}

/// @nodoc
class __$$ReservaImplCopyWithImpl<$Res>
    extends _$ReservaCopyWithImpl<$Res, _$ReservaImpl>
    implements _$$ReservaImplCopyWith<$Res> {
  __$$ReservaImplCopyWithImpl(
    _$ReservaImpl _value,
    $Res Function(_$ReservaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reserva
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idCliente = null,
    Object? fechaReserva = null,
    Object? fechaVencimiento = null,
    Object? adelanto = null,
    Object? estado = null,
  }) {
    return _then(
      _$ReservaImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idCliente: null == idCliente
            ? _value.idCliente
            : idCliente // ignore: cast_nullable_to_non_nullable
                  as String,
        fechaReserva: null == fechaReserva
            ? _value.fechaReserva
            : fechaReserva // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fechaVencimiento: null == fechaVencimiento
            ? _value.fechaVencimiento
            : fechaVencimiento // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        adelanto: null == adelanto
            ? _value.adelanto
            : adelanto // ignore: cast_nullable_to_non_nullable
                  as double,
        estado: null == estado
            ? _value.estado
            : estado // ignore: cast_nullable_to_non_nullable
                  as ReservaEstado,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservaImpl extends _Reserva {
  const _$ReservaImpl({
    required this.id,
    required this.idCliente,
    required this.fechaReserva,
    required this.fechaVencimiento,
    required this.adelanto,
    required this.estado,
  }) : super._();

  factory _$ReservaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservaImplFromJson(json);

  @override
  final String id;
  @override
  final String idCliente;
  @override
  final DateTime fechaReserva;
  @override
  final DateTime fechaVencimiento;
  @override
  final double adelanto;
  @override
  final ReservaEstado estado;

  @override
  String toString() {
    return 'Reserva(id: $id, idCliente: $idCliente, fechaReserva: $fechaReserva, fechaVencimiento: $fechaVencimiento, adelanto: $adelanto, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idCliente, idCliente) ||
                other.idCliente == idCliente) &&
            (identical(other.fechaReserva, fechaReserva) ||
                other.fechaReserva == fechaReserva) &&
            (identical(other.fechaVencimiento, fechaVencimiento) ||
                other.fechaVencimiento == fechaVencimiento) &&
            (identical(other.adelanto, adelanto) ||
                other.adelanto == adelanto) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idCliente,
    fechaReserva,
    fechaVencimiento,
    adelanto,
    estado,
  );

  /// Create a copy of Reserva
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservaImplCopyWith<_$ReservaImpl> get copyWith =>
      __$$ReservaImplCopyWithImpl<_$ReservaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservaImplToJson(this);
  }
}

abstract class _Reserva extends Reserva {
  const factory _Reserva({
    required final String id,
    required final String idCliente,
    required final DateTime fechaReserva,
    required final DateTime fechaVencimiento,
    required final double adelanto,
    required final ReservaEstado estado,
  }) = _$ReservaImpl;
  const _Reserva._() : super._();

  factory _Reserva.fromJson(Map<String, dynamic> json) = _$ReservaImpl.fromJson;

  @override
  String get id;
  @override
  String get idCliente;
  @override
  DateTime get fechaReserva;
  @override
  DateTime get fechaVencimiento;
  @override
  double get adelanto;
  @override
  ReservaEstado get estado;

  /// Create a copy of Reserva
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservaImplCopyWith<_$ReservaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
