import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart'; 
import 'package:variedadesjm/modules/marca/control/marca_dao.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart';
// Importación del modelo de filtros universal
import 'package:variedadesjm/shared/models/filter_params.dart';

/// Representa el estado completo y reactivo de la pantalla de marcas.
/// 
/// Agrupa la lista de datos, el conteo total para la paginación y 
/// los parámetros de búsqueda actuales en un solo objeto inmutable.
class MarcaState {
  /// Lista de marcas que se están mostrando en la página actual.
  final List<Marca> marcas;
  
  /// Total de marcas en la base de datos que coinciden con los filtros.
  final int totalItems;
  
  /// Los parámetros actuales (búsqueda, orden, página) aplicados a la vista.
  final FilterParams filtros;

  MarcaState({
    required this.marcas,
    required this.totalItems,
    required this.filtros,
  });

  /// Crea una copia del estado actual permitiendo modificar solo campos específicos.
  MarcaState copyWith({
    List<Marca>? marcas,
    int? totalItems,
    FilterParams? filtros,
  }) {
    return MarcaState(
      marcas: marcas ?? this.marcas,
      totalItems: totalItems ?? this.totalItems,
      filtros: filtros ?? this.filtros,
    );
  }
}

// Provider asíncrono para el MarcaDAO
final marcaDaoProvider = FutureProvider<MarcaDAO>((ref) async {
  final db = await ref.watch(sembastDatabaseProvider.future);
  return MarcaDAO(db);
});

// Provider asíncrono para MarcaService
final marcaServiceProvider = FutureProvider<MarcaService>((ref) async {
  final marcaDao = await ref.watch(marcaDaoProvider.future);

  return MarcaService(
    marcaDao: marcaDao,
    checkBrandInUse: (marcaId) async {
      // TODO: Conectar con el DAO de Productos/Zapatos cuando lo construyas
      return false;
    },
  );
});

/// Controlador principal de la vista de Marcas.
/// 
/// Gestiona las peticiones a la base de datos y mantiene sincronizada la 
/// interfaz gráfica con los datos, la paginación y los filtros aplicados.
class MarcaController extends AsyncNotifier<MarcaState> {
  
  @override
  Future<MarcaState> build() async {
    // Obtenemos el servicio esperando que resuelva el Future
    final service = await ref.watch(marcaServiceProvider.future);
    
    // Iniciamos con los filtros por defecto (página 1, orden A-Z, sin texto)
    const filtrosIniciales = FilterParams();
    
    // Llamamos a nuestro nuevo método del Service que devuelve el Record (Lista y Total)
    final (marcas, total) = await service.obtenerMarcasPaginadas(filtrosIniciales);
    
    return MarcaState(
      marcas: marcas,
      totalItems: total,
      filtros: filtrosIniciales,
    );
  }

  /// Método privado centralizado para recargar los datos cuando un filtro cambia.
  /// 
  /// Pone el estado en `loading` temporalmente y luego emite el nuevo estado con 
  /// la información actualizada desde Sembast.
  Future<void> _cargarConFiltros(FilterParams nuevosFiltros) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final service = await ref.read(marcaServiceProvider.future);
      final (marcas, total) = await service.obtenerMarcasPaginadas(nuevosFiltros);
      
      return MarcaState(
        marcas: marcas,
        totalItems: total,
        filtros: nuevosFiltros,
      );
    });
  }

  /// Actualiza el texto de búsqueda en los filtros.
  /// 
  /// Al buscar un nuevo término, la paginación se reinicia a la página 1.
  Future<void> buscarMarcas(String query) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(query: query).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Navega a una página específica del listado de marcas.
  Future<void> cambiarPagina(int nuevaPagina) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(page: nuevaPagina);
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Cambia el ordenamiento (A-Z o Z-A) de la lista.
  /// 
  /// Al cambiar el orden, la paginación se reinicia a la página 1.
  Future<void> cambiarOrden(SortDirection nuevaDireccion) async {
    if (state.value == null) return;
    
    final nuevosFiltros = state.value!.filtros.copyWith(sortDirection: nuevaDireccion).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  /// Crea una nueva marca y actualiza el estado local para evitar recargar toda la BD.
  Future<void> crearMarca(String id, String nombre) async {
    final service = await ref.read(marcaServiceProvider.future);
    final nuevaMarca = await service.crearMarca(id, nombre);
    
    state = state.whenData((estadoActual) {
      // Agregamos la nueva marca a la lista actual
      final nuevaLista = [...estadoActual.marcas, nuevaMarca];
      // Reordenamos en memoria para que encaje visualmente de inmediato
      nuevaLista.sort((a, b) => a.nombreMarca.compareTo(b.nombreMarca));
      
      return estadoActual.copyWith(
        marcas: nuevaLista,
        totalItems: estadoActual.totalItems + 1, // Sumamos 1 al contador total
      );
    });
  }

  /// Actualiza el nombre de una marca existente y refleja el cambio en la UI.
  Future<void> actualizarMarca(String id, String nuevoNombre) async {
    final service = await ref.read(marcaServiceProvider.future);
    final marcaActualizada = await service.actualizarMarca(id, nuevoNombre);
    
    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.marcas.map((m) => m.id == id ? marcaActualizada : m).toList();
      nuevaLista.sort((a, b) => a.nombreMarca.compareTo(b.nombreMarca));
      
      return estadoActual.copyWith(marcas: nuevaLista);
    });
  }

  /// Elimina una marca y la remueve del estado local de la interfaz.
  Future<void> eliminarMarca(String id) async {
    final service = await ref.read(marcaServiceProvider.future);
    await service.eliminarMarca(id);
    
    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.marcas.where((m) => m.id != id).toList();
      
      return estadoActual.copyWith(
        marcas: nuevaLista,
        totalItems: estadoActual.totalItems - 1, // Restamos 1 al contador total
      );
    });
  }

  /// Filtra la lista por la letra inicial. Si es null, quita el filtro.
  Future<void> cambiarLetra(String? letra) async {
    if (state.value == null) return;
    
    // Si la letra es null, mandamos un string vacío para que el copyWith lo vuelva null
    final nuevosFiltros = state.value!.filtros.copyWith(initialLetter: letra ?? '').resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }
}


// Provider global para exponer el MarcaController a la UI
final marcaControllerProvider = AsyncNotifierProvider<MarcaController, MarcaState>(() {
  return MarcaController();
});