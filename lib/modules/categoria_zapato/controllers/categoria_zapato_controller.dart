import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart'; 
import 'package:variedadesjm/modules/categoria_zapato/control/categoria_zapato_dao.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/categoria_zapato/service/categoria_zapato_service.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class CategoriaZapatoState {
  final List<CategoriaZapato> categorias;
  final int totalItems;
  final FilterParams filtros;

  CategoriaZapatoState({
    required this.categorias,
    required this.totalItems,
    required this.filtros,
  });

  /// Crea una copia del estado actual permitiendo modificar solo los campos especificados.
  CategoriaZapatoState copyWith({
    List<CategoriaZapato>? categorias,
    int? totalItems,
    FilterParams? filtros,
  }) {
    return CategoriaZapatoState(
      categorias: categorias ?? this.categorias,
      totalItems: totalItems ?? this.totalItems,
      filtros: filtros ?? this.filtros,
    );
  }
}

final categoriaZapatoDaoProvider = FutureProvider<CategoriaZapatoDAO>((ref) async {
  final db = await ref.watch(sembastDatabaseProvider.future);
  return CategoriaZapatoDAO(db);
});

final categoriaZapatoServiceProvider = FutureProvider<CategoriaZapatoService>((ref) async {
  final categoriaDao = await ref.watch(categoriaZapatoDaoProvider.future);

  return CategoriaZapatoService(
    categoriaDao: categoriaDao,
    checkCategoryInUse: (categoriaId) async {
      // TODO: Conectar con el DAO de Zapatos/Productos cuando lo construyas
      return false;
    },
  );
});

class CategoriaZapatoController extends AsyncNotifier<CategoriaZapatoState> {
  
  /// Inicializa el estado cargando la lista inicial de categorías paginadas y sus filtros por defecto.
  @override
  Future<CategoriaZapatoState> build() async {
    final service = await ref.watch(categoriaZapatoServiceProvider.future);
    
    const filtrosIniciales = FilterParams();
    
    final (categorias, total) = await service.obtenerCategoriasPaginadas(filtrosIniciales);
    
    return CategoriaZapatoState(
      categorias: categorias,
      totalItems: total,
      filtros: filtrosIniciales,
    );
  }

  /// Carga y actualiza el estado con una nueva combinación de filtros aplicados.
  Future<void> _cargarConFiltros(FilterParams nuevosFiltros) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final service = await ref.read(categoriaZapatoServiceProvider.future);
      final (categorias, total) = await service.obtenerCategoriasPaginadas(nuevosFiltros);
      
      return CategoriaZapatoState(
        categorias: categorias,
        totalItems: total,
        filtros: nuevosFiltros,
      );
    });
  }

  /// Aplica el filtro de búsqueda por texto y reinicia la paginación a la primera página.
  Future<void> buscarCategorias(String query) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(query: query).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Cambia la página actual del listado de categorías.
  Future<void> cambiarPagina(int nuevaPagina) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(page: nuevaPagina);
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Modifica la dirección del ordenamiento (A-Z o Z-A) y reinicia la paginación a la primera página.
  Future<void> cambiarOrden(SortDirection nuevaDireccion) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(sortDirection: nuevaDireccion).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Crea una nueva categoría en la base de datos y la inserta ordenadamente en el estado local.
  Future<void> crearCategoria(String id, String nombre) async {
    final service = await ref.read(categoriaZapatoServiceProvider.future);
    final nuevaCategoria = await service.crearCategoria(id, nombre);
    
    state = state.whenData((estadoActual) {
      final nuevaLista = [...estadoActual.categorias, nuevaCategoria];
      nuevaLista.sort((a, b) => a.nombreCategoria.compareTo(b.nombreCategoria));
      
      return estadoActual.copyWith(
        categorias: nuevaLista,
        totalItems: estadoActual.totalItems + 1,
      );
    });
  }

  /// Actualiza los datos de una categoría existente y mantiene la lista ordenada localmente.
  Future<void> actualizarCategoria(String id, String nuevoNombre) async {
    final service = await ref.read(categoriaZapatoServiceProvider.future);
    final categoriaActualizada = await service.actualizarCategoria(id, nuevoNombre);
    
    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.categorias
          .map((c) => c.id == id ? categoriaActualizada : c)
          .toList();
      nuevaLista.sort((a, b) => a.nombreCategoria.compareTo(b.nombreCategoria));
      
      return estadoActual.copyWith(categorias: nuevaLista);
    });
  }

  /// Elimina una categoría por su ID y actualiza el contador e inventario local.
  Future<void> eliminarCategoria(String id) async {
    final service = await ref.read(categoriaZapatoServiceProvider.future);
    await service.eliminarCategoria(id);
    
    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.categorias.where((c) => c.id != id).toList();
      
      return estadoActual.copyWith(
        categorias: nuevaLista,
        totalItems: estadoActual.totalItems - 1,
      );
    });
  }

  /// Filtra la lista de categorías según la letra inicial especificada o la limpia si se envía nulo.
  Future<void> cambiarLetra(String? letra) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(initialLetter: letra ?? '').resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }
}

final categoriaZapatoControllerProvider =
    AsyncNotifierProvider<CategoriaZapatoController, CategoriaZapatoState>(() {
  return CategoriaZapatoController();
});