import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/controllers/marca_dao.dart';
import 'package:variedadesjm/entity/marca.dart';

void main(){
  late Database db;
  late MarcaDAO cut;


  /// Configuración inicial antes de cada prueba.
  /// Crea una base de datos en memoria efímera para aislar el entorno
  /// y asegurar que las pruebas no consuman recursos innecesarios ni afecten datos reales.
  setUp(() async {
    final factory = newDatabaseFactoryMemory();
    db = await factory.openDatabase("test_db.db");
    cut = MarcaDAO(db);
  });

  /// Limpieza después de cada prueba.
  /// Cierra la conexión a la base de datos para liberar la memoria RAM.
  tearDown(() async {
    await db.close();
  });

  /// Verifica que el DAO esté apuntando a la "tienda" (store) correcta.
  /// Esto previene errores críticos donde los datos de una marca
  /// se guarden accidentalmente en la tabla de otra entidad.
  test("La cut debe inicializarse con el store de marcas", (){
    expect(cut.store.name, SembastStores.marca);
  });

  test("toJson y fromJson mapean correctamente la entidad Marca", (){
    const marca = Marca(id: "123", nombreMarca: "NIKE");

    final jsonGenerado = cut.toJson(marca);
    expect(jsonGenerado["id"], "123");
    expect(jsonGenerado["nombreMarca"], "NIKE");

    final marcaReconstruida = cut.fromJson(jsonGenerado);
    expect(marcaReconstruida.id, "123");
    expect(marcaReconstruida.nombreMarca, "NIKE");
  });

  /// Comprueba que Freezed detecte estructuras JSON inválidas o incompletas,
  /// arrojando un error de tipo (TypeError) al intentar reconstruir la entidad
  /// si faltan campos obligatorios en el registro de la base de datos.
  test('fromJson lanza error si el JSON no tiene los campos requeridos', () {
    // Falta el campo requerido 'nombreMarca'
    final jsonCorrupto = {'id': '123'}; 
    
    expect(
      () => cut.fromJson(jsonCorrupto),
      throwsA(isA<TypeError>()), 
    );
  });
}