// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../categoria_zapato.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoriaZapato _$CategoriaZapatoFromJson(Map<String, dynamic> json) {
  return _CategoriaZapato.fromJson(json);
}

/// @nodoc
mixin _$CategoriaZapato {
  String get id => throw _privateConstructorUsedError;
  String get nombreCategoria => throw _privateConstructorUsedError;

  /// Serializes this CategoriaZapato to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoriaZapato
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoriaZapatoCopyWith<CategoriaZapato> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoriaZapatoCopyWith<$Res> {
  factory $CategoriaZapatoCopyWith(
    CategoriaZapato value,
    $Res Function(CategoriaZapato) then,
  ) = _$CategoriaZapatoCopyWithImpl<$Res, CategoriaZapato>;
  @useResult
  $Res call({String id, String nombreCategoria});
}

/// @nodoc
class _$CategoriaZapatoCopyWithImpl<$Res, $Val extends CategoriaZapato>
    implements $CategoriaZapatoCopyWith<$Res> {
  _$CategoriaZapatoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoriaZapato
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nombreCategoria = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombreCategoria: null == nombreCategoria
                ? _value.nombreCategoria
                : nombreCategoria // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoriaZapatoImplCopyWith<$Res>
    implements $CategoriaZapatoCopyWith<$Res> {
  factory _$$CategoriaZapatoImplCopyWith(
    _$CategoriaZapatoImpl value,
    $Res Function(_$CategoriaZapatoImpl) then,
  ) = __$$CategoriaZapatoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String nombreCategoria});
}

/// @nodoc
class __$$CategoriaZapatoImplCopyWithImpl<$Res>
    extends _$CategoriaZapatoCopyWithImpl<$Res, _$CategoriaZapatoImpl>
    implements _$$CategoriaZapatoImplCopyWith<$Res> {
  __$$CategoriaZapatoImplCopyWithImpl(
    _$CategoriaZapatoImpl _value,
    $Res Function(_$CategoriaZapatoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoriaZapato
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nombreCategoria = null}) {
    return _then(
      _$CategoriaZapatoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombreCategoria: null == nombreCategoria
            ? _value.nombreCategoria
            : nombreCategoria // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoriaZapatoImpl extends _CategoriaZapato {
  const _$CategoriaZapatoImpl({required this.id, required this.nombreCategoria})
    : super._();

  factory _$CategoriaZapatoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoriaZapatoImplFromJson(json);

  @override
  final String id;
  @override
  final String nombreCategoria;

  @override
  String toString() {
    return 'CategoriaZapato(id: $id, nombreCategoria: $nombreCategoria)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriaZapatoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreCategoria, nombreCategoria) ||
                other.nombreCategoria == nombreCategoria));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombreCategoria);

  /// Create a copy of CategoriaZapato
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriaZapatoImplCopyWith<_$CategoriaZapatoImpl> get copyWith =>
      __$$CategoriaZapatoImplCopyWithImpl<_$CategoriaZapatoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoriaZapatoImplToJson(this);
  }
}

abstract class _CategoriaZapato extends CategoriaZapato {
  const factory _CategoriaZapato({
    required final String id,
    required final String nombreCategoria,
  }) = _$CategoriaZapatoImpl;
  const _CategoriaZapato._() : super._();

  factory _CategoriaZapato.fromJson(Map<String, dynamic> json) =
      _$CategoriaZapatoImpl.fromJson;

  @override
  String get id;
  @override
  String get nombreCategoria;

  /// Create a copy of CategoriaZapato
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoriaZapatoImplCopyWith<_$CategoriaZapatoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
