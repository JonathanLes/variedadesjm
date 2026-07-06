// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../zapato.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ZapatoImpl _$$ZapatoImplFromJson(Map<String, dynamic> json) => _$ZapatoImpl(
  id: json['id'] as String,
  modelo: json['modelo'] as String,
  descripcion: json['descripcion'] as String?,
  idMarca: json['idMarca'] as String,
  idCategoria: json['idCategoria'] as String,
  precioVentaSugerido: (json['precioVentaSugerido'] as num).toDouble(),
  imagenPath: json['imagenPath'] as String?,
);

Map<String, dynamic> _$$ZapatoImplToJson(_$ZapatoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'modelo': instance.modelo,
      'descripcion': instance.descripcion,
      'idMarca': instance.idMarca,
      'idCategoria': instance.idCategoria,
      'precioVentaSugerido': instance.precioVentaSugerido,
      'imagenPath': instance.imagenPath,
    };
