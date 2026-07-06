// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../venta_detalle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VentaDetalle _$VentaDetalleFromJson(Map<String, dynamic> json) {
  return _VentaDetalle.fromJson(json);
}

/// @nodoc
mixin _$VentaDetalle {
  String get id => throw _privateConstructorUsedError;
  String get idVenta => throw _privateConstructorUsedError;
  String get idInventario => throw _privateConstructorUsedError;
  double get precioVentaFinal => throw _privateConstructorUsedError;

  /// Serializes this VentaDetalle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VentaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaDetalleCopyWith<VentaDetalle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaDetalleCopyWith<$Res> {
  factory $VentaDetalleCopyWith(
    VentaDetalle value,
    $Res Function(VentaDetalle) then,
  ) = _$VentaDetalleCopyWithImpl<$Res, VentaDetalle>;
  @useResult
  $Res call({
    String id,
    String idVenta,
    String idInventario,
    double precioVentaFinal,
  });
}

/// @nodoc
class _$VentaDetalleCopyWithImpl<$Res, $Val extends VentaDetalle>
    implements $VentaDetalleCopyWith<$Res> {
  _$VentaDetalleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VentaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idVenta = null,
    Object? idInventario = null,
    Object? precioVentaFinal = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idVenta: null == idVenta
                ? _value.idVenta
                : idVenta // ignore: cast_nullable_to_non_nullable
                      as String,
            idInventario: null == idInventario
                ? _value.idInventario
                : idInventario // ignore: cast_nullable_to_non_nullable
                      as String,
            precioVentaFinal: null == precioVentaFinal
                ? _value.precioVentaFinal
                : precioVentaFinal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VentaDetalleImplCopyWith<$Res>
    implements $VentaDetalleCopyWith<$Res> {
  factory _$$VentaDetalleImplCopyWith(
    _$VentaDetalleImpl value,
    $Res Function(_$VentaDetalleImpl) then,
  ) = __$$VentaDetalleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idVenta,
    String idInventario,
    double precioVentaFinal,
  });
}

/// @nodoc
class __$$VentaDetalleImplCopyWithImpl<$Res>
    extends _$VentaDetalleCopyWithImpl<$Res, _$VentaDetalleImpl>
    implements _$$VentaDetalleImplCopyWith<$Res> {
  __$$VentaDetalleImplCopyWithImpl(
    _$VentaDetalleImpl _value,
    $Res Function(_$VentaDetalleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VentaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idVenta = null,
    Object? idInventario = null,
    Object? precioVentaFinal = null,
  }) {
    return _then(
      _$VentaDetalleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idVenta: null == idVenta
            ? _value.idVenta
            : idVenta // ignore: cast_nullable_to_non_nullable
                  as String,
        idInventario: null == idInventario
            ? _value.idInventario
            : idInventario // ignore: cast_nullable_to_non_nullable
                  as String,
        precioVentaFinal: null == precioVentaFinal
            ? _value.precioVentaFinal
            : precioVentaFinal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VentaDetalleImpl extends _VentaDetalle {
  const _$VentaDetalleImpl({
    required this.id,
    required this.idVenta,
    required this.idInventario,
    required this.precioVentaFinal,
  }) : super._();

  factory _$VentaDetalleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VentaDetalleImplFromJson(json);

  @override
  final String id;
  @override
  final String idVenta;
  @override
  final String idInventario;
  @override
  final double precioVentaFinal;

  @override
  String toString() {
    return 'VentaDetalle(id: $id, idVenta: $idVenta, idInventario: $idInventario, precioVentaFinal: $precioVentaFinal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaDetalleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idVenta, idVenta) || other.idVenta == idVenta) &&
            (identical(other.idInventario, idInventario) ||
                other.idInventario == idInventario) &&
            (identical(other.precioVentaFinal, precioVentaFinal) ||
                other.precioVentaFinal == precioVentaFinal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, idVenta, idInventario, precioVentaFinal);

  /// Create a copy of VentaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaDetalleImplCopyWith<_$VentaDetalleImpl> get copyWith =>
      __$$VentaDetalleImplCopyWithImpl<_$VentaDetalleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VentaDetalleImplToJson(this);
  }
}

abstract class _VentaDetalle extends VentaDetalle {
  const factory _VentaDetalle({
    required final String id,
    required final String idVenta,
    required final String idInventario,
    required final double precioVentaFinal,
  }) = _$VentaDetalleImpl;
  const _VentaDetalle._() : super._();

  factory _VentaDetalle.fromJson(Map<String, dynamic> json) =
      _$VentaDetalleImpl.fromJson;

  @override
  String get id;
  @override
  String get idVenta;
  @override
  String get idInventario;
  @override
  double get precioVentaFinal;

  /// Create a copy of VentaDetalle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaDetalleImplCopyWith<_$VentaDetalleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
