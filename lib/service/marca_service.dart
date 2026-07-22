import "package:variedadesjm/entity/marca.dart";
import "package:variedadesjm/control/marca_dao.dart";

class BrandNameRequeridedExpection implements Exception {
  final String mensaje =
      "El nombre de la marca es obligatorio y no puede estar vacío";
  @override
  String toString() => mensaje;
}

class BrandNameTooShortExpection implements Exception {
  final String mensaje =
      "El nombre de la marca debe tener al menos 2 carácteres";
  @override
  String toString() => mensaje;
}

class BrandNameTooLongExpection implements Exception {
  final String mensaje =
      "El nombre de la marca no puede tener más de 50 carácteres";
  @override
  String toString() => mensaje;
}

class BrandAlreadyExistsExpection implements Exception {
  final String mensaje = "Ya existe una marca registrada con ese nombre";
  @override
  String toString() => mensaje;
}

class BrandNotFoundExpection implements Exception {
  final String mensaje =
      "No existe una marca con ese nombre o ya fue eliminada";
  @override
  String toString() => mensaje;
}

class BrandInUseExpection implements Exception {
  final String mensaje =
      "No se puede eliminar la marca porque ya tiene productos asociados";
  @override
  String toString() => mensaje;
}

/// Método encargado de normalizar el nombre de la marca, eliminando los espacios
/// vacíos y pasando cada letra a mayúscula, evitando inconsistencias en la base de datos
/// Ejemplo: [ nike ] -> [NIKE]
String normalizeBrandName(String name) {
  return name.trim().replaceAll(RegExp(r"\s+"), "").toUpperCase();
}

class MarcaService {
  final MarcaDAO _marcaDao;
  final Future<bool> Function(String marcaId) _checkBrandInUse;

  MarcaService({
    required MarcaDAO marcaDao,
    required Future<bool> Function(String marcaId) checkBrandInUse,
  }) : _marcaDao = marcaDao,
       _checkBrandInUse = checkBrandInUse;

  /// Valida que el nombre de la marca cumpla con las reglas de negocio de estructura y longitud.
  /// Verifica que el [normalizedName] no esté vacío, tenga una longitud mínima de 2
  /// caracteres y no exceda el límite máximo de 50 caracteres.
  ///
  /// Lanza las siguientes excepciones de dominio si se infringe alguna regla:
  /// * [BrandNameRequiredException] si la cadena de texto está vacía.
  /// * [BrandNameTooShortException] si la longitud de la cadena es menor a 2.
  /// * [BrandNameTooLongException] si la longitud de la cadena es mayor a 50.
  void _validateName(String normalizedName) {
    if (normalizedName.isEmpty) {
      throw BrandNameRequeridedExpection();
    }
    if (normalizedName.length < 2) {
      throw BrandNameTooShortExpection();
    }
    if (normalizedName.length > 50) {
      throw BrandNameTooLongExpection();
    }
  }

  /// Verifica si ya existe una marca registrada con el mismo nombre normalizado.
  /// Compara el [normalizedName] contra todos los registros existentes en la
  /// base de datos. Si se proporciona un [excludeId], el registro con ese
  /// identificador será omitido en la búsqueda. Esto es fundamental durante
  /// la actualización de una marca para evitar que colisione consigo misma.
  ///
  /// Retorna un `Future<bool>` que se resuelve a `true` si se encuentra una
  /// marca con el mismo nombre, o `false` si el nombre está disponible.
  Future<bool> _isDuplicate(String normalizedName, {String? excludeId}) async {
    final allBrands = await _marcaDao.findRange();

    return allBrands.any(
      (marca) => marca.nombreMarca == normalizedName && marca.id != excludeId,
    );
  }

  /// Crea y persiste una nueva marca en el sistema aplicando todas las reglas de negocio.
  ///
  /// Recibe el [id] único para la nueva marca y el [nombre] en crudo proporcionado
  /// por el usuario. El método se encarga de normalizar el nombre, validar su
  /// estructura y garantizar que no existan duplicados antes de guardar el registro.
  ///
  /// Lanza las siguientes excepciones de dominio en caso de fallar las validaciones:
  /// * [BrandNameRequiredException] si el nombre normalizado está vacío.
  /// * [BrandNameTooShortException] si el nombre normalizado es menor a 2 caracteres.
  /// * [BrandNameTooLongException] si el nombre normalizado supera los 100 caracteres.
  /// * [BrandAlreadyExistsException] si ya existe otra marca con el mismo nombre normalizado.
  ///
  /// Retorna un `Future<Marca>` con la instancia de la marca recién creada y guardada.
  Future<Marca> crearMarca(String id, String nombre) async {
    final normalizedName = normalizeBrandName(nombre);
    _validateName(normalizedName);

    if (await _isDuplicate(normalizedName)) {
      throw BrandAlreadyExistsExpection();
    }

    final nuevaMarca = Marca(id: id, nombreMarca: normalizedName);
    await _marcaDao.put(id, nuevaMarca);

    return nuevaMarca;
  }

  /// Actualiza la información de una marca existente aplicando todas las reglas de negocio.
  ///
  /// Primero busca la marca mediante su [id]. Si existe, toma el [nuevoNombre] en crudo,
  /// lo normaliza, valida su estructura y verifica que el nuevo nombre no colisione
  /// con el de otra marca registrada (excluyendo a la propia marca en la comprobación).
  ///
  /// Lanza las siguientes excepciones de dominio:
  /// * [BrandNotFoundException] si no se encuentra la marca con el [id] proporcionado.
  /// * [BrandNameRequiredException] si el nombre normalizado resulta estar vacío.
  /// * [BrandNameTooShortException] si el nombre normalizado tiene menos de 2 caracteres.
  /// * [BrandNameTooLongException] si el nombre normalizado excede los 100 caracteres.
  /// * [BrandAlreadyExistsException] si el nuevo nombre ya le pertenece a otra marca.
  ///
  /// Retorna un `Future<Marca>` con la instancia de la marca con sus datos actualizados.
  Future<Marca> actualizarMarca(String id, String nuevoNombre) async {
    final marcaExistente = await _marcaDao.findById(id);

    if (marcaExistente == null) {
      throw BrandNotFoundExpection();
    }

    final normalizedName = normalizeBrandName(nuevoNombre);
    _validateName(normalizedName);

    if (await _isDuplicate(normalizedName, excludeId: id)) {
      throw BrandAlreadyExistsExpection();
    }

    final marcaActualizada = marcaExistente.copyWith(
      nombreMarca: normalizedName,
    );
    _marcaDao.put(id, marcaActualizada);

    return marcaActualizada;
  }

  /// Elimina una marca del sistema garantizando la integridad referencial de los datos.
  ///
  /// Verifica que la marca identificada por el [id] exista en la base de datos.
  /// Antes de ejecutar la eliminación física, comprueba que la marca no tenga
  /// productos (como zapatos) asociados mediante la función de validación inyectada.
  ///
  /// Lanza las siguientes excepciones de dominio:
  /// * [BrandNotFoundException] si la marca solicitada no existe o ya fue eliminada.
  /// * [BrandInUseException] si la marca tiene productos dependientes asociados,
  /// cancelando así el proceso de eliminación.
  ///
  /// Retorna un `Future<void>` que se completa cuando la marca se elimina exitosamente.
  Future<void> eliminarMarca(String id) async {
    final marcaExistente = await _marcaDao.findById(id);

    if (marcaExistente == null) {
      throw BrandNotFoundExpection();
    }

    final isInUse = await _checkBrandInUse(id);
    if (isInUse) {
      throw BrandInUseExpection();
    }

    await _marcaDao.delete(id);
  }
}
