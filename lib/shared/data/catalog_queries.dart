/// Consultas livianas a los catálogos (marcas, categorías...) para los selectores.
///
/// En lugar de cargar todo el catálogo en memoria, cada consulta pide a la base
/// solo una página de resultados, filtrada por texto. Así el consumo de memoria
/// no crece con el número de marcas o categorías, y como se consulta cada vez
/// que se abre el selector, siempre muestra los datos más recientes.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/widgets/forms/paged_picker.dart';

/// Crea la función de búsqueda paginada para un catálogo.
///
/// [store] es el nombre del store de Sembast y [field] el campo que se muestra
/// y por el que se busca (por ejemplo `nombreMarca`).
PickerFetch catalogFetch(WidgetRef ref, {required String store, required String field}) {
  return (query, offset, limit) async {
    final database = await ref.read(sembastDatabaseProvider.future);
    final needle = AppColors.normalize(query);
    final finder = Finder(
      filter: needle.isEmpty
          ? null
          : Filter.custom((snapshot) {
              final value = snapshot.value;
              if (value is! Map) return false;
              return AppColors.normalize('${value[field] ?? ''}').contains(needle);
            }),
      sortOrders: [SortOrder(field)],
      offset: offset,
      limit: limit,
    );
    final rows = await stringMapStoreFactory.store(store).find(database, finder: finder);
    return [
      for (final row in rows)
        PickerOption(id: row.key, label: '${row.value[field] ?? ''}'),
    ];
  };
}

/// Busca el nombre de un registro por su id (para mostrar la selección actual).
PickerResolve catalogResolve(WidgetRef ref, {required String store, required String field}) {
  return (id) async {
    final database = await ref.read(sembastDatabaseProvider.future);
    final value = await stringMapStoreFactory.store(store).record(id).get(database);
    if (value == null) return null;
    return PickerOption(id: id, label: '${value[field] ?? ''}');
  };
}
