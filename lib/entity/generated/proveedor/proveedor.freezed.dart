// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../proveedor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Proveedor _$ProveedorFromJson(Map<String, dynamic> json) {
  return _Proveedor.fromJson(json);
}

/// @nodoc
mixin _$Proveedor {
  String get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String get telefono => throw _privateConstructorUsedError;
  String get empresa => throw _privateConstructorUsedError;
  bool get activo => throw _privateConstructorUsedError;

  /// Serializes this Proveedor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Proveedor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProveedorCopyWith<Proveedor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProveedorCopyWith<$Res> {
  factory $ProveedorCopyWith(Proveedor value, $Res Function(Proveedor) then) =
      _$ProveedorCopyWithImpl<$Res, Proveedor>;
  @useResult
  $Res call({
    String id,
    String nombre,
    String telefono,
    String empresa,
    bool activo,
  });
}

/// @nodoc
class _$ProveedorCopyWithImpl<$Res, $Val extends Proveedor>
    implements $ProveedorCopyWith<$Res> {
  _$ProveedorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Proveedor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? telefono = null,
    Object? empresa = null,
    Object? activo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            telefono: null == telefono
                ? _value.telefono
                : telefono // ignore: cast_nullable_to_non_nullable
                      as String,
            empresa: null == empresa
                ? _value.empresa
                : empresa // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProveedorImplCopyWith<$Res>
    implements $ProveedorCopyWith<$Res> {
  factory _$$ProveedorImplCopyWith(
    _$ProveedorImpl value,
    $Res Function(_$ProveedorImpl) then,
  ) = __$$ProveedorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nombre,
    String telefono,
    String empresa,
    bool activo,
  });
}

/// @nodoc
class __$$ProveedorImplCopyWithImpl<$Res>
    extends _$ProveedorCopyWithImpl<$Res, _$ProveedorImpl>
    implements _$$ProveedorImplCopyWith<$Res> {
  __$$ProveedorImplCopyWithImpl(
    _$ProveedorImpl _value,
    $Res Function(_$ProveedorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Proveedor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? telefono = null,
    Object? empresa = null,
    Object? activo = null,
  }) {
    return _then(
      _$ProveedorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        telefono: null == telefono
            ? _value.telefono
            : telefono // ignore: cast_nullable_to_non_nullable
                  as String,
        empresa: null == empresa
            ? _value.empresa
            : empresa // ignore: cast_nullable_to_non_nullable
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
class _$ProveedorImpl extends _Proveedor {
  const _$ProveedorImpl({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.empresa,
    required this.activo,
  }) : super._();

  factory _$ProveedorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProveedorImplFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final String telefono;
  @override
  final String empresa;
  @override
  final bool activo;

  @override
  String toString() {
    return 'Proveedor(id: $id, nombre: $nombre, telefono: $telefono, empresa: $empresa, activo: $activo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProveedorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.empresa, empresa) || other.empresa == empresa) &&
            (identical(other.activo, activo) || other.activo == activo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nombre, telefono, empresa, activo);

  /// Create a copy of Proveedor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProveedorImplCopyWith<_$ProveedorImpl> get copyWith =>
      __$$ProveedorImplCopyWithImpl<_$ProveedorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProveedorImplToJson(this);
  }
}

abstract class _Proveedor extends Proveedor {
  const factory _Proveedor({
    required final String id,
    required final String nombre,
    required final String telefono,
    required final String empresa,
    required final bool activo,
  }) = _$ProveedorImpl;
  const _Proveedor._() : super._();

  factory _Proveedor.fromJson(Map<String, dynamic> json) =
      _$ProveedorImpl.fromJson;

  @override
  String get id;
  @override
  String get nombre;
  @override
  String get telefono;
  @override
  String get empresa;
  @override
  bool get activo;

  /// Create a copy of Proveedor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProveedorImplCopyWith<_$ProveedorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
