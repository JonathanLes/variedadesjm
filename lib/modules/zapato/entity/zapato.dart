import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/zapato.freezed.dart';
part 'generated/zapato.g.dart';

@freezed
class Zapato with _$Zapato {
  const Zapato._();

  const factory Zapato({
    required String id,
    required String modelo,
    String? descripcion,
    required String idMarca,
    required String idCategoria,
    required double precioVentaSugerido,
    String? imagenPath,
  }) = _Zapato;

  factory Zapato.fromJson(Map<String, dynamic> json) => _$ZapatoFromJson(json);

  factory Zapato.fromMap(Map<String, dynamic> map) => Zapato.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}