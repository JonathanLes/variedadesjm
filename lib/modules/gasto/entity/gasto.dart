import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/gasto.freezed.dart';
part 'generated/gasto.g.dart';

@freezed
class Gasto with _$Gasto {
  const Gasto._();

  const factory Gasto({
    required String id,
    required String descripcion,
    required double monto,
    required DateTime fechaGasto,
    required String idCategoriaGasto,
    required String metodoPago,
  }) = _Gasto;

  factory Gasto.fromJson(Map<String, dynamic> json) => _$GastoFromJson(json);

  factory Gasto.fromMap(Map<String, dynamic> map) => Gasto.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}