import 'dart:math';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/inventario/control/inventario_dao.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class InventarioZapatoNotFoundException implements Exception {
  final String mensaje = "El zapato seleccionado no existe en el sistema";
  @override String toString() => mensaje;
}

class InventarioInvalidPriceException implements Exception {
  final String mensaje = "El precio de compra debe ser estrictamente mayor a cero";
  @override String toString() => mensaje;
}

class InventarioInvalidTallaException implements Exception {
  final String mensaje = "La talla debe ser un número positivo mayor a cero";
  @override String toString() => mensaje;
}

class InventarioInvalidCmException implements Exception {
  final String mensaje = "Los centímetros (cm) deben ser un valor positivo mayor a cero";
  @override String toString() => mensaje;
}

class InventarioFutureDateException implements Exception {
  final String mensaje = "La fecha de compra no puede ser una fecha futura";
  @override String toString() => mensaje;
}

class InventarioColorTooLongException implements Exception {
  final String mensaje = "El nombre del color no puede exceder los 30 caracteres";
  @override String toString() => mensaje;
}

class InventarioNotFoundException implements Exception {
  final String mensaje = "El ítem de inventario no existe o fue eliminado";
  @override String toString() => mensaje;
}

class InventarioCannotDeleteReservedOrSoldException implements Exception {
  final String mensaje = "No se pueden eliminar zapatos en estado reservado o vendido";
  @override String toString() => mensaje;
}

class InventarioCodeGenerationException implements Exception {
  final String mensaje = "No se pudo generar un código único de inventario. Intente de nuevo";
  @override String toString() => mensaje;
}

class InventarioService {
  final InventarioDAO _inventarioDao;
  final Future<bool> Function(String zapatoId) _checkZapatoExists;

  InventarioService({
    required InventarioDAO inventarioDao,
    required Future<bool> Function(String zapatoId) checkZapatoExists,
  })  : _inventarioDao = inventarioDao,
        _checkZapatoExists = checkZapatoExists;

  /// Genera una cadena de texto estructurada para ser utilizada como código único de inventario.
  /// 
  /// Formatea la `fechaCompra` extrayendo año, mes y día de forma numérica estandarizada en 8 dígitos.
  /// Convierte el `precioCompra` a un entero multiplicándolo por 100 para eliminar separadores decimales.
  /// Genera una secuencia aleatoria de 4 dígitos apoyándose en la clase `Random`.
  /// Ensambla y retorna una cadena representativa con la estructura `INV-YYYYMMDD-PRECIO-XXXX`.
  String _generarCodigoUnico(DateTime fechaCompra, double precioCompra) {
    final year = fechaCompra.year.toString();
    final month = fechaCompra.month.toString().padLeft(2, '0');
    final day = fechaCompra.day.toString().padLeft(2, '0');
    final fechaStr = '$year$month$day';

    final precioClean = (precioCompra * 100).toInt().toString();

    final random = Random();
    final randomDigits = (1000 + random.nextInt(9000)).toString();

    return 'INV-$fechaStr-$precioClean-$randomDigits';
  }

  /// Valida el cumplimiento de las reglas de negocio sobre los datos primitivos de un par de calzado.
  /// 
  /// Comprueba mediante condicionales si `talla`, `cm` y `precioCompra` son menores o iguales a cero,
  /// lanzando sus respectivas excepciones de dominio si se viola la positividad numérica.
  /// Compara `fechaCompra` contra la fecha del sistema mediante `isAfter`, impidiendo fechas futuras.
  /// Si el parámetro opcional `color` no es nulo, aplica un `.trim()` y verifica que su longitud no supere 
  /// el límite máximo de 30 caracteres.
  void _validateData({
    required double talla,
    required double cm,
    required double precioCompra,
    required DateTime fechaCompra,
    String? color,
  }) {
    if (talla <= 0) {
      throw InventarioInvalidTallaException();
    }
    if (cm <= 0) {
      throw InventarioInvalidCmException();
    }
    if (precioCompra <= 0) {
      throw InventarioInvalidPriceException();
    }
    if (fechaCompra.isAfter(DateTime.now())) {
      throw InventarioFutureDateException();
    }
    if (color != null && color.trim().length > 30) {
      throw InventarioColorTooLongException();
    }
  }

  /// Registra una nueva unidad de calzado en el inventario garantizando unicidad y estado inicial.
  /// 
  /// Consulta la existencia del `idZapato` usando la función de validación relacional inyectada.
  /// Ejecuta `_validateData` para constatar que las métricas físicas y contables sean válidas.
  /// Utiliza un bucle de hasta 5 intentos para autogenerar un código mediante `_generarCodigoUnico`
  /// y verificar contra el DAO que no exista una colisión en la base de datos local.
  /// Si supera los reintentos sin éxito de unicidad, lanza un `InventarioCodeGenerationException`.
  /// Instancia `Inventario` asignando obligatoriamente el estado `EstadoZapato.activo`, sanitizando 
  /// el color en mayúsculas y persistiendo en la base local mediante `put`.
  Future<Inventario> crearInventario({
    required String id,
    required String idZapato,
    required double talla,
    required double cm,
    required double precioCompra,
    required DateTime fechaCompra,
    String? color,
  }) async {
    final zapatoExiste = await _checkZapatoExists(idZapato);
    if (!zapatoExiste) {
      throw InventarioZapatoNotFoundException();
    }

    _validateData(
      talla: talla,
      cm: cm,
      precioCompra: precioCompra,
      fechaCompra: fechaCompra,
      color: color,
    );

    String codigoGenerado = '';
    bool esUnico = false;
    int intentos = 0;

    while (!esUnico && intentos < 5) {
      codigoGenerado = _generarCodigoUnico(fechaCompra, precioCompra);
      final existente = await _inventarioDao.buscarPorCodigo(codigoGenerado);
      if (existente == null) {
        esUnico = true;
      }
      intentos++;
    }

    if (!esUnico) {
      throw InventarioCodeGenerationException();
    }

    final nuevoInventario = Inventario(
      id: id,
      idZapato: idZapato,
      codigo: codigoGenerado,
      talla: talla,
      cm: cm,
      precioCompra: precioCompra,
      fechaCompra: fechaCompra,
      color: color?.trim().toUpperCase(),
      estado: EstadoZapato.activo,
    );

    await _inventarioDao.put(id, nuevoInventario);
    return nuevoInventario;
  }

  /// Actualiza los atributos físicos o financieros de un ítem de inventario existente.
  /// 
  /// Verifica la presencia del ítem en base de datos buscando por su `id`.
  /// Comprueba paralelamente que el `idZapato` relacional corresponda a un registro válido.
  /// Delega las validaciones cuantitativas al método centralizado `_validateData`.
  /// Mantiene intacto el `codigo` autogenerado y el `estado` actual del ciclo de vida del zapato.
  /// Sobrescribe el objeto usando `copyWith` formateando el color en mayúsculas y guarda en el DAO.
  Future<Inventario> actualizarInventario({
    required String id,
    required String idZapato,
    required double talla,
    required double cm,
    required double precioCompra,
    required DateTime fechaCompra,
    String? color,
  }) async {
    final existente = await _inventarioDao.findById(id);
    if (existente == null) {
      throw InventarioNotFoundException();
    }

    final zapatoExiste = await _checkZapatoExists(idZapato);
    if (!zapatoExiste) {
      throw InventarioZapatoNotFoundException();
    }

    _validateData(
      talla: talla,
      cm: cm,
      precioCompra: precioCompra,
      fechaCompra: fechaCompra,
      color: color,
    );

    final actualizado = existente.copyWith(
      idZapato: idZapato,
      talla: talla,
      cm: cm,
      precioCompra: precioCompra,
      fechaCompra: fechaCompra,
      color: color?.trim().toUpperCase(),
    );

    await _inventarioDao.put(id, actualizado);
    return actualizado;
  }

  /// Modifica la fase del ciclo de vida de un par de zapatos dentro de la tienda.
  /// 
  /// Consulta si el registro de inventario está presente en la base de datos local.
  /// Reemplaza únicamente la propiedad `estado` (`activo`, `reservado`, `vendido`) sobre la entidad.
  /// Guarda los cambios en el DAO y retorna la instancia actualizada.
  Future<Inventario> cambiarEstado(String id, EstadoZapato nuevoEstado) async {
    final existente = await _inventarioDao.findById(id);
    if (existente == null) {
      throw InventarioNotFoundException();
    }

    final actualizado = existente.copyWith(estado: nuevoEstado);
    await _inventarioDao.put(id, actualizado);
    return actualizado;
  }

  /// Elimina físicamente un ítem del inventario validando las restricciones del negocio.
  /// 
  /// Busca el registro mediante su `id` arrojando una excepción si no es encontrado.
  /// Evalúa la regla de protección de historial: si el `estado` del calzado es `reservado` o `vendido`,
  /// interrumpe la operación lanzando `InventarioCannotDeleteReservedOrSoldException`.
  /// Procede con la eliminación definitiva en el DAO únicamente si el estado es `activo`.
  Future<void> eliminarInventario(String id) async {
    final existente = await _inventarioDao.findById(id);
    if (existente == null) {
      throw InventarioNotFoundException();
    }

    if (existente.estado != EstadoZapato.activo) {
      throw InventarioCannotDeleteReservedOrSoldException();
    }

    await _inventarioDao.delete(id);
  }

  /// Obtiene los elementos del inventario paginados y el recuento total que coincide con los filtros.
  /// 
  /// Dispara de forma paralela usando `Future.wait` la recuperación de datos y la cuenta de ítems.
  /// Permite aplicar filtros opcionales de `idZapato` y de la máquina de estados `EstadoZapato`.
  /// Extrae y retorna las respuestas en una tupla / Record de Dart 3 `(List<Inventario>, int)`.
  Future<(List<Inventario>, int)> obtenerInventarioPaginado(
    FilterParams params, {
    String? idZapato,
    EstadoZapato? estado,
  }) async {
    final results = await Future.wait([
      _inventarioDao.obtenerInventarioConFiltros(params, idZapato: idZapato, estado: estado),
      _inventarioDao.contarInventarioConFiltros(params, idZapato: idZapato, estado: estado),
    ]);

    final items = results[0] as List<Inventario>;
    final total = results[1] as int;

    return (items, total);
  }
}