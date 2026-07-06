import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/cuadre_caja/cuadre_caja.freezed.dart';
part 'generated/cuadre_caja/cuadre_caja.g.dart';

@freezed
class CuadreCaja with _$CuadreCaja {
  const CuadreCaja._();

  const factory CuadreCaja({
    required String id,
    required DateTime fecha,
    required double saldoInicial,
    required double totalIngresos,
    required double totalGastos,
    required double saldoEsperado,
    required double saldoFisico,
    required double diferencia,
    String? idUsuario,
  }) = _CuadreCaja;

  factory CuadreCaja.fromJson(Map<String, dynamic> json) => _$CuadreCajaFromJson(json);

  factory CuadreCaja.fromMap(Map<String, dynamic> map) => CuadreCaja.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}