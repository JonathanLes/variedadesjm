import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/zapato/control/zapato_dao.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/modules/zapato/service/zapato_service.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';
import 'package:variedadesjm/modules/inventario/control/inventario_dao.dart';
import 'package:variedadesjm/modules/marca/control/marca_dao.dart';
import 'package:variedadesjm/modules/categoria_zapato/control/categoria_zapato_dao.dart';

class ZapatoState {
  final List<Zapato> zapatos;
  final int totalItems;
  final FilterParams filtros;
  final String? filtroIdMarca;
  final String? filtroIdCategoria;

  ZapatoState({
    required this.zapatos,
    required this.totalItems,
    required this.filtros,
    this.filtroIdMarca,
    this.filtroIdCategoria,
  });

  ZapatoState copyWith({
    List<Zapato>? zapatos,
    int? totalItems,
    FilterParams? filtros,
    String? filtroIdMarca,
    String? filtroIdCategoria,
    bool clearMarca = false,
    bool clearCategoria = false,
  }) {
    return ZapatoState(
      zapatos: zapatos ?? this.zapatos,
      totalItems: totalItems ?? this.totalItems,
      filtros: filtros ?? this.filtros,
      filtroIdMarca: clearMarca ? null : (filtroIdMarca ?? this.filtroIdMarca),
      filtroIdCategoria: clearCategoria
          ? null
          : (filtroIdCategoria ?? this.filtroIdCategoria),
    );
  }
}

final zapatoDaoProvider = FutureProvider<ZapatoDAO>((ref) async {
  final db = await ref.watch(sembastDatabaseProvider.future);
  return ZapatoDAO(db);
});

final zapatoServiceProvider = FutureProvider<ZapatoService>((ref) async {
  final zapatoDao = await ref.watch(zapatoDaoProvider.future);

  return ZapatoService(
    zapatoDao: zapatoDao,
    checkMarcaExists: (marcaId) async {
      final db = await ref.read(sembastDatabaseProvider.future);
      return (await MarcaDAO(db).findById(marcaId)) != null;
    },
    checkCategoriaExists: (categoriaId) async {
      final db = await ref.read(sembastDatabaseProvider.future);
      return (await CategoriaZapatoDAO(db).findById(categoriaId)) != null;
    },
    checkZapatoInUse: (zapatoId) async {
      final db = await ref.read(sembastDatabaseProvider.future);
      return InventarioDAO(db).existePorZapato(zapatoId);
    },
  );
});

class ZapatoController extends AsyncNotifier<ZapatoState> {
  /// Inicializa la máquina de estado para el gestor de zapatos.
  ///
  /// Espera la inyección asíncrona del proveedor del servicio usando el árbol de Riverpod.
  /// Define una constante inicial de filtros vacíos, posicionando la vista en la página uno.
  /// Solicita el listado inicial mediante paginación destapando el `Record` para obtener
  /// los elementos y el conteo. Devuelve un `ZapatoState` inyectando todo lo recopilado.
  @override
  Future<ZapatoState> build() async {
    final service = await ref.watch(zapatoServiceProvider.future);

    const filtrosIniciales = FilterParams();

    final (zapatos, total) = await service.obtenerZapatosPaginados(
      filtrosIniciales,
    );

    return ZapatoState(
      zapatos: zapatos,
      totalItems: total,
      filtros: filtrosIniciales,
    );
  }

  /// Método utilitario que efectúa el consumo de datos de disco a memoria en base al estado.
  ///
  /// Activa el estado transitorio `loading` deteniendo interfaces gráficas interactivas.
  /// Ejecuta `AsyncValue.guard` que encapsula automáticamente errores emitiendo estado de error.
  /// Extrae los filtros, marca y categoría actualmente configurados en los parámetros de este método.
  /// Sobrescribe el estado combinando los zapatos entrantes y metadatos actualizados de Sembast.
  Future<void> _cargarConFiltros(
    FilterParams nuevosFiltros, {
    String? idMarca,
    String? idCategoria,
    bool clearMarca = false,
    bool clearCategoria = false,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;

    final nextMarca = clearMarca
        ? null
        : (idMarca ?? currentState.filtroIdMarca);
    final nextCat = clearCategoria
        ? null
        : (idCategoria ?? currentState.filtroIdCategoria);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = await ref.read(zapatoServiceProvider.future);
      final (zapatos, total) = await service.obtenerZapatosPaginados(
        nuevosFiltros,
        idMarca: nextMarca,
        idCategoria: nextCat,
      );

      return currentState.copyWith(
        zapatos: zapatos,
        totalItems: total,
        filtros: nuevosFiltros,
        filtroIdMarca: nextMarca,
        filtroIdCategoria: nextCat,
        clearMarca: clearMarca,
        clearCategoria: clearCategoria,
      );
    });
  }

  /// Manipula el texto de búsqueda e instruye al controlador reiniciar los parámetros base.
  ///
  /// Protege el bloque saliendo rápidamente si el valor del estado es nulo.
  /// Modifica los parámetros creando una copia y ordenando el reinicio del contador de páginas.
  /// Envía los nuevos filtros a `_cargarConFiltros` manteniendo las relaciones previas.
  Future<void> buscarZapatos(String query) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros
        .copyWith(query: query)
        .resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Actualiza los parámetros relacionales para enjaular resultados a una entidad foránea.
  ///
  /// Limpia los contadores de página al hacer un cambio de filtro drástico en la interfaz.
  /// Si el valor proporcionado es nulo, dispara banderas booleanas `clearMarca` o `clearCategoria`
  /// hacia el método de carga, indicándole al motor que elimine dichos candados en la consulta.
  Future<void> filtrarPorRelacion({
    String? idMarca,
    String? idCategoria,
  }) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.resetPage();
    await _cargarConFiltros(
      nuevosFiltros,
      idMarca: idMarca,
      idCategoria: idCategoria,
      clearMarca: idMarca == null,
      clearCategoria: idCategoria == null,
    );
  }

  /// Traslada al usuario de manera controlada por las divisiones aritméticas del bloque total.
  ///
  /// Altera únicamente el valor numeral de la página en la estructura de parámetros inmutable.
  /// Recarga el listado recuperando únicamente la porción de base de datos pertinente.
  Future<void> cambiarPagina(int nuevaPagina) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.copyWith(page: nuevaPagina);
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Ingresa un nuevo bloque de datos mediante el servicio orquestando la vista optimistamente.
  ///
  /// Obtiene la instancia del registro validado de forma asíncrona.
  /// Evita peticiones a Sembast operando el estado en memoria inyectando el zapato a la lista.
  /// Ordena con la función nativa los elementos apoyándose en la normalización ortográfica.
  /// Devuelve un clon del estado adicionando la unidad al contador total.
  Future<void> crearZapato({
    required String id,
    required String modelo,
    required String idMarca,
    required String idCategoria,
    required double precio,
    String? descripcion,
    String? imagenPath,
  }) async {
    final service = await ref.read(zapatoServiceProvider.future);
    final nuevoZapato = await service.crearZapato(
      id: id,
      modelo: modelo,
      idMarca: idMarca,
      idCategoria: idCategoria,
      precio: precio,
      descripcion: descripcion,
      imagenPath: imagenPath,
    );

    state = state.whenData((estadoActual) {
      final nuevaLista = [...estadoActual.zapatos, nuevoZapato];
      nuevaLista.sort((a, b) => a.modelo.compareTo(b.modelo));
      return estadoActual.copyWith(
        zapatos: nuevaLista,
        totalItems: estadoActual.totalItems + 1,
      );
    });
  }

  /// Ejecuta la sobreescritura de propiedades en disco y actualiza la cuadrícula de datos viva.
  ///
  /// Solicita el salvado del objeto modificado por el Service.
  /// Reconstruye el array de zapatos realizando un mapeo y sustituyendo el ítem que empató en ID.
  /// Estabiliza visualmente aplicando el algoritmo de ordenamiento nuevamente sobre la lista.
  Future<void> actualizarZapato({
    required String id,
    required String modelo,
    required String idMarca,
    required String idCategoria,
    required double precio,
    String? descripcion,
    String? imagenPath,
  }) async {
    final service = await ref.read(zapatoServiceProvider.future);
    final zapatoAct = await service.actualizarZapato(
      id: id,
      modelo: modelo,
      idMarca: idMarca,
      idCategoria: idCategoria,
      precio: precio,
      descripcion: descripcion,
      imagenPath: imagenPath,
    );

    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.zapatos
          .map((z) => z.id == id ? zapatoAct : z)
          .toList();
      nuevaLista.sort((a, b) => a.modelo.compareTo(b.modelo));
      return estadoActual.copyWith(zapatos: nuevaLista);
    });
  }

  /// Aplica el desuso en persistencia de datos y sustrae visualmente al implicado de memoria.
  ///
  /// Delega la verificación de restricciones referenciales de inventario al Service.
  /// Emite una versión purgada del estado usando el predicado lógico exclusor sobre la lista de ítems.
  /// Resta asíncronamente una unidad en el sumario principal de entidades disponibles.
  Future<void> eliminarZapato(String id) async {
    final service = await ref.read(zapatoServiceProvider.future);
    await service.eliminarZapato(id);

    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.zapatos.where((z) => z.id != id).toList();
      return estadoActual.copyWith(
        zapatos: nuevaLista,
        totalItems: estadoActual.totalItems - 1,
      );
    });
  }
}

final zapatoControllerProvider =
    AsyncNotifierProvider<ZapatoController, ZapatoState>(() {
      return ZapatoController();
    });

/// Lista completa para selectores de inventario y filtros relacionales.
final zapatosCatalogoProvider = FutureProvider<List<Zapato>>((ref) async {
  final dao = await ref.watch(zapatoDaoProvider.future);
  return dao.findRange();
});
