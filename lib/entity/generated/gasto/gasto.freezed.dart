// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../gasto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Gasto _$GastoFromJson(Map<String, dynamic> json) {
  return _Gasto.fromJson(json);
}

/// @nodoc
mixin _$Gasto {
  String get id => throw _privateConstructorUsedError;
  String get descripcion => throw _privateConstructorUsedError;
  double get monto => throw _privateConstructorUsedError;
  DateTime get fechaGasto => throw _privateConstructorUsedError;
  String get idCategoriaGasto => throw _privateConstructorUsedError;
  String get metodoPago => throw _privateConstructorUsedError;

  /// Serializes this Gasto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Gasto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GastoCopyWith<Gasto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GastoCopyWith<$Res> {
  factory $GastoCopyWith(Gasto value, $Res Function(Gasto) then) =
      _$GastoCopyWithImpl<$Res, Gasto>;
  @useResult
  $Res call({
    String id,
    String descripcion,
    double monto,
    DateTime fechaGasto,
    String idCategoriaGasto,
    String metodoPago,
  });
}

/// @nodoc
class _$GastoCopyWithImpl<$Res, $Val extends Gasto>
    implements $GastoCopyWith<$Res> {
  _$GastoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Gasto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? descripcion = null,
    Object? monto = null,
    Object? fechaGasto = null,
    Object? idCategoriaGasto = null,
    Object? metodoPago = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            descripcion: null == descripcion
                ? _value.descripcion
                : descripcion // ignore: cast_nullable_to_non_nullable
                      as String,
            monto: null == monto
                ? _value.monto
                : monto // ignore: cast_nullable_to_non_nullable
                      as double,
            fechaGasto: null == fechaGasto
                ? _value.fechaGasto
                : fechaGasto // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            idCategoriaGasto: null == idCategoriaGasto
                ? _value.idCategoriaGasto
                : idCategoriaGasto // ignore: cast_nullable_to_non_nullable
                      as String,
            metodoPago: null == metodoPago
                ? _value.metodoPago
                : metodoPago // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GastoImplCopyWith<$Res> implements $GastoCopyWith<$Res> {
  factory _$$GastoImplCopyWith(
    _$GastoImpl value,
    $Res Function(_$GastoImpl) then,
  ) = __$$GastoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String descripcion,
    double monto,
    DateTime fechaGasto,
    String idCategoriaGasto,
    String metodoPago,
  });
}

/// @nodoc
class __$$GastoImplCopyWithImpl<$Res>
    extends _$GastoCopyWithImpl<$Res, _$GastoImpl>
    implements _$$GastoImplCopyWith<$Res> {
  __$$GastoImplCopyWithImpl(
    _$GastoImpl _value,
    $Res Function(_$GastoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Gasto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? descripcion = null,
    Object? monto = null,
    Object? fechaGasto = null,
    Object? idCategoriaGasto = null,
    Object? metodoPago = null,
  }) {
    return _then(
      _$GastoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcion: null == descripcion
            ? _value.descripcion
            : descripcion // ignore: cast_nullable_to_non_nullable
                  as String,
        monto: null == monto
            ? _value.monto
            : monto // ignore: cast_nullable_to_non_nullable
                  as double,
        fechaGasto: null == fechaGasto
            ? _value.fechaGasto
            : fechaGasto // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        idCategoriaGasto: null == idCategoriaGasto
            ? _value.idCategoriaGasto
            : idCategoriaGasto // ignore: cast_nullable_to_non_nullable
                  as String,
        metodoPago: null == metodoPago
            ? _value.metodoPago
            : metodoPago // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GastoImpl extends _Gasto {
  const _$GastoImpl({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.fechaGasto,
    required this.idCategoriaGasto,
    required this.metodoPago,
  }) : super._();

  factory _$GastoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GastoImplFromJson(json);

  @override
  final String id;
  @override
  final String descripcion;
  @override
  final double monto;
  @override
  final DateTime fechaGasto;
  @override
  final String idCategoriaGasto;
  @override
  final String metodoPago;

  @override
  String toString() {
    return 'Gasto(id: $id, descripcion: $descripcion, monto: $monto, fechaGasto: $fechaGasto, idCategoriaGasto: $idCategoriaGasto, metodoPago: $metodoPago)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GastoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.monto, monto) || other.monto == monto) &&
            (identical(other.fechaGasto, fechaGasto) ||
                other.fechaGasto == fechaGasto) &&
            (identical(other.idCategoriaGasto, idCategoriaGasto) ||
                other.idCategoriaGasto == idCategoriaGasto) &&
            (identical(other.metodoPago, metodoPago) ||
                other.metodoPago == metodoPago));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    descripcion,
    monto,
    fechaGasto,
    idCategoriaGasto,
    metodoPago,
  );

  /// Create a copy of Gasto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GastoImplCopyWith<_$GastoImpl> get copyWith =>
      __$$GastoImplCopyWithImpl<_$GastoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GastoImplToJson(this);
  }
}

abstract class _Gasto extends Gasto {
  const factory _Gasto({
    required final String id,
    required final String descripcion,
    required final double monto,
    required final DateTime fechaGasto,
    required final String idCategoriaGasto,
    required final String metodoPago,
  }) = _$GastoImpl;
  const _Gasto._() : super._();

  factory _Gasto.fromJson(Map<String, dynamic> json) = _$GastoImpl.fromJson;

  @override
  String get id;
  @override
  String get descripcion;
  @override
  double get monto;
  @override
  DateTime get fechaGasto;
  @override
  String get idCategoriaGasto;
  @override
  String get metodoPago;

  /// Create a copy of Gasto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GastoImplCopyWith<_$GastoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
