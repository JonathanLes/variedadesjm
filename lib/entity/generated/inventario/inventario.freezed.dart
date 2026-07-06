// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../inventario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Inventario _$InventarioFromJson(Map<String, dynamic> json) {
  return _Inventario.fromJson(json);
}

/// @nodoc
mixin _$Inventario {
  String get id => throw _privateConstructorUsedError;
  String get idZapato => throw _privateConstructorUsedError;
  String get codigo => throw _privateConstructorUsedError;
  double get talla => throw _privateConstructorUsedError;
  double get cm => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  double get precioCompra => throw _privateConstructorUsedError;
  DateTime get fechaCompra => throw _privateConstructorUsedError;
  EstadoZapato get estado => throw _privateConstructorUsedError;

  /// Serializes this Inventario to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Inventario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventarioCopyWith<Inventario> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventarioCopyWith<$Res> {
  factory $InventarioCopyWith(
    Inventario value,
    $Res Function(Inventario) then,
  ) = _$InventarioCopyWithImpl<$Res, Inventario>;
  @useResult
  $Res call({
    String id,
    String idZapato,
    String codigo,
    double talla,
    double cm,
    String? color,
    double precioCompra,
    DateTime fechaCompra,
    EstadoZapato estado,
  });
}

/// @nodoc
class _$InventarioCopyWithImpl<$Res, $Val extends Inventario>
    implements $InventarioCopyWith<$Res> {
  _$InventarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Inventario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idZapato = null,
    Object? codigo = null,
    Object? talla = null,
    Object? cm = null,
    Object? color = freezed,
    Object? precioCompra = null,
    Object? fechaCompra = null,
    Object? estado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idZapato: null == idZapato
                ? _value.idZapato
                : idZapato // ignore: cast_nullable_to_non_nullable
                      as String,
            codigo: null == codigo
                ? _value.codigo
                : codigo // ignore: cast_nullable_to_non_nullable
                      as String,
            talla: null == talla
                ? _value.talla
                : talla // ignore: cast_nullable_to_non_nullable
                      as double,
            cm: null == cm
                ? _value.cm
                : cm // ignore: cast_nullable_to_non_nullable
                      as double,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            precioCompra: null == precioCompra
                ? _value.precioCompra
                : precioCompra // ignore: cast_nullable_to_non_nullable
                      as double,
            fechaCompra: null == fechaCompra
                ? _value.fechaCompra
                : fechaCompra // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            estado: null == estado
                ? _value.estado
                : estado // ignore: cast_nullable_to_non_nullable
                      as EstadoZapato,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventarioImplCopyWith<$Res>
    implements $InventarioCopyWith<$Res> {
  factory _$$InventarioImplCopyWith(
    _$InventarioImpl value,
    $Res Function(_$InventarioImpl) then,
  ) = __$$InventarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idZapato,
    String codigo,
    double talla,
    double cm,
    String? color,
    double precioCompra,
    DateTime fechaCompra,
    EstadoZapato estado,
  });
}

/// @nodoc
class __$$InventarioImplCopyWithImpl<$Res>
    extends _$InventarioCopyWithImpl<$Res, _$InventarioImpl>
    implements _$$InventarioImplCopyWith<$Res> {
  __$$InventarioImplCopyWithImpl(
    _$InventarioImpl _value,
    $Res Function(_$InventarioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Inventario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idZapato = null,
    Object? codigo = null,
    Object? talla = null,
    Object? cm = null,
    Object? color = freezed,
    Object? precioCompra = null,
    Object? fechaCompra = null,
    Object? estado = null,
  }) {
    return _then(
      _$InventarioImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idZapato: null == idZapato
            ? _value.idZapato
            : idZapato // ignore: cast_nullable_to_non_nullable
                  as String,
        codigo: null == codigo
            ? _value.codigo
            : codigo // ignore: cast_nullable_to_non_nullable
                  as String,
        talla: null == talla
            ? _value.talla
            : talla // ignore: cast_nullable_to_non_nullable
                  as double,
        cm: null == cm
            ? _value.cm
            : cm // ignore: cast_nullable_to_non_nullable
                  as double,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        precioCompra: null == precioCompra
            ? _value.precioCompra
            : precioCompra // ignore: cast_nullable_to_non_nullable
                  as double,
        fechaCompra: null == fechaCompra
            ? _value.fechaCompra
            : fechaCompra // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        estado: null == estado
            ? _value.estado
            : estado // ignore: cast_nullable_to_non_nullable
                  as EstadoZapato,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventarioImpl extends _Inventario {
  const _$InventarioImpl({
    required this.id,
    required this.idZapato,
    required this.codigo,
    required this.talla,
    required this.cm,
    this.color,
    required this.precioCompra,
    required this.fechaCompra,
    required this.estado,
  }) : super._();

  factory _$InventarioImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventarioImplFromJson(json);

  @override
  final String id;
  @override
  final String idZapato;
  @override
  final String codigo;
  @override
  final double talla;
  @override
  final double cm;
  @override
  final String? color;
  @override
  final double precioCompra;
  @override
  final DateTime fechaCompra;
  @override
  final EstadoZapato estado;

  @override
  String toString() {
    return 'Inventario(id: $id, idZapato: $idZapato, codigo: $codigo, talla: $talla, cm: $cm, color: $color, precioCompra: $precioCompra, fechaCompra: $fechaCompra, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventarioImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idZapato, idZapato) ||
                other.idZapato == idZapato) &&
            (identical(other.codigo, codigo) || other.codigo == codigo) &&
            (identical(other.talla, talla) || other.talla == talla) &&
            (identical(other.cm, cm) || other.cm == cm) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.precioCompra, precioCompra) ||
                other.precioCompra == precioCompra) &&
            (identical(other.fechaCompra, fechaCompra) ||
                other.fechaCompra == fechaCompra) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idZapato,
    codigo,
    talla,
    cm,
    color,
    precioCompra,
    fechaCompra,
    estado,
  );

  /// Create a copy of Inventario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventarioImplCopyWith<_$InventarioImpl> get copyWith =>
      __$$InventarioImplCopyWithImpl<_$InventarioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventarioImplToJson(this);
  }
}

abstract class _Inventario extends Inventario {
  const factory _Inventario({
    required final String id,
    required final String idZapato,
    required final String codigo,
    required final double talla,
    required final double cm,
    final String? color,
    required final double precioCompra,
    required final DateTime fechaCompra,
    required final EstadoZapato estado,
  }) = _$InventarioImpl;
  const _Inventario._() : super._();

  factory _Inventario.fromJson(Map<String, dynamic> json) =
      _$InventarioImpl.fromJson;

  @override
  String get id;
  @override
  String get idZapato;
  @override
  String get codigo;
  @override
  double get talla;
  @override
  double get cm;
  @override
  String? get color;
  @override
  double get precioCompra;
  @override
  DateTime get fechaCompra;
  @override
  EstadoZapato get estado;

  /// Create a copy of Inventario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventarioImplCopyWith<_$InventarioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
