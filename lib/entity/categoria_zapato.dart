import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/categoria_zapato/categoria_zapato.freezed.dart';
part 'generated/categoria_zapato/categoria_zapato.g.dart';

@freezed
class CategoriaZapato with _$CategoriaZapato {
  const CategoriaZapato._();

  const factory CategoriaZapato({
    required String id,
    required String nombreCategoria,
  }) = _CategoriaZapato;

  factory CategoriaZapato.fromJson(Map<String, dynamic> json) => _$CategoriaZapatoFromJson(json);

  factory CategoriaZapato.fromMap(Map<String, dynamic> map) => CategoriaZapato.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}