import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/compra/compra.freezed.dart';
part 'generated/compra/compra.g.dart';

@freezed
class Compra with _$Compra {
  const Compra._();

  const factory Compra({
    required String id,
    required String idProveedor,
    required DateTime fechaCompra,
    required double total,
  }) = _Compra;

  factory Compra.fromJson(Map<String, dynamic> json) => _$CompraFromJson(json);

  factory Compra.fromMap(Map<String, dynamic> map) => Compra.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}