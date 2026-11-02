import 'package:flutter_test/flutter_test.dart';
import 'package:variedadesjm/modules/configuracion/service/photo_cleanup.dart';
import 'package:variedadesjm/shared/utils/image_store.dart';

void main() {
  test('detecta solo fotos de la app que ningún modelo usa', () {
    final todos = ['zapato_1.jpg', 'zapato_2.jpg', 'variedadesjm.db', 'otra.png'];
    expect(nombresHuerfanos(todos, {'zapato_1.jpg'}), ['zapato_2.jpg']);
    expect(nombresHuerfanos(todos, {'zapato_1.jpg', 'zapato_2.jpg'}), isEmpty);
  });

  test('reconoce el nombre de las fotos de la app', () {
    expect(esFotoDeZapato('zapato_123.jpg'), isTrue);
    expect(esFotoDeZapato('IMG_001.jpg'), isFalse);
  });

  test('formatea tamaños', () {
    expect(formatoBytes(500), '500 B');
    expect(formatoBytes(1536), '1.5 KB');
    expect(formatoBytes(5 * 1024 * 1024), '5.0 MB');
  });
}
