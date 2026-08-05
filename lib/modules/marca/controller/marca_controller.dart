import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart'; 
import 'package:variedadesjm/modules/marca/control/marca_dao.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart';

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

// Controlador principal ajustado para esperar el marcaServiceProvider
class MarcaController extends AsyncNotifier<List<Marca>> {
  
  @override
  Future<List<Marca>> build() async {
    // Obtenemos el servicio esperando que resuelva el Future
    final service = await ref.watch(marcaServiceProvider.future);
    return await service.obtenerTodasLasMarcas();
  }

  Future<void> buscarMarcas(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = await ref.read(marcaServiceProvider.future);
      return await service.buscarMarcas(query);
    });
  }

  Future<void> crearMarca(String id, String nombre) async {
    final service = await ref.read(marcaServiceProvider.future);
    final nuevaMarca = await service.crearMarca(id, nombre);
    
    state = state.whenData((marcas) {
      final nuevaLista = [...marcas, nuevaMarca];
      nuevaLista.sort((a, b) => a.nombreMarca.compareTo(b.nombreMarca));
      return nuevaLista;
    });
  }

  Future<void> actualizarMarca(String id, String nuevoNombre) async {
    final service = await ref.read(marcaServiceProvider.future);
    final marcaActualizada = await service.actualizarMarca(id, nuevoNombre);
    
    state = state.whenData((marcas) {
      final nuevaLista = marcas.map((m) => m.id == id ? marcaActualizada : m).toList();
      nuevaLista.sort((a, b) => a.nombreMarca.compareTo(b.nombreMarca));
      return nuevaLista;
    });
  }

  Future<void> eliminarMarca(String id) async {
    final service = await ref.read(marcaServiceProvider.future);
    await service.eliminarMarca(id);
    
    state = state.whenData((marcas) {
      return marcas.where((m) => m.id != id).toList();
    });
  }
}

final marcaControllerProvider = AsyncNotifierProvider<MarcaController, List<Marca>>(() {
  return MarcaController();
});