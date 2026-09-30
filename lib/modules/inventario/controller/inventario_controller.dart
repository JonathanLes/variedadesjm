import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/inventario/control/inventario_dao.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/inventario/service/inventario_service.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class InventarioState {
  final List<Inventario> items;
  final int totalItems;
  final FilterParams filtros;
  final String? filtroIdZapato;
  final EstadoZapato? filtroEstado;

  InventarioState({
    required this.items,
    required this.totalItems,
    required this.filtros,
    this.filtroIdZapato,
    this.filtroEstado,
  });

  InventarioState copyWith({
    List<Inventario>? items,
    int? totalItems,
    FilterParams? filtros,
    String? filtroIdZapato,
    EstadoZapato? filtroEstado,
    bool clearZapato = false,
    bool clearEstado = false,
  }) {
    return InventarioState(
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      filtros: filtros ?? this.filtros,
      filtroIdZapato: clearZapato ? null : (filtroIdZapato ?? this.filtroIdZapato),
      filtroEstado: clearEstado ? null : (filtroEstado ?? this.filtroEstado),
    );
  }
}

final inventarioDaoProvider = FutureProvider<InventarioDAO>((ref) async {
  final db = await ref.watch(sembastDatabaseProvider.future);
  return InventarioDAO(db);
});

final inventarioServiceProvider = FutureProvider<InventarioService>((ref) async {
  final inventarioDao = await ref.watch(inventarioDaoProvider.future);

  return InventarioService(
    inventarioDao: inventarioDao,
    checkZapatoExists: (zapatoId) async {
      return true;
    },
  );
});

class InventarioController extends AsyncNotifier<InventarioState> {

  /// Construye el estado inicial del controlador de inventario al ser instanciado.
  /// 
  /// Obtiene la referencia del servicio asíncrono a través del árbol de proveedores de Riverpod.
  /// Define una configuración inicial de filtros vacíos apuntando a la primera página.
  /// Solicita el listado paginado inicial y emite el `InventarioState` con los resultados.
  @override
  Future<InventarioState> build() async {
    final service = await ref.watch(inventarioServiceProvider.future);
    const filtrosIniciales = FilterParams();

    final (items, total) = await service.obtenerInventarioPaginado(filtrosIniciales);

    return InventarioState(
      items: items,
      totalItems: total,
      filtros: filtrosIniciales,
    );
  }

  /// Ejecuta la recarga de datos aplicando filtros de búsqueda, relación y estados.
  /// 
  /// Comprueba la existencia del estado actual deteniendo la operación si es nulo.
  /// Determina las nuevas configuraciones para `filtroIdZapato` y `filtroEstado` evaluando banderas de limpieza.
  /// Establece temporalmente el estado en `AsyncValue.loading`.
  /// Ejecuta la consulta resguardada con `AsyncValue.guard` y actualiza la UI con la respuesta.
  Future<void> _cargarConFiltros(
    FilterParams nuevosFiltros, {
    String? idZapato,
    EstadoZapato? estado,
    bool clearZapato = false,
    bool clearEstado = false,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;

    final nextZapato = clearZapato ? null : (idZapato ?? currentState.filtroIdZapato);
    final nextEstado = clearEstado ? null : (estado ?? currentState.filtroEstado);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = await ref.read(inventarioServiceProvider.future);
      final (items, total) = await service.obtenerInventarioPaginado(
        nuevosFiltros,
        idZapato: nextZapato,
        estado: nextEstado,
      );

      return currentState.copyWith(
        items: items,
        totalItems: total,
        filtros: nuevosFiltros,
        filtroIdZapato: nextZapato,
        filtroEstado: nextEstado,
        clearZapato: clearZapato,
        clearEstado: clearEstado,
      );
    });
  }

  /// Aplica un filtro de búsqueda por texto sobre los códigos y colores del inventario.
  /// 
  /// Reinicia la página actual a 1 mediante `resetPage()` sobre los parámetros de filtro.
  /// Llama al método interno `_cargarConFiltros` para refrescar la lista.
  Future<void> buscarInventario(String query) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.copyWith(query: query).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Filtra las existencias por un zapato o por un estado del ciclo de vida específico.
  /// 
  /// Reinicia la paginación a la página 1 y activa banderas de limpieza si los parámetros son nulos.
  /// Llama a `_cargarConFiltros` para reflejar la selección en pantalla.
  Future<void> aplicarFiltrosEspeciales({String? idZapato, EstadoZapato? estado}) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.resetPage();
    await _cargarConFiltros(
      nuevosFiltros,
      idZapato: idZapato,
      estado: estado,
      clearZapato: idZapato == null,
      clearEstado: estado == null,
    );
  }

  /// Navega a la página solicitada manteniendo los filtros aplicados previamente.
  /// 
  /// Modifica el número de página en los parámetros y recarga el listado.
  Future<void> cambiarPagina(int nuevaPagina) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.copyWith(page: nuevaPagina);
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Registra una nueva unidad en el inventario y actualiza optimistamente el estado local.
  /// 
  /// Invoca al servicio para validar datos y generar automáticamente el código único.
  /// Inserta el elemento recién creado a la lista local y suma 1 al contador global de ítems.
  Future<void> crearInventario({
    required String id,
    required String idZapato,
    required double talla,
    required double cm,
    required double precioCompra,
    required DateTime fechaCompra,
    String? color,
  }) async {
    final service = await ref.read(inventarioServiceProvider.future);
    final nuevoItem = await service.crearInventario(
      id: id,
      idZapato: idZapato,
      talla: talla,
      cm: cm,
      precioCompra: precioCompra,
      fechaCompra: fechaCompra,
      color: color,
    );

    state = state.whenData((estadoActual) {
      final nuevaLista = [nuevoItem, ...estadoActual.items];
      return estadoActual.copyWith(
        items: nuevaLista,
        totalItems: estadoActual.totalItems + 1,
      );
    });
  }

  /// Actualiza los datos de un par en inventario y refleja la modificación en memoria.
  /// 
  /// Llama al método `actualizarInventario` del servicio.
  /// Mapea la lista actual reemplazando la instancia modificada sin recargar la base de datos.
  Future<void> actualizarInventario({
    required String id,
    required String idZapato,
    required double talla,
    required double cm,
    required double precioCompra,
    required DateTime fechaCompra,
    String? color,
  }) async {
    final service = await ref.read(inventarioServiceProvider.future);
    final itemActualizado = await service.actualizarInventario(
      id: id,
      idZapato: idZapato,
      talla: talla,
      cm: cm,
      precioCompra: precioCompra,
      fechaCompra: fechaCompra,
      color: color,
    );

    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.items.map((i) => i.id == id ? itemActualizado : i).toList();
      return estadoActual.copyWith(items: nuevaLista);
    });
  }

  /// Cambia la fase del ciclo de vida de un par de zapatos en inventario.
  /// 
  /// Llama a `cambiarEstado` en la capa de servicio.
  /// Actualiza la instancia en la lista local reflejando de inmediato el nuevo estado (`activo`, `reservado`, `vendido`).
  Future<void> cambiarEstadoInventario(String id, EstadoZapato nuevoEstado) async {
    final service = await ref.read(inventarioServiceProvider.future);
    final itemActualizado = await service.cambiarEstado(id, nuevoEstado);

    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.items.map((i) => i.id == id ? itemActualizado : i).toList();
      return estadoActual.copyWith(items: nuevaLista);
    });
  }

  /// Elimina una unidad del inventario verificando sus reglas de estado.
  /// 
  /// Ejecuta la eliminación a través del servicio, asegurando que no esté reservado o vendido.
  /// Remueve el objeto de la lista local y reduce en 1 el número total de existencias.
  Future<void> eliminarInventario(String id) async {
    final service = await ref.read(inventarioServiceProvider.future);
    await service.eliminarInventario(id);

    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.items.where((i) => i.id != id).toList();
      return estadoActual.copyWith(
        items: nuevaLista,
        totalItems: estadoActual.totalItems - 1,
      );
    });
  }
}

final inventarioControllerProvider = AsyncNotifierProvider<InventarioController, InventarioState>(() {
  return InventarioController();
});