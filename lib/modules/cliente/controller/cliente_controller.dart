import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart'; 
import 'package:variedadesjm/modules/cliente/control/cliente_dao.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/cliente/service/cliente_service.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

class ClienteState {
  final List<Cliente> clientes;
  final int totalItems;
  final FilterParams filtros;

  ClienteState({
    required this.clientes,
    required this.totalItems,
    required this.filtros,
  });

  ClienteState copyWith({
    List<Cliente>? clientes,
    int? totalItems,
    FilterParams? filtros,
  }) {
    return ClienteState(
      clientes: clientes ?? this.clientes,
      totalItems: totalItems ?? this.totalItems,
      filtros: filtros ?? this.filtros,
    );
  }
}

// --- PROVIDERS ---
final clienteDaoProvider = FutureProvider<ClienteDAO>((ref) async {
  final db = await ref.watch(sembastDatabaseProvider.future);
  return ClienteDAO(db);
});

final clienteServiceProvider = FutureProvider<ClienteService>((ref) async {
  final clienteDao = await ref.watch(clienteDaoProvider.future);
  return ClienteService(
    clienteDao: clienteDao,
    checkClientInUse: (clienteId) async {
      // TODO: Conectar con el DAO de Ventas/Facturas cuando esté listo
      return false; 
    },
  );
});

// --- CONTROLLER ---
class ClienteController extends AsyncNotifier<ClienteState> {
  
  @override
  Future<ClienteState> build() async {
    final service = await ref.watch(clienteServiceProvider.future);
    const filtrosIniciales = FilterParams();
    final (clientes, total) = await service.obtenerClientesPaginados(filtrosIniciales);
    
    return ClienteState(
      clientes: clientes,
      totalItems: total,
      filtros: filtrosIniciales,
    );
  }

  Future<void> _cargarConFiltros(FilterParams nuevosFiltros) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = await ref.read(clienteServiceProvider.future);
      final (clientes, total) = await service.obtenerClientesPaginados(nuevosFiltros);
      
      return ClienteState(
        clientes: clientes,
        totalItems: total,
        filtros: nuevosFiltros,
      );
    });
  }

  Future<void> buscarClientes(String query) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.copyWith(query: query).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  Future<void> cambiarPagina(int nuevaPagina) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.copyWith(page: nuevaPagina);
    await _cargarConFiltros(nuevosFiltros);
  }

  Future<void> cambiarOrden(SortDirection nuevaDireccion) async {
    if (state.value == null) return;
    final nuevosFiltros = state.value!.filtros.copyWith(sortDirection: nuevaDireccion).resetPage();
    await _cargarConFiltros(nuevosFiltros);
  }

  Future<void> crearCliente(String id, String nombre, String apellido, String telefono, String? direccion) async {
    final service = await ref.read(clienteServiceProvider.future);
    final nuevoCliente = await service.crearCliente(
      id: id, nombre: nombre, apellido: apellido, telefono: telefono, direccion: direccion
    );
    
    state = state.whenData((estadoActual) {
      final nuevaLista = [...estadoActual.clientes, nuevoCliente];
      nuevaLista.sort((a, b) => a.nombre.compareTo(b.nombre));
      
      return estadoActual.copyWith(
        clientes: nuevaLista,
        totalItems: estadoActual.totalItems + 1,
      );
    });
  }

  Future<void> actualizarCliente(String id, String nombre, String apellido, String telefono, String? direccion) async {
    final service = await ref.read(clienteServiceProvider.future);
    final clienteActualizado = await service.actualizarCliente(
      id: id, nombre: nombre, apellido: apellido, telefono: telefono, direccion: direccion
    );
    
    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.clientes
          .map((c) => c.id == id ? clienteActualizado : c)
          .toList();
      nuevaLista.sort((a, b) => a.nombre.compareTo(b.nombre));
      
      return estadoActual.copyWith(clientes: nuevaLista);
    });
  }

  Future<void> eliminarCliente(String id) async {
    final service = await ref.read(clienteServiceProvider.future);
    await service.eliminarCliente(id);
    
    state = state.whenData((estadoActual) {
      final nuevaLista = estadoActual.clientes.where((c) => c.id != id).toList();
      return estadoActual.copyWith(
        clientes: nuevaLista,
        totalItems: estadoActual.totalItems - 1,
      );
    });
  }
}

final clienteControllerProvider =
    AsyncNotifierProvider<ClienteController, ClienteState>(() {
  return ClienteController();
});