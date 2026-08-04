import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart';

/// Provider para inyectar el servicio. Deberás configurarlo con tus dependencias reales.
final marcaServiceProvider = Provider<MarcaService>((ref) {
  throw UnimplementedError('Debes inicializar esto con tu MarcaDAO y checkBrandInUse');
});

/// Controlador principal de las marcas manejando su estado asíncrono
class MarcaController extends AsyncNotifier<List<Marca>> {
  
  @override
  Future<List<Marca>> build() async {
    // El estado inicial carga todas las marcas automáticamente.
    // Riverpod pondrá el estado en AsyncLoading mientras esto se resuelve.
    return await ref.read(marcaServiceProvider).obtenerTodasLasMarcas();
  }

  /// Filtra la lista de marcas. Riverpod pasará a loading y luego a data con el resultado.
  Future<void> buscarMarcas(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(marcaServiceProvider).buscarMarcas(query);
    });
  }

  /// Crea una nueva marca y actualiza el estado localmente para no hacer una nueva 
  /// consulta a la base de datos (optimistic UI update).
  Future<void> crearMarca(String id, String nombre) async {
    // Nota: No usamos try-catch aquí intencionalmente. 
    // Dejamos que las excepciones (BrandAlreadyExistsExpection, etc.) suban 
    // hacia la vista para que allá se muestre el Toast correspondiente.
    final nuevaMarca = await ref.read(marcaServiceProvider).crearMarca(id, nombre);
    
    // Si fue exitoso, agregamos la marca a la lista actual y la reordenamos
    state = state.whenData((marcas) {
      final nuevaLista = [...marcas, nuevaMarca];
      nuevaLista.sort((a, b) => a.nombreMarca.compareTo(b.nombreMarca));
      return nuevaLista;
    });
  }

  /// Actualiza una marca existente
  Future<void> actualizarMarca(String id, String nuevoNombre) async {
    final marcaActualizada = await ref.read(marcaServiceProvider).actualizarMarca(id, nuevoNombre);
    
    // Reemplazamos la marca modificada en nuestra lista actual
    state = state.whenData((marcas) {
      final nuevaLista = marcas.map((m) => m.id == id ? marcaActualizada : m).toList();
      nuevaLista.sort((a, b) => a.nombreMarca.compareTo(b.nombreMarca));
      return nuevaLista;
    });
  }

  /// Elimina una marca verificando que no esté en uso
  Future<void> eliminarMarca(String id) async {
    await ref.read(marcaServiceProvider).eliminarMarca(id);
    
    // Quitamos la marca eliminada de la lista
    state = state.whenData((marcas) {
      return marcas.where((m) => m.id != id).toList();
    });
  }
}

/// El Provider público que consumirá la Interfaz de Usuario
final marcaControllerProvider = AsyncNotifierProvider<MarcaController, List<Marca>>(() {
  return MarcaController();
});