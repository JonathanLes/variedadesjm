import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/marca.freezed.dart';
part 'generated/marca.g.dart';

@freezed
class Marca with _$Marca {
  const Marca._();

  const factory Marca({
    required String id,
    required String nombreMarca,
  }) = _Marca;

  factory Marca.fromJson(Map<String, dynamic> json) => _$MarcaFromJson(json);

  factory Marca.fromMap(Map<String, dynamic> map) => Marca.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}