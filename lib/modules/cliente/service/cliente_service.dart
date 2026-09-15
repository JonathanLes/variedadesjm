import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/cliente/control/cliente_dao.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

// --- EXCEPCIONES DE DOMINIO ---
class ClientDataRequiredException implements Exception {
  final String mensaje = "El nombre, apellido y teléfono son obligatorios";
  @override String toString() => mensaje;
}

class ClientPhoneAlreadyExistsException implements Exception {
  final String mensaje = "Ya existe un cliente registrado con este número de teléfono";
  @override String toString() => mensaje;
}

class ClientNotFoundException implements Exception {
  final String mensaje = "No existe un cliente con ese ID o ya fue eliminado";
  @override String toString() => mensaje;
}

class ClientInUseException implements Exception {
  final String mensaje = "No se puede eliminar el cliente porque tiene ventas/registros asociados";
  @override String toString() => mensaje;
}

/// Normaliza textos eliminando espacios extra y capitalizando la primera letra
String normalizeName(String text) {
  if (text.trim().isEmpty) return '';
  final cleanText = text.trim().replaceAll(RegExp(r"\s+"), " ");
  return cleanText[0].toUpperCase() + cleanText.substring(1).toLowerCase();
}

class ClienteService {
  final ClienteDAO _clienteDao;
  final Future<bool> Function(String clienteId) _checkClientInUse;

  ClienteService({
    required ClienteDAO clienteDao,
    required Future<bool> Function(String clienteId) checkClientInUse,
  }) : _clienteDao = clienteDao,
       _checkClientInUse = checkClientInUse;

  void _validateData(String nombre, String apellido, String telefono) {
    if (nombre.isEmpty || apellido.isEmpty || telefono.trim().isEmpty) {
      throw ClientDataRequiredException();
    }
  }

  /// Verifica si el teléfono ya está registrado (excluyendo el id actual si es una actualización)
  Future<bool> _isPhoneDuplicate(String telefono, {String? excludeId}) async {
    final allClients = await _clienteDao.findRange();
    return allClients.any(
      (cliente) => cliente.telefono == telefono.trim() && cliente.id != excludeId,
    );
  }

  Future<Cliente> crearCliente({
    required String id, 
    required String nombre, 
    required String apellido, 
    required String telefono, 
    String? direccion,
  }) async {
    final normNombre = normalizeName(nombre);
    final normApellido = normalizeName(apellido);
    _validateData(normNombre, normApellido, telefono);

    if (await _isPhoneDuplicate(telefono)) {
      throw ClientPhoneAlreadyExistsException();
    }

    final nuevoCliente = Cliente(
      id: id, 
      nombre: normNombre, 
      apellido: normApellido, 
      telefono: telefono.trim(),
      direccion: direccion?.trim(),
    );
    
    await _clienteDao.put(id, nuevoCliente);
    return nuevoCliente;
  }

  Future<Cliente> actualizarCliente({
    required String id, 
    required String nombre, 
    required String apellido, 
    required String telefono, 
    String? direccion,
  }) async {
    final clienteExistente = await _clienteDao.findById(id);
    if (clienteExistente == null) throw ClientNotFoundException();

    final normNombre = normalizeName(nombre);
    final normApellido = normalizeName(apellido);
    _validateData(normNombre, normApellido, telefono);

    if (await _isPhoneDuplicate(telefono, excludeId: id)) {
      throw ClientPhoneAlreadyExistsException();
    }

    final clienteActualizado = clienteExistente.copyWith(
      nombre: normNombre,
      apellido: normApellido,
      telefono: telefono.trim(),
      direccion: direccion?.trim(),
    );
    
    await _clienteDao.put(id, clienteActualizado);
    return clienteActualizado;
  }

  Future<void> eliminarCliente(String id) async {
    final clienteExistente = await _clienteDao.findById(id);
    if (clienteExistente == null) throw ClientNotFoundException();

    final isInUse = await _checkClientInUse(id);
    if (isInUse) throw ClientInUseException();

    await _clienteDao.delete(id);
  }

  Future<(List<Cliente>, int)> obtenerClientesPaginados(FilterParams params) async {
    final results = await Future.wait([
      _clienteDao.obtenerClientesConFiltros(params),
      _clienteDao.contarClientesConFiltros(params),
    ]);
    return (results[0] as List<Cliente>, results[1] as int);
  }
}