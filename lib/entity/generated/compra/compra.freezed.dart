// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../compra.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Compra _$CompraFromJson(Map<String, dynamic> json) {
  return _Compra.fromJson(json);
}

/// @nodoc
mixin _$Compra {
  String get id => throw _privateConstructorUsedError;
  String get idProveedor => throw _privateConstructorUsedError;
  DateTime get fechaCompra => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this Compra to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraCopyWith<Compra> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraCopyWith<$Res> {
  factory $CompraCopyWith(Compra value, $Res Function(Compra) then) =
      _$CompraCopyWithImpl<$Res, Compra>;
  @useResult
  $Res call({
    String id,
    String idProveedor,
    DateTime fechaCompra,
    double total,
  });
}

/// @nodoc
class _$CompraCopyWithImpl<$Res, $Val extends Compra>
    implements $CompraCopyWith<$Res> {
  _$CompraCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idProveedor = null,
    Object? fechaCompra = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idProveedor: null == idProveedor
                ? _value.idProveedor
                : idProveedor // ignore: cast_nullable_to_non_nullable
                      as String,
            fechaCompra: null == fechaCompra
                ? _value.fechaCompra
                : fechaCompra // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$CompraImplCopyWith<$Res> implements $CompraCopyWith<$Res> {
  factory _$$CompraImplCopyWith(
    _$CompraImpl value,
    $Res Function(_$CompraImpl) then,
  ) = __$$CompraImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idProveedor,
    DateTime fechaCompra,
    double total,
  });
}

/// @nodoc
class __$$CompraImplCopyWithImpl<$Res>
    extends _$CompraCopyWithImpl<$Res, _$CompraImpl>
    implements _$$CompraImplCopyWith<$Res> {
  __$$CompraImplCopyWithImpl(
    _$CompraImpl _value,
    $Res Function(_$CompraImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idProveedor = null,
    Object? fechaCompra = null,
    Object? total = null,
  }) {
    return _then(
      _$CompraImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idProveedor: null == idProveedor
            ? _value.idProveedor
            : idProveedor // ignore: cast_nullable_to_non_nullable
                  as String,
        fechaCompra: null == fechaCompra
            ? _value.fechaCompra
            : fechaCompra // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$CompraImpl extends _Compra {
  const _$CompraImpl({
    required this.id,
    required this.idProveedor,
    required this.fechaCompra,
    required this.total,
  }) : super._();

  factory _$CompraImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompraImplFromJson(json);

  @override
  final String id;
  @override
  final String idProveedor;
  @override
  final DateTime fechaCompra;
  @override
  final double total;

  @override
  String toString() {
    return 'Compra(id: $id, idProveedor: $idProveedor, fechaCompra: $fechaCompra, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idProveedor, idProveedor) ||
                other.idProveedor == idProveedor) &&
            (identical(other.fechaCompra, fechaCompra) ||
                other.fechaCompra == fechaCompra) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, idProveedor, fechaCompra, total);

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraImplCopyWith<_$CompraImpl> get copyWith =>
      __$$CompraImplCopyWithImpl<_$CompraImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompraImplToJson(this);
  }
}

abstract class _Compra extends Compra {
  const factory _Compra({
    required final String id,
    required final String idProveedor,
    required final DateTime fechaCompra,
    required final double total,
  }) = _$CompraImpl;
  const _Compra._() : super._();

  factory _Compra.fromJson(Map<String, dynamic> json) = _$CompraImpl.fromJson;

  @override
  String get id;
  @override
  String get idProveedor;
  @override
  DateTime get fechaCompra;
  @override
  double get total;

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraImplCopyWith<_$CompraImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
