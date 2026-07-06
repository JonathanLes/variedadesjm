import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/categoria_gasto/categoria_gasto.freezed.dart';
part 'generated/categoria_gasto/categoria_gasto.g.dart';

@freezed
class CategoriaGasto with _$CategoriaGasto {
  const CategoriaGasto._();

  const factory CategoriaGasto({
    required String id,
    required String nombreCategoriaGasto,
    required bool activo,
  }) = _CategoriaGasto;

  factory CategoriaGasto.fromJson(Map<String, dynamic> json) => _$CategoriaGastoFromJson(json);

  factory CategoriaGasto.fromMap(Map<String, dynamic> map) {
    return CategoriaGasto(
      id: map['id'] as String,
      nombreCategoriaGasto: map['nombreCategoriaGasto'] as String,
      activo: map['activo'] as bool? ?? map['estado'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCategoriaGasto': nombreCategoriaGasto,
      'estado': activo,
    };
  }
}