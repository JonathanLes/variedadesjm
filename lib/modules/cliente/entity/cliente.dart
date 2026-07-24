import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/cliente.freezed.dart';
part 'generated/cliente.g.dart';

@freezed
class Cliente with _$Cliente {
  const Cliente._();

  const factory Cliente({
    required String id,
    required String nombre,
    required String apellido,
    required String telefono,
    String? direccion,
  }) = _Cliente;

  factory Cliente.fromJson(Map<String, dynamic> json) => _$ClienteFromJson(json);

  factory Cliente.fromMap(Map<String, dynamic> map) => Cliente.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}