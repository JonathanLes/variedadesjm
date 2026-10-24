/// Verifica que el shell principal presenta el dashboard de Variedades JM.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/main.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';

void main() {
  testWidgets('el dashboard inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardDataProvider.overrideWith(
            (ref) async => const DashboardData(
                ventas: [],
                gastos: [],
                reservas: [],
                existencias: [],
              ),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Buenos días, equipo'), findsOneWidget);
    expect(find.text('Actividad de ventas'), findsOneWidget);
  });
}
