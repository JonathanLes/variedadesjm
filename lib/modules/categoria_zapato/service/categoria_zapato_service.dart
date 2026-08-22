import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/categoria_zapato/control/categoria_zapato_dao.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

// --- EXCEPCIONES DE DOMINIO ---
class CategoryNameRequiredException implements Exception {
  final String mensaje = "El nombre de la categoría es obligatorio y no puede estar vacío";
  @override
  String toString() => mensaje;
}

class CategoryNameTooShortException implements Exception {
  final String mensaje = "El nombre de la categoría debe tener al menos 2 caracteres";
  @override
  String toString() => mensaje;
}

class CategoryNameTooLongException implements Exception {
  final String mensaje = "El nombre de la categoría no puede tener más de 50 caracteres";
  @override
  String toString() => mensaje;
}

class CategoryAlreadyExistsException implements Exception {
  final String mensaje = "Ya existe una categoría registrada con ese nombre";
  @override
  String toString() => mensaje;
}

class CategoryNotFoundException implements Exception {
  final String mensaje = "No existe una categoría con ese nombre o ya fue eliminada";
  @override
  String toString() => mensaje;
}

class CategoryInUseException implements Exception {
  final String mensaje = "No se puede eliminar la categoría porque ya tiene zapatos asociados";
  @override
  String toString() => mensaje;
}

/// Método encargado de normalizar el nombre de la categoría, eliminando los espacios
/// vacíos en los extremos, reemplazando los espacios intermedios por guiones bajos
/// y pasando cada letra a mayúscula, evitando inconsistencias en la base de datos.
/// Ejemplo: [ zapatos de vestir ] -> [ZAPATOS_DE_VESTIR]
String normalizeCategoryName(String name) {
  return name.trim().replaceAll(RegExp(r"\s+"), "_").toUpperCase();
}

class CategoriaZapatoService {
  final CategoriaZapatoDAO _categoriaDao;
  final Future<bool> Function(String categoriaId) _checkCategoryInUse;

  CategoriaZapatoService({
    required CategoriaZapatoDAO categoriaDao,
    required Future<bool> Function(String categoriaId) checkCategoryInUse,
  }) : _categoriaDao = categoriaDao,
       _checkCategoryInUse = checkCategoryInUse;


  /// Valida que el nombre de la categoría cumpla con las reglas de negocio de estructura y longitud.
  /// Verifica que el [normalizedName] no esté vacío, tenga una longitud mínima de 2
  /// caracteres y no exceda el límite máximo de 50 caracteres.
  ///
  /// Lanza las siguientes excepciones de dominio si se infringe alguna regla:
  /// * [CategoryNameRequiredException] si la cadena de texto está vacía.
  /// * [CategoryNameTooShortException] si la longitud de la cadena es menor a 2.
  /// * [CategoryNameTooLongException] si la longitud de la cadena es mayor a 50.
  void _validateName(String normalizedName) {
    if (normalizedName.isEmpty) {
      throw CategoryNameRequiredException();
    }
    if (normalizedName.length < 2) {
      throw CategoryNameTooShortException();
    }
    if (normalizedName.length > 50) {
      throw CategoryNameTooLongException();
    }
  }

  /// Verifica si ya existe una categoría registrada con el mismo nombre normalizado.
  /// Compara el [normalizedName] contra todos los registros existentes en la
  /// base de datos. Si se proporciona un [excludeId], el registro con ese
  /// identificador será omitido en la búsqueda. Esto es fundamental durante
  /// la actualización de una categoría para evitar que colisione consigo misma.
  ///
  /// Retorna un `Future<bool>` que se resuelve a `true` si se encuentra una
  /// categoría con el mismo nombre, o `false` si el nombre está disponible.
  Future<bool> _isDuplicate(String normalizedName, {String? excludeId}) async {
    final allCategories = await _categoriaDao.findRange();
    return allCategories.any(
      (categoria) => categoria.nombreCategoria == normalizedName && categoria.id != excludeId,
    );
  }

  /// Crea y persiste una nueva categoría en el sistema aplicando todas las reglas de negocio.
  ///
  /// Recibe el [id] único para la nueva categoría y el [nombre] en crudo proporcionado
  /// por el usuario. El método se encarga de normalizar el nombre, validar su
  /// estructura y garantizar que no existan duplicados antes de guardar el registro.
  ///
  /// Lanza las siguientes excepciones de dominio en caso de fallar las validaciones:
  /// * [CategoryNameRequiredException] si el nombre normalizado está vacío.
  /// * [CategoryNameTooShortException] si el nombre normalizado es menor a 2 caracteres.
  /// * [CategoryNameTooLongException] si el nombre normalizado supera los 50 caracteres.
  /// * [CategoryAlreadyExistsException] si ya existe otra categoría con el mismo nombre normalizado.
  ///
  /// Retorna un `Future<CategoriaZapato>` con la instancia de la categoría recién creada y guardada.
  Future<CategoriaZapato> crearCategoria(String id, String nombre) async {
    final normalizedName = normalizeCategoryName(nombre);
    _validateName(normalizedName);

    if (await _isDuplicate(normalizedName)) {
      throw CategoryAlreadyExistsException();
    }

    final nuevaCategoria = CategoriaZapato(id: id, nombreCategoria: normalizedName);
    await _categoriaDao.put(id, nuevaCategoria);

    return nuevaCategoria;
  }

