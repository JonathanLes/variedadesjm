import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/proveedor.freezed.dart';
part 'generated/proveedor.g.dart';

@freezed
class Proveedor with _$Proveedor {
  const Proveedor._();

  const factory Proveedor({
    required String id,
    required String nombre,
    required String telefono,
    required String empresa,
    required bool activo,
  }) = _Proveedor;

  factory Proveedor.fromJson(Map<String, dynamic> json) => _$ProveedorFromJson(json);

  factory Proveedor.fromMap(Map<String, dynamic> map) => Proveedor.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}