import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/modules/zapato/control/zapato_dao.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class ZapatoModelRequiredException implements Exception {
  final String mensaje = "El nombre del modelo es obligatorio";
  @override String toString() => mensaje;
}

class ZapatoModelTooShortException implements Exception {
  final String mensaje = "El modelo debe tener al menos 2 caracteres";
  @override String toString() => mensaje;
}

class ZapatoModelTooLongException implements Exception {
  final String mensaje = "El modelo no puede exceder los 100 caracteres";
  @override String toString() => mensaje;
}

class ZapatoDescriptionTooLongException implements Exception {
  final String mensaje = "La descripción no puede exceder los 500 caracteres";
  @override String toString() => mensaje;
}

class ZapatoInvalidPriceException implements Exception {
  final String mensaje = "El precio de venta sugerido debe ser mayor a cero";
  @override String toString() => mensaje;
}

class ZapatoAlreadyExistsException implements Exception {
  final String mensaje = "Esta marca ya tiene registrado un zapato con este modelo";
  @override String toString() => mensaje;
}

class ZapatoNotFoundException implements Exception {
  final String mensaje = "El zapato no existe o fue eliminado";
  @override String toString() => mensaje;
}

class RelationalEntityNotFoundException implements Exception {
  final String mensaje = "La marca o categoría seleccionada no existe";
  @override String toString() => mensaje;
}

class ZapatoInUseException implements Exception {
  final String mensaje = "No se puede eliminar el zapato porque tiene stock en inventario";
  @override String toString() => mensaje;
}

/// Normaliza el nombre del modelo de zapato asegurando consistencia en base de datos.
/// 
/// Utiliza `trim()` para limpiar los espacios iniciales y finales.
/// Aplica una expresión regular `\s+` que detecta uno o múltiples espacios intermedios,
/// reemplazándolos todos por un guión bajo `_` como regla de negocio estandarizada.
/// Termina utilizando `toUpperCase()` para transformar toda la cadena a mayúsculas,
/// garantizando que variaciones como "Air Max" y " air  max " terminen en "AIR_MAX".
String normalizeModelName(String name) {
  return name.trim().replaceAll(RegExp(r"\s+"), "_").toUpperCase();
}

class ZapatoService {
  final ZapatoDAO _zapatoDao;
  final Future<bool> Function(String marcaId) _checkMarcaExists;
  final Future<bool> Function(String categoriaId) _checkCategoriaExists;
  final Future<bool> Function(String zapatoId) _checkZapatoInUse;

  ZapatoService({
    required ZapatoDAO zapatoDao,
    required Future<bool> Function(String marcaId) checkMarcaExists,
    required Future<bool> Function(String categoriaId) checkCategoriaExists,
    required Future<bool> Function(String zapatoId) checkZapatoInUse,
  }) : _zapatoDao = zapatoDao,
       _checkMarcaExists = checkMarcaExists,
       _checkCategoriaExists = checkCategoriaExists,
       _checkZapatoInUse = checkZapatoInUse;

  /// Centraliza las validaciones de las reglas de negocio sobre atributos individuales.
  /// 
  /// Comprueba mediante condiciones `if` las longitudes del modelo normalizado, evaluando si 
  /// es vacío (lanza excepción), menor a 2 caracteres o mayor a 100 caracteres.
  /// Valida de forma segura el atributo `descripcion` verificando primero que no sea nulo, 
  /// y si excede 500 caracteres, lanza una excepción para cuidar el peso en la base local.
  /// Por último, evalúa si `precioVentaSugerido` es menor o igual a cero, emitiendo una
  /// excepción dado que un producto no puede ser regalado o tener coste negativo en tienda.
  void _validateData(String normalizedModel, String? descripcion, double precio) {
    if (normalizedModel.isEmpty) {
      throw ZapatoModelRequiredException();
    }
    if (normalizedModel.length < 2) {
      throw ZapatoModelTooShortException();
    }
    if (normalizedModel.length > 100) {
      throw ZapatoModelTooLongException();
    }
    if (descripcion != null && descripcion.trim().length > 500) {
      throw ZapatoDescriptionTooLongException();
    }
    if (precio <= 0) {
      throw ZapatoInvalidPriceException();
    }
  }

  /// Verifica si la composición de modelo y marca ya existe en el sistema.
  /// 
  /// Recupera todos los zapatos usando `obtenerZapatosConFiltros` enviando un objeto
  /// `FilterParams` vacío pero inyectando el `idMarca` por parámetro. 
  /// Esto ahorra recursos porque solo trae a memoria los zapatos de la marca implicada.
  /// Itera los resultados con `any` para verificar si algún zapato coincide exactamente
  /// con el `normalizedModel` provisto y que a la vez su `id` sea distinto al `excludeId`.
  /// Retorna un valor booleano indicando existencia de colisión en reglas de unicidad.
  Future<bool> _isDuplicate(String normalizedModel, String idMarca, {String? excludeId}) async {
    final zapatosDeMarca = await _zapatoDao.obtenerZapatosConFiltros(
      const FilterParams(), 
      idMarca: idMarca
    );
    
    return zapatosDeMarca.any((zapato) => 
      zapato.modelo == normalizedModel && zapato.id != excludeId
    );
  }

