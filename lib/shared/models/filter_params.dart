/// Define la dirección de ordenamiento para las consultas a la base de datos.
enum SortDirection {
  /// Orden ascendente (A-Z, 0-9, o más antiguo primero)
  asc,
  
  /// Orden descendente (Z-A, 9-0, o más reciente primero)
  desc,
}

/// Modelo universal que agrupa todos los parámetros de filtrado, búsqueda y paginación.
///
/// Este objeto centraliza el estado de la interfaz gráfica para enviarlo 
/// como una única instrucción a los repositorios (DAOs) de Sembast.
class FilterParams {
  /// Texto ingresado en la barra de búsqueda.
  final String query;

  /// Letra seleccionada en el filtro alfabético. 
  /// Si es nulo, no se aplica filtro por letra inicial.
  final String? initialLetter;

  /// Dirección en la que se ordenarán los resultados (Ascendente o Descendente).
  final SortDirection sortDirection;

  /// Número de la página actual que está visualizando el usuario (Inicia en 1).
  final int page;

  /// Cantidad máxima de registros que se deben traer por cada página.
  final int pageSize;

  /// Crea una instancia de [FilterParams] con valores por defecto.
  /// 
  /// Por defecto, inicia sin texto de búsqueda, sin letra seleccionada,
  /// ordenado de la A a la Z, en la página 1 y mostrando 10 registros.
  const FilterParams({
    this.query = '',
    this.initialLetter,
    this.sortDirection = SortDirection.asc,
    this.page = 1,
    this.pageSize = 10,
  });

  /// Crea una copia exacta de este objeto, permitiendo sobrescribir
  /// solo los campos que se envíen por parámetro.
  ///
  /// Es vital para mantener la inmutabilidad requerida por Riverpod.
  FilterParams copyWith({
    String? query,
    String? initialLetter,
    SortDirection? sortDirection,
    int? page,
    int? pageSize,
  }) {
    return FilterParams(
      query: query ?? this.query,
      // Si explicitamente queremos limpiar la letra, pasamos una cadena vacía en este copyWith 
      // y la convertimos a null. De lo contrario, conservamos la actual.
      initialLetter: initialLetter == '' ? null : (initialLetter ?? this.initialLetter),
      sortDirection: sortDirection ?? this.sortDirection,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  /// Método auxiliar que retorna una copia de los parámetros reseteando la página a 1.
  /// 
  /// **Regla de negocio:** Siempre que un usuario cambia un filtro 
  /// (ej. escribe una nueva búsqueda o cambia el orden), la paginación 
  /// debe volver a la página 1 para evitar inconsistencias en los resultados.
  FilterParams resetPage() => copyWith(page: 1);
}