import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';

// ===========================================================================
// CLASES DUMMY PARA TESTING
// ===========================================================================

class DummyEntity {
  final String id;
  final String name;

  DummyEntity(this.id, this.name);
}

class DummyDao extends SembastDao<DummyEntity> {
  DummyDao(Database database) : super(database, 'dummy_store');

  @override
  DummyEntity fromJson(Map<String, dynamic> json) {
    if (json['name'] == 'ERROR') {
      throw FormatException('Error forzado al parsear JSON');
    }
    return DummyEntity(json['id'] as String, json['name'] as String);
  }

  @override
  Map<String, dynamic> toJson(DummyEntity item) {
    if (item.name.isEmpty) return {};
    return {'id': item.id, 'name': item.name};
  }
}

class DummyDaoWithStore extends SembastDao<DummyEntity> {
  DummyDaoWithStore(Database db, StoreRef<String, Map<String, dynamic>> store)
    : super.withStore(db, store);

  @override
  DummyEntity fromJson(Map<String, dynamic> json) => DummyEntity('', '');

  @override
  Map<String, dynamic> toJson(DummyEntity item) => {};
}

// ===========================================================================
// SUITE DE PRUEBAS
// ===========================================================================

void main() {
  late Database db;
  late DummyDao dao;

  /// Se ejecuta antes de cada test. Crea una BD en memoria fresca y limpia.
  setUp(() async {
    final factory = newDatabaseFactoryMemory();
    db = await factory.openDatabase('test_db.db');
    dao = DummyDao(db);
  });

  /// Se ejecuta después de cada test para liberar memoria.
  tearDown(() async {
    await db.close();
  });

  group('1. Validaciones de Parámetros (ArgumentError)', () {
    test('findRange lanza ArgumentError si offset es menor a 0', () {
      expect(() => dao.findRange(offset: -1), throwsA(isA<ArgumentError>()));
    });

    test('findRange lanza ArgumentError si limit es menor o igual a 0', () {
      expect(() => dao.findRange(limit: 0), throwsA(isA<ArgumentError>()));
    });

    test(
      'findById, put y delete lanzan ArgumentError si el ID está vacío',
      () async {
        const emptyId = '   ';

        expect(() => dao.findById(emptyId), throwsA(isA<ArgumentError>()));
        expect(() => dao.delete(emptyId), throwsA(isA<ArgumentError>()));
        expect(
          () => dao.put(emptyId, DummyEntity('1', 'Test')),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('put lanza ArgumentError si el JSON resultante está vacío', () {
      // Nuestro DummyDao retorna un mapa vacío si el nombre está vacío.
      final emptyItem = DummyEntity('1', '');

      expect(() => dao.put('1', emptyItem), throwsA(isA<ArgumentError>()));
    });
  });

  group('2. Rutas Lógicas / "No encontrados"', () {
    test('findById retorna null si el registro no existe', () async {
      final result = await dao.findById('id_inexistente');
      expect(result, isNull);
    });

    test(
      'delete retorna false si se intenta borrar un registro que no existe',
      () async {
        final result = await dao.delete('id_inexistente');
        expect(result, isFalse);
      },
    );

    test('put y findById operan correctamente en el flujo feliz', () async {
      final item = DummyEntity('1', 'Zapato');

      await dao.put('1', item);
      final result = await dao.findById('1');

      expect(result, isNotNull);
      expect(result!.name, 'Zapato');
    });
  });

  group('3. Manejo de Excepciones Internas (DaoException)', () {
    test('Las excepciones de Sembast se envuelven en DaoException', () async {
      // Forzamos un error de base de datos cerrándola antes de la consulta
      await db.close();

      expect(
        () => dao.count(),
        throwsA(
          isA<DaoException>().having(
            (e) => e.message,
            'message',
            contains('Error específico de Sembast'),
          ),
        ),
      );
    });
  });

  group('4. Cobertura Restante (toString, withStore, findRange éxito, catch genérico)', () {
    test('DaoException.toString formatea correctamente con y sin causa', () {
      final excepcionSimple = DaoException('Fallo la conexión');
      expect(excepcionSimple.toString(), 'DaoException: Fallo la conexión');

      final excepcionConCausa = DaoException('Fallo la conexión', 'Timeout');
      expect(excepcionConCausa.toString(), 'DaoException: Fallo la conexión (Causa: Timeout)');
    });

    test('SembastDao.withStore inicializa el store inyectado', () {
      // Usamos el DummyDaoWithStore que ya creaste en la parte superior
      final storeInyectado = StoreRef<String, Map<String, dynamic>>('tienda_personalizada');
      final daoStore = DummyDaoWithStore(db, storeInyectado);
      
      expect(daoStore.store.name, 'tienda_personalizada');
    });

    test('findRange retorna y pagina la lista de registros con éxito', () async {
      await dao.put('1', DummyEntity('1', 'A'));
      await dao.put('2', DummyEntity('2', 'B'));
      await dao.put('3', DummyEntity('3', 'C'));

      final todos = await dao.findRange();
      expect(todos.length, 3);

      final paginado = await dao.findRange(offset: 1, limit: 1);
      expect(paginado.length, 1);
      expect(paginado.first.name, 'B'); 
    });

    test('catch genérico atrapa errores inesperados y preserva la traza', () async {
      await dao.put('error_id', DummyEntity('error_id', 'ERROR'));

      expect(
        () => dao.findById('error_id'),
        throwsA(
          isA<DaoException>().having(
            (e) => e.message,
            'message',
            contains('Error inesperado en findById'),
          ),
        ),
      );
    });
  });
}