  /// Inserta un nuevo zapato en el sistema respetando la integridad referencial y de dominio.
  /// 
  /// Convierte el modelo entrante utilizando el normalizador declarado externamente.
  /// Utiliza un `Future.wait` para comprobar de manera asíncrona pero simultánea si el `idMarca`
  /// y el `idCategoria` existen en sus respectivas colecciones, lanzando una excepción si fallan.
  /// Ejecuta `_validateData` para sanear reglas de negocio sobre texto y precio.
  /// Invoca a `_isDuplicate` esperando su retorno para detener la operación si la marca ya 
  /// posee un zapato con el mismo modelo.
  /// Instancia la clase `Zapato` agregando un saneamiento (`trim()`) adicional a la descripción.
  /// Llama al `put` del DAO para materializar los datos, retornando la instancia terminada.
  Future<Zapato> crearZapato({
    required String id,
    required String modelo,
    required String idMarca,
    required String idCategoria,
    required double precio,
    String? descripcion,
    String? imagenPath,
  }) async {
    final normalizedModel = normalizeModelName(modelo);

    final fkChecks = await Future.wait([
      _checkMarcaExists(idMarca),
      _checkCategoriaExists(idCategoria),
    ]);

    if (!fkChecks[0] || !fkChecks[1]) {
      throw RelationalEntityNotFoundException();
    }

    _validateData(normalizedModel, descripcion, precio);

    if (await _isDuplicate(normalizedModel, idMarca)) {
      throw ZapatoAlreadyExistsException();
    }

    final nuevoZapato = Zapato(
      id: id,
      modelo: normalizedModel,
      idMarca: idMarca,
      idCategoria: idCategoria,
      precioVentaSugerido: precio,
      descripcion: descripcion?.trim(),
      imagenPath: imagenPath,
    );

    await _zapatoDao.put(id, nuevoZapato);
    return nuevoZapato;
  }

  /// Actualiza un zapato existente sin colisionar sus valores de unicidad.
  /// 
  /// Ejecuta un `findById` para cerciorarse de que el zapato solicitado siga existiendo.
  /// Aplica el normalizador al nuevo modelo ingresado por el usuario.
  /// Usa `Future.wait` para validar paralelamente la persistencia actual de marca y categoría.
  /// Delega las validaciones de límites en `_validateData`.
  /// Envía el `id` a `_isDuplicate` como `excludeId` para que el sistema permita guardar 
  /// los cambios si el nombre del modelo es el mismo que este mismo registro ya poseía.
  /// Usa `copyWith` sobre el registro viejo sobrescribiendo los campos renovados.
  /// Guarda permanentemente en el DAO y retorna la instancia alterada.
  Future<Zapato> actualizarZapato({
    required String id,
    required String modelo,
    required String idMarca,
    required String idCategoria,
    required double precio,
    String? descripcion,
    String? imagenPath,
  }) async {
    final zapatoExistente = await _zapatoDao.findById(id);

    if (zapatoExistente == null) {
      throw ZapatoNotFoundException();
    }

    final normalizedModel = normalizeModelName(modelo);

    final fkChecks = await Future.wait([
      _checkMarcaExists(idMarca),
      _checkCategoriaExists(idCategoria),
    ]);

    if (!fkChecks[0] || !fkChecks[1]) {
      throw RelationalEntityNotFoundException();
    }

    _validateData(normalizedModel, descripcion, precio);

    if (await _isDuplicate(normalizedModel, idMarca, excludeId: id)) {
      throw ZapatoAlreadyExistsException();
    }

    final zapatoActualizado = zapatoExistente.copyWith(
      modelo: normalizedModel,
      idMarca: idMarca,
      idCategoria: idCategoria,
      precioVentaSugerido: precio,
      descripcion: descripcion?.trim(),
      imagenPath: imagenPath,
    );

    await _zapatoDao.put(id, zapatoActualizado);
    return zapatoActualizado;
  }

  /// Elimina un modelo de zapato asegurando que no tenga existencia en inventario.
  /// 
  /// Consulta el DAO en búsqueda del registro completo del zapato por medio del ID.
  /// Llama al callback inyectado `_checkZapatoInUse` para investigar en los submódulos de 
  /// inventario si existen existencias físicas atadas a este modelo; si es cierto, lanza 
  /// una excepción de restricción para evitar datos corruptos (zapatos huérfanos).
  /// Si todo está correcto, llama al `delete` físico en base de datos.
  Future<void> eliminarZapato(String id) async {
    final zapatoExistente = await _zapatoDao.findById(id);

    if (zapatoExistente == null) {
      throw ZapatoNotFoundException();
    }

    final isInUse = await _checkZapatoInUse(id);
    if (isInUse) {
      throw ZapatoInUseException();
    }

    await _zapatoDao.delete(id);
  }

  /// Recupera un listado compuesto y el total de registros calculados en tiempo real.
  /// 
  /// Abre dos hilos paralelos mediante `Future.wait`: el primero pide la lista procesada 
  /// de zapatos y el segundo cuenta cuántos coincidieron exactamente con los filtros en total.
  /// Estos métodos reciben opcionalmente `idMarca` e `idCategoria` si el usuario navegó 
  /// filtrando exclusivamente los zapatos de esas clasificaciones en la interfaz visual.
  /// Desglosa los resultados del array dinámico forzando los tipos y los empaca en un `Record`.
  Future<(List<Zapato>, int)> obtenerZapatosPaginados(
    FilterParams params, {
    String? idMarca,
    String? idCategoria,
  }) async {
    final results = await Future.wait([
      _zapatoDao.obtenerZapatosConFiltros(params, idMarca: idMarca, idCategoria: idCategoria),
      _zapatoDao.contarZapatosConFiltros(params, idMarca: idMarca, idCategoria: idCategoria),
    ]);

    final zapatos = results[0] as List<Zapato>;
    final total = results[1] as int;

    return (zapatos, total);
  }
}