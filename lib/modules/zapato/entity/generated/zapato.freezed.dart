// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../zapato.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Zapato _$ZapatoFromJson(Map<String, dynamic> json) {
  return _Zapato.fromJson(json);
}

/// @nodoc
mixin _$Zapato {
  String get id => throw _privateConstructorUsedError;
  String get modelo => throw _privateConstructorUsedError;
  String? get descripcion => throw _privateConstructorUsedError;
  String get idMarca => throw _privateConstructorUsedError;
  String get idCategoria => throw _privateConstructorUsedError;
  double get precioVentaSugerido => throw _privateConstructorUsedError;
  String? get imagenPath => throw _privateConstructorUsedError;

  /// Serializes this Zapato to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Zapato
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZapatoCopyWith<Zapato> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZapatoCopyWith<$Res> {
  factory $ZapatoCopyWith(Zapato value, $Res Function(Zapato) then) =
      _$ZapatoCopyWithImpl<$Res, Zapato>;
  @useResult
  $Res call({
    String id,
    String modelo,
    String? descripcion,
    String idMarca,
    String idCategoria,
    double precioVentaSugerido,
    String? imagenPath,
  });
}

/// @nodoc
class _$ZapatoCopyWithImpl<$Res, $Val extends Zapato>
    implements $ZapatoCopyWith<$Res> {
  _$ZapatoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Zapato
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? modelo = null,
    Object? descripcion = freezed,
    Object? idMarca = null,
    Object? idCategoria = null,
    Object? precioVentaSugerido = null,
    Object? imagenPath = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            modelo: null == modelo
                ? _value.modelo
                : modelo // ignore: cast_nullable_to_non_nullable
                      as String,
            descripcion: freezed == descripcion
                ? _value.descripcion
                : descripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
            idMarca: null == idMarca
                ? _value.idMarca
                : idMarca // ignore: cast_nullable_to_non_nullable
                      as String,
            idCategoria: null == idCategoria
                ? _value.idCategoria
                : idCategoria // ignore: cast_nullable_to_non_nullable
                      as String,
            precioVentaSugerido: null == precioVentaSugerido
                ? _value.precioVentaSugerido
                : precioVentaSugerido // ignore: cast_nullable_to_non_nullable
                      as double,
            imagenPath: freezed == imagenPath
                ? _value.imagenPath
                : imagenPath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZapatoImplCopyWith<$Res> implements $ZapatoCopyWith<$Res> {
  factory _$$ZapatoImplCopyWith(
    _$ZapatoImpl value,
    $Res Function(_$ZapatoImpl) then,
  ) = __$$ZapatoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String modelo,
    String? descripcion,
    String idMarca,
    String idCategoria,
    double precioVentaSugerido,
    String? imagenPath,
  });
}

/// @nodoc
class __$$ZapatoImplCopyWithImpl<$Res>
    extends _$ZapatoCopyWithImpl<$Res, _$ZapatoImpl>
    implements _$$ZapatoImplCopyWith<$Res> {
  __$$ZapatoImplCopyWithImpl(
    _$ZapatoImpl _value,
    $Res Function(_$ZapatoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Zapato
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? modelo = null,
    Object? descripcion = freezed,
    Object? idMarca = null,
    Object? idCategoria = null,
    Object? precioVentaSugerido = null,
    Object? imagenPath = freezed,
  }) {
    return _then(
      _$ZapatoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        modelo: null == modelo
            ? _value.modelo
            : modelo // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcion: freezed == descripcion
            ? _value.descripcion
            : descripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
        idMarca: null == idMarca
            ? _value.idMarca
            : idMarca // ignore: cast_nullable_to_non_nullable
                  as String,
        idCategoria: null == idCategoria
            ? _value.idCategoria
            : idCategoria // ignore: cast_nullable_to_non_nullable
                  as String,
        precioVentaSugerido: null == precioVentaSugerido
            ? _value.precioVentaSugerido
            : precioVentaSugerido // ignore: cast_nullable_to_non_nullable
                  as double,
        imagenPath: freezed == imagenPath
            ? _value.imagenPath
            : imagenPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZapatoImpl extends _Zapato {
  const _$ZapatoImpl({
    required this.id,
    required this.modelo,
    this.descripcion,
    required this.idMarca,
    required this.idCategoria,
    required this.precioVentaSugerido,
    this.imagenPath,
  }) : super._();

  factory _$ZapatoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZapatoImplFromJson(json);

  @override
  final String id;
  @override
  final String modelo;
  @override
  final String? descripcion;
  @override
  final String idMarca;
  @override
  final String idCategoria;
  @override
  final double precioVentaSugerido;
  @override
  final String? imagenPath;

  @override
  String toString() {
    return 'Zapato(id: $id, modelo: $modelo, descripcion: $descripcion, idMarca: $idMarca, idCategoria: $idCategoria, precioVentaSugerido: $precioVentaSugerido, imagenPath: $imagenPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZapatoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.idMarca, idMarca) || other.idMarca == idMarca) &&
            (identical(other.idCategoria, idCategoria) ||
                other.idCategoria == idCategoria) &&
            (identical(other.precioVentaSugerido, precioVentaSugerido) ||
                other.precioVentaSugerido == precioVentaSugerido) &&
            (identical(other.imagenPath, imagenPath) ||
                other.imagenPath == imagenPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    modelo,
    descripcion,
    idMarca,
    idCategoria,
    precioVentaSugerido,
    imagenPath,
  );

  /// Create a copy of Zapato
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZapatoImplCopyWith<_$ZapatoImpl> get copyWith =>
      __$$ZapatoImplCopyWithImpl<_$ZapatoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZapatoImplToJson(this);
  }
}

abstract class _Zapato extends Zapato {
  const factory _Zapato({
    required final String id,
    required final String modelo,
    final String? descripcion,
    required final String idMarca,
    required final String idCategoria,
    required final double precioVentaSugerido,
    final String? imagenPath,
  }) = _$ZapatoImpl;
  const _Zapato._() : super._();

  factory _Zapato.fromJson(Map<String, dynamic> json) = _$ZapatoImpl.fromJson;

  @override
  String get id;
  @override
  String get modelo;
  @override
  String? get descripcion;
  @override
  String get idMarca;
  @override
  String get idCategoria;
  @override
  double get precioVentaSugerido;
  @override
  String? get imagenPath;

  /// Create a copy of Zapato
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZapatoImplCopyWith<_$ZapatoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
