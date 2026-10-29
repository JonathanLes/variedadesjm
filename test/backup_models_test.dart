import 'package:flutter_test/flutter_test.dart';
import 'package:variedadesjm/modules/backup/service/backup_models.dart';

void main() {
  test('nombre de archivo y fecha hacen ida y vuelta', () {
    final fecha = DateTime(2026, 10, 29, 8, 5, 9);
    final nombre = backupFileName('Cierre de mes!', fecha);
    expect(nombre, 'variedadesjm_Cierre_de_mes_20261029_080509.json');
    expect(parseBackupDate(nombre), fecha);
    expect(backupDisplayName(nombre), 'Cierre de mes');
    expect(isBackupFile(nombre), isTrue);
  });

  test('nombre vacío usa "copia" y las fotos no cuentan como copias', () {
    expect(backupFileName('  ', DateTime(2026, 1, 2, 3, 4, 5)),
        'variedadesjm_copia_20260102_030405.json');
    expect(isBackupFile('variedadesjm_foto_zapato_1.jpg'), isFalse);
    expect(isBackupFile('otra_cosa.json'), isFalse);
  });

  test('payload se serializa y se lee igual', () {
    final payload = BackupPayload(
      schemaVersion: backupSchemaVersion,
      exportedAt: DateTime.utc(2026, 10, 29),
      stores: {
        'marca': [
          {'key': 'm1', 'value': {'nombre': 'Nike'}},
        ],
      },
    );
    final leido = BackupPayload.fromJson(payload.toJson());
    expect(leido.schemaVersion, backupSchemaVersion);
    expect(leido.stores['marca']!.single['key'], 'm1');
    expect(photoBaseName('/data/user/0/app/zapato_1.jpg'), 'zapato_1.jpg');
  });
}
