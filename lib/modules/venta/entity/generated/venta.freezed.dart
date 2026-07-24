// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../venta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Venta _$VentaFromJson(Map<String, dynamic> json) {
  return _Venta.fromJson(json);
}

/// @nodoc
mixin _$Venta {
  String get id => throw _privateConstructorUsedError;
  String get idCliente => throw _privateConstructorUsedError;
  DateTime get fechaVenta => throw _privateConstructorUsedError;
  String get metodoPago => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this Venta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaCopyWith<Venta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaCopyWith<$Res> {
  factory $VentaCopyWith(Venta value, $Res Function(Venta) then) =
      _$VentaCopyWithImpl<$Res, Venta>;
  @useResult
  $Res call({
    String id,
    String idCliente,
    DateTime fechaVenta,
    String metodoPago,
    double total,
  });
}

/// @nodoc
class _$VentaCopyWithImpl<$Res, $Val extends Venta>
    implements $VentaCopyWith<$Res> {
  _$VentaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idCliente = null,
    Object? fechaVenta = null,
    Object? metodoPago = null,
    Object? total = null,
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
            fechaVenta: null == fechaVenta
                ? _value.fechaVenta
                : fechaVenta // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            metodoPago: null == metodoPago
                ? _value.metodoPago
                : metodoPago // ignore: cast_nullable_to_non_nullable
                      as String,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VentaImplCopyWith<$Res> implements $VentaCopyWith<$Res> {
  factory _$$VentaImplCopyWith(
    _$VentaImpl value,
    $Res Function(_$VentaImpl) then,
  ) = __$$VentaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idCliente,
    DateTime fechaVenta,
    String metodoPago,
    double total,
  });
}

/// @nodoc
class __$$VentaImplCopyWithImpl<$Res>
    extends _$VentaCopyWithImpl<$Res, _$VentaImpl>
    implements _$$VentaImplCopyWith<$Res> {
  __$$VentaImplCopyWithImpl(
    _$VentaImpl _value,
    $Res Function(_$VentaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idCliente = null,
    Object? fechaVenta = null,
    Object? metodoPago = null,
    Object? total = null,
  }) {
    return _then(
      _$VentaImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idCliente: null == idCliente
            ? _value.idCliente
            : idCliente // ignore: cast_nullable_to_non_nullable
                  as String,
        fechaVenta: null == fechaVenta
            ? _value.fechaVenta
            : fechaVenta // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        metodoPago: null == metodoPago
            ? _value.metodoPago
            : metodoPago // ignore: cast_nullable_to_non_nullable
                  as String,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VentaImpl extends _Venta {
  const _$VentaImpl({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.metodoPago,
    required this.total,
  }) : super._();

  factory _$VentaImpl.fromJson(Map<String, dynamic> json) =>
      _$$VentaImplFromJson(json);

  @override
  final String id;
  @override
  final String idCliente;
  @override
  final DateTime fechaVenta;
  @override
  final String metodoPago;
  @override
  final double total;

  @override
  String toString() {
    return 'Venta(id: $id, idCliente: $idCliente, fechaVenta: $fechaVenta, metodoPago: $metodoPago, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idCliente, idCliente) ||
                other.idCliente == idCliente) &&
            (identical(other.fechaVenta, fechaVenta) ||
                other.fechaVenta == fechaVenta) &&
            (identical(other.metodoPago, metodoPago) ||
                other.metodoPago == metodoPago) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, idCliente, fechaVenta, metodoPago, total);

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaImplCopyWith<_$VentaImpl> get copyWith =>
      __$$VentaImplCopyWithImpl<_$VentaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VentaImplToJson(this);
  }
}

abstract class _Venta extends Venta {
  const factory _Venta({
    required final String id,
    required final String idCliente,
    required final DateTime fechaVenta,
    required final String metodoPago,
    required final double total,
  }) = _$VentaImpl;
  const _Venta._() : super._();

  factory _Venta.fromJson(Map<String, dynamic> json) = _$VentaImpl.fromJson;

  @override
  String get id;
  @override
  String get idCliente;
  @override
  DateTime get fechaVenta;
  @override
  String get metodoPago;
  @override
  double get total;

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaImplCopyWith<_$VentaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