  /// Actualiza la información de una categoría existente aplicando todas las reglas de negocio.
  ///
  /// Primero busca la categoría mediante su [id]. Si existe, toma el [nuevoNombre] en crudo,
  /// lo normaliza, valida su estructura y verifica que el nuevo nombre no colisione
  /// con el de otra categoría registrada (excluyendo a la propia categoría en la comprobación).
  ///
  /// Lanza las siguientes excepciones de dominio:
  /// * [CategoryNotFoundException] si no se encuentra la categoría con el [id] proporcionado.
  /// * [CategoryNameRequiredException] si el nombre normalizado resulta estar vacío.
  /// * [CategoryNameTooShortException] si el nombre normalizado tiene menos de 2 caracteres.
  /// * [CategoryNameTooLongException] si el nombre normalizado excede los 50 caracteres.
  /// * [CategoryAlreadyExistsException] si el nuevo nombre ya le pertenece a otra categoría.
  ///
  /// Retorna un `Future<CategoriaZapato>` con la instancia de la categoría con sus datos actualizados.
  Future<CategoriaZapato> actualizarCategoria(String id, String nuevoNombre) async {
    final categoriaExistente = await _categoriaDao.findById(id);

    if (categoriaExistente == null) {
      throw CategoryNotFoundException();
    }

    final normalizedName = normalizeCategoryName(nuevoNombre);
    _validateName(normalizedName);

    if (await _isDuplicate(normalizedName, excludeId: id)) {
      throw CategoryAlreadyExistsException();
    }

    final categoriaActualizada = categoriaExistente.copyWith(
      nombreCategoria: normalizedName,
    );
    await _categoriaDao.put(id, categoriaActualizada);

    return categoriaActualizada;
  }

  /// Elimina una categoría del sistema garantizando la integridad referencial de los datos.
  ///
  /// Verifica que la categoría identificada por el [id] exista en la base de datos.
  /// Antes de ejecutar la eliminación física, comprueba que la categoría no tenga
  /// zapatos asociados mediante la función de validación inyectada.
  ///
  /// Lanza las siguientes excepciones de dominio:
  /// * [CategoryNotFoundException] si la categoría solicitada no existe o ya fue eliminada.
  /// * [CategoryInUseException] si la categoría tiene zapatos dependientes asociados,
  /// cancelando así el proceso de eliminación.
  ///
  /// Retorna un `Future<void>` que se completa cuando la categoría se elimina exitosamente.
  Future<void> eliminarCategoria(String id) async {
    final categoriaExistente = await _categoriaDao.findById(id);

    if (categoriaExistente == null) {
      throw CategoryNotFoundException();
    }

    final isInUse = await _checkCategoryInUse(id);
    if (isInUse) {
      throw CategoryInUseException();
    }

    await _categoriaDao.delete(id);
  }

  /// Recupera el listado completo de todas las categorías registradas en el sistema.
  /// 
  /// Este método es ideal para inicializar listas desplegables (dropdowns) o vistas principales.
  /// Retorna una lista vacía `[]` si aún no hay categorías registradas.
  /// Lanza [DaoException] si ocurre un problema al consultar la base de datos.
  Future<List<CategoriaZapato>> obtenerTodasLasCategorias() async {
    return await _categoriaDao.findRange();
  }

  /// Busca categorías cuyo nombre coincida total o parcialmente con el [query].
  /// 
  /// Elimina los espacios en blanco al inicio y al final del texto ingresado.
  /// Si el texto resultante está vacío, devuelve automáticamente el listado 
  /// completo de categorías llamando a [obtenerTodasLasCategorias] para optimizar 
  /// la respuesta visual en la interfaz.
  /// 
  /// Retorna una lista vacía `[]` si no hay coincidencias.
  /// Lanza [DaoException] si ocurre un fallo en la base de datos local.
  Future<List<CategoriaZapato>> buscarCategorias(String query) async {
    final sanitizedQuery = query.trim();

    if (sanitizedQuery.isEmpty) {
      return obtenerTodasLasCategorias();
    }

    return await _categoriaDao.buscarPorNombreCategoria(sanitizedQuery);
  }

  /// Recupera las categorías paginadas y el conteo total en una sola llamada.
  /// 
  /// Recibe un objeto [FilterParams] con todas las reglas de la interfaz.
  /// Ejecuta dos consultas simultáneas al DAO: una para obtener los datos 
  /// de la página actual y otra para contar el total de registros que 
  /// coinciden con los filtros.
  /// 
  /// Retorna un **Record** de Dart 3 que contiene:
  /// 1. `List<CategoriaZapato>`: Las categorías de la página solicitada.
  /// 2. `int`: El total de categorías que coinciden (para la paginación).
  Future<(List<CategoriaZapato>, int)> obtenerCategoriasPaginadas(FilterParams params) async {
    final results = await Future.wait([
      _categoriaDao.obtenerCategoriasConFiltros(params),
      _categoriaDao.contarCategoriasConFiltros(params),
    ]);

    final categorias = results[0] as List<CategoriaZapato>;
    final total = results[1] as int;

    return (categorias, total);
  }
}