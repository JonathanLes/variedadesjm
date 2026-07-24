// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../categoria_gasto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoriaGasto _$CategoriaGastoFromJson(Map<String, dynamic> json) {
  return _CategoriaGasto.fromJson(json);
}

/// @nodoc
mixin _$CategoriaGasto {
  String get id => throw _privateConstructorUsedError;
  String get nombreCategoriaGasto => throw _privateConstructorUsedError;
  bool get activo => throw _privateConstructorUsedError;

  /// Serializes this CategoriaGasto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoriaGasto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoriaGastoCopyWith<CategoriaGasto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoriaGastoCopyWith<$Res> {
  factory $CategoriaGastoCopyWith(
    CategoriaGasto value,
    $Res Function(CategoriaGasto) then,
  ) = _$CategoriaGastoCopyWithImpl<$Res, CategoriaGasto>;
  @useResult
  $Res call({String id, String nombreCategoriaGasto, bool activo});
}

/// @nodoc
class _$CategoriaGastoCopyWithImpl<$Res, $Val extends CategoriaGasto>
    implements $CategoriaGastoCopyWith<$Res> {
  _$CategoriaGastoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoriaGasto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCategoriaGasto = null,
    Object? activo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombreCategoriaGasto: null == nombreCategoriaGasto
                ? _value.nombreCategoriaGasto
                : nombreCategoriaGasto // ignore: cast_nullable_to_non_nullable
                      as String,
            activo: null == activo
                ? _value.activo
                : activo // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoriaGastoImplCopyWith<$Res>
    implements $CategoriaGastoCopyWith<$Res> {
  factory _$$CategoriaGastoImplCopyWith(
    _$CategoriaGastoImpl value,
    $Res Function(_$CategoriaGastoImpl) then,
  ) = __$$CategoriaGastoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String nombreCategoriaGasto, bool activo});
}

/// @nodoc
class __$$CategoriaGastoImplCopyWithImpl<$Res>
    extends _$CategoriaGastoCopyWithImpl<$Res, _$CategoriaGastoImpl>
    implements _$$CategoriaGastoImplCopyWith<$Res> {
  __$$CategoriaGastoImplCopyWithImpl(
    _$CategoriaGastoImpl _value,
    $Res Function(_$CategoriaGastoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoriaGasto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCategoriaGasto = null,
    Object? activo = null,
  }) {
    return _then(
      _$CategoriaGastoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombreCategoriaGasto: null == nombreCategoriaGasto
            ? _value.nombreCategoriaGasto
            : nombreCategoriaGasto // ignore: cast_nullable_to_non_nullable
                  as String,
        activo: null == activo
            ? _value.activo
            : activo // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoriaGastoImpl extends _CategoriaGasto {
  const _$CategoriaGastoImpl({
    required this.id,
    required this.nombreCategoriaGasto,
    required this.activo,
  }) : super._();

  factory _$CategoriaGastoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoriaGastoImplFromJson(json);

  @override
  final String id;
  @override
  final String nombreCategoriaGasto;
  @override
  final bool activo;

  @override
  String toString() {
    return 'CategoriaGasto(id: $id, nombreCategoriaGasto: $nombreCategoriaGasto, activo: $activo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriaGastoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreCategoriaGasto, nombreCategoriaGasto) ||
                other.nombreCategoriaGasto == nombreCategoriaGasto) &&
            (identical(other.activo, activo) || other.activo == activo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nombreCategoriaGasto, activo);

  /// Create a copy of CategoriaGasto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriaGastoImplCopyWith<_$CategoriaGastoImpl> get copyWith =>
      __$$CategoriaGastoImplCopyWithImpl<_$CategoriaGastoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoriaGastoImplToJson(this);
  }
}

abstract class _CategoriaGasto extends CategoriaGasto {
  const factory _CategoriaGasto({
    required final String id,
    required final String nombreCategoriaGasto,
    required final bool activo,
  }) = _$CategoriaGastoImpl;
  const _CategoriaGasto._() : super._();

  factory _CategoriaGasto.fromJson(Map<String, dynamic> json) =
      _$CategoriaGastoImpl.fromJson;

  @override
  String get id;
  @override
  String get nombreCategoriaGasto;
  @override
  bool get activo;

  /// Create a copy of CategoriaGasto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoriaGastoImplCopyWith<_$CategoriaGastoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
