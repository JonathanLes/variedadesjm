import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';

import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/control/marca_dao.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart'; 

void main() {
  late Database db;
  late MarcaDAO dao;
  late MarcaService cut;
  
  /// Variable bandera para simular dinámicamente si la marca está en uso
  /// durante los tests de eliminación sin necesidad de librerías externas.
  late bool isBrandInUseResult;

  /// Configuración inicial antes de cada prueba.
  /// Crea una base de datos en memoria efímera para aislar el entorno,
  /// inicializa el DAO real y se lo inyecta al servicio[cite: 2].
  setUp(() async {
    final factory = newDatabaseFactoryMemory();
    db = await factory.openDatabase("test_db.db");
    
    dao = MarcaDAO(db);
    isBrandInUseResult = false; 

    cut = MarcaService(
      marcaDao: dao,
      checkBrandInUse: (String id) async => isBrandInUseResult,
    );
  });

  /// Limpieza después de cada prueba.
  /// Cierra la conexión a la base de datos para liberar la memoria RAM[cite: 2].
  tearDown(() async {
    await db.close();
  });

  group('1. Lógica Auxiliar y Normalización', () {
    test('normalizeBrandName elimina espacios extremos e intermedios y pasa a mayúsculas', () {
      expect(normalizeBrandName('  nike  '), 'NIKE');
      expect(normalizeBrandName('Puma '), 'PUMA');
      expect(normalizeBrandName(' a d i d a s '), 'ADIDAS');
      expect(normalizeBrandName('NEW   BALANCE'), 'NEWBALANCE'); 
    });
  });

  group('2. Creación de Marcas', () {
    test('crearMarca persiste la entidad en la base de datos en el flujo feliz', () async {
      final result = await cut.crearMarca('1', 'Adidas');

      expect(result.id, '1');
      expect(result.nombreMarca, 'ADIDAS');
      
      // Verificamos en el DAO real que la marca se guardó
      final dbMarca = await dao.findById('1');
      expect(dbMarca, isNotNull);
      expect(dbMarca!.nombreMarca, 'ADIDAS');
    });

    test('crearMarca lanza BrandNameRequeridedExpection si el nombre está vacío', () async {
      expect(
        () => cut.crearMarca('1', '   '),
        throwsA(isA<BrandNameRequeridedExpection>()),
      );
      
      // Verificamos que no se haya guardado nada en la BD
      final todos = await dao.findRange();
      expect(todos, isEmpty);
    });

    test('crearMarca lanza BrandNameTooShortExpection si el nombre es < 2', () async {
      expect(
        () => cut.crearMarca('1', ' n '),
        throwsA(isA<BrandNameTooShortExpection>()),
      );
    });

    test('crearMarca lanza BrandNameTooLongExpection si excede los límites', () async {
      final longName = 'A' * 51; 
      expect(
        () => cut.crearMarca('1', longName),
        throwsA(isA<BrandNameTooLongExpection>()),
      );
    });

    test('crearMarca lanza BrandAlreadyExistsExpection ante colisión de nombres', () async {
      // Pre-poblamos la base de datos con una marca
      await dao.put('2', const Marca(id: '2', nombreMarca: 'NIKE'));

      expect(
        () => cut.crearMarca('1', 'NiKe'),
        throwsA(isA<BrandAlreadyExistsExpection>()),
      );
      
      // Verificamos que la marca '1' nunca se creó
      final intentoFallido = await dao.findById('1');
      expect(intentoFallido, isNull);
    });
  });

  group('3. Actualización de Marcas', () {
    test('actualizarMarca modifica el registro en la base de datos', () async {
      // Pre-poblamos
      await dao.put('1', const Marca(id: '1', nombreMarca: 'PUMA'));

      final result = await cut.actualizarMarca('1', 'Reebok');

      expect(result.nombreMarca, 'REEBOK');
      
      // Verificamos en la BD real
      final dbMarca = await dao.findById('1');
      expect(dbMarca!.nombreMarca, 'REEBOK');
    });

    test('actualizarMarca permite guardar el mismo nombre (omite colisión consigo misma)', () async {
      await dao.put('1', const Marca(id: '1', nombreMarca: 'PUMA'));

      final result = await cut.actualizarMarca('1', '  PUMA  ');

      expect(result.nombreMarca, 'PUMA');
    });

    test('actualizarMarca lanza BrandNotFoundExpection si el ID no existe', () async {
      expect(
        () => cut.actualizarMarca('99', 'Reebok'),
        throwsA(isA<BrandNotFoundExpection>()),
      );
    });

    test('actualizarMarca lanza BrandAlreadyExistsExpection si colisiona con OTRA marca', () async {
      await dao.put('1', const Marca(id: '1', nombreMarca: 'PUMA'));
      await dao.put('2', const Marca(id: '2', nombreMarca: 'ADIDAS'));

      expect(
        () => cut.actualizarMarca('1', 'Adidas'), 
        throwsA(isA<BrandAlreadyExistsExpection>()),
      );
      
      // Aseguramos que la marca '1' siga llamándose PUMA
      final dbMarca = await dao.findById('1');
      expect(dbMarca!.nombreMarca, 'PUMA');
    });
  });

  group('4. Eliminación de Marcas', () {
    test('eliminarMarca borra el registro de la BD si existe y no tiene ataduras', () async {
      await dao.put('1', const Marca(id: '1', nombreMarca: 'VANS'));
      isBrandInUseResult = false; 

      await cut.eliminarMarca('1');

      // Verificamos que ya no exista en la BD
      final dbMarca = await dao.findById('1');
      expect(dbMarca, isNull);
    });

    test('eliminarMarca lanza BrandNotFoundExpection si el registro no existe', () async {
      expect(
        () => cut.eliminarMarca('99'),
        throwsA(isA<BrandNotFoundExpection>()),
      );
    });

    test('eliminarMarca lanza BrandInUseExpection bloqueando el borrado si está en uso', () async {
      await dao.put('1', const Marca(id: '1', nombreMarca: 'VANS'));
      isBrandInUseResult = true; 

      expect(
        () => cut.eliminarMarca('1'),
        throwsA(isA<BrandInUseExpection>()),
      );
      
      // Verificamos que la marca siga intacta en la base de datos
      final dbMarca = await dao.findById('1');
      expect(dbMarca, isNotNull); 
    });
  });

  group('5. Excepciones de Dominio', () {
    test('Las excepciones devuelven el mensaje correcto en su toString()', () {
      expect(
        BrandNameRequeridedExpection().toString(),
        "El nombre de la marca es obligatorio y no puede estar vacío",
      );

      expect(
        BrandNameTooShortExpection().toString(),
        "El nombre de la marca debe tener al menos 2 carácteres",
      );

      expect(
        BrandNameTooLongExpection().toString(),
        "El nombre de la marca no puede tener más de 50 carácteres",
      );

      expect(
        BrandAlreadyExistsExpection().toString(),
        "Ya existe una marca registrada con ese nombre",
      );

      expect(
        BrandNotFoundExpection().toString(),
        "No existe una marca con ese nombre o ya fue eliminada",
      );

      expect(
        BrandInUseExpection().toString(),
        "No se puede eliminar la marca porque ya tiene productos asociados",
      );
    });
  });
}