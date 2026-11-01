/// Selector con búsqueda y carga por páginas, para catálogos que pueden crecer.
///
/// Reemplaza a los `DropdownButton`, que construyen todas las opciones de una
/// vez. Aquí solo se muestra una página de opciones a la vez, con botones
/// Anterior/Siguiente: al cambiar de página se descarta la anterior, así que
/// la memoria usada no crece aunque el catálogo tenga miles de registros.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Una opción elegible: identificador y texto que se muestra.
class PickerOption {
  final String id;
  final String label;

  const PickerOption({required this.id, required this.label});
}

/// Una página de opciones y el total de coincidencias (para saber cuántas páginas hay).
class PickerPage {
  final List<PickerOption> items;
  final int total;

  const PickerPage({required this.items, required this.total});
}

/// Devuelve una página de opciones que coinciden con [query].
typedef PickerFetch = Future<PickerPage> Function(String query, int offset, int limit);

/// Devuelve la opción que corresponde a [id], o `null` si ya no existe.
typedef PickerResolve = Future<PickerOption?> Function(String id);

const _pageSize = 8;

/// Campo de formulario que muestra la opción elegida y abre el selector al tocarlo.
class PagedPickerField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final PickerFetch fetch;
  final PickerResolve resolve;
  final IconData icon;

  /// Texto que se muestra cuando no hay selección.
  final String hint;

  /// Mensaje de validación; si es `null` el campo es opcional.
  final String? requiredMessage;

  /// Texto cuando el catálogo está vacío (por ejemplo, dónde crear opciones).
  final String emptyHelp;

  /// Permite quitar la selección (útil en filtros).
  final bool clearable;

  const PagedPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.fetch,
    required this.resolve,
    this.icon = Icons.list_alt_rounded,
    this.hint = 'Seleccionar',
    this.requiredMessage,
    this.emptyHelp = 'Aún no hay opciones registradas.',
    this.clearable = false,
  });

  @override
  State<PagedPickerField> createState() => _PagedPickerFieldState();
}

class _PagedPickerFieldState extends State<PagedPickerField> {
  String? _label;
  String? _labelFor;

  @override
  void initState() {
    super.initState();
    _resolveLabel();
  }

  @override
  void didUpdateWidget(covariant PagedPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _resolveLabel();
  }

  Future<void> _resolveLabel() async {
    final id = widget.value;
    if (id == null) {
      _label = null; // sin setState: build ya viene después de didUpdateWidget
      _labelFor = null;
      return;
    }
    if (_labelFor == id) return; // ya se conoce el nombre (se acaba de elegir)
    final option = await widget.resolve(id);
    if (!mounted || widget.value != id) return;
    setState(() {
      _label = option?.label;
      _labelFor = id;
    });
  }

  Future<void> _open(FormFieldState<String> field) async {
    final chosen = await showModalBottomSheet<PickerOption>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PickerSheet(
        title: widget.label,
        selectedId: widget.value,
        fetch: widget.fetch,
        emptyHelp: widget.emptyHelp,
      ),
    );
    if (chosen == null) return;
    setState(() {
      _label = chosen.label;
      _labelFor = chosen.id;
    });
    widget.onChanged(chosen.id);
    field.didChange(chosen.id);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: ValueKey(widget.value),
      initialValue: widget.value,
      validator: (_) => widget.requiredMessage != null && widget.value == null
          ? widget.requiredMessage
          : null,
      builder: (field) {
        final texto = widget.value == null ? null : (_label ?? 'Cargando...');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _open(field),
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: Icon(widget.icon, size: 20),
                  suffixIcon: widget.clearable && widget.value != null
                      ? IconButton(
                          tooltip: 'Quitar',
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => widget.onChanged(null),
                        )
                      : const Icon(Icons.keyboard_arrow_down_rounded),
                  errorText: field.errorText,
                ),
                child: Text(
                  texto ?? widget.hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: texto == null ? context.muted : context.ink,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PickerSheet extends StatefulWidget {
  final String title;
  final String? selectedId;
  final PickerFetch fetch;
  final String emptyHelp;

  const _PickerSheet({
    required this.title,
    required this.selectedId,
    required this.fetch,
    required this.emptyHelp,
  });

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  final _search = TextEditingController();
  List<PickerOption> _items = const [];
  Timer? _debounce;
  String _query = '';
  int _page = 1;
  int _total = 0;
  bool _loading = true;
  Object? _error;

  /// Descarta respuestas de búsquedas anteriores que llegan tarde.
  int _generation = 0;

  int get _pages => _total == 0 ? 1 : (_total / _pageSize).ceil();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.fetch(_query, (_page - 1) * _pageSize, _pageSize);
      if (!mounted || generation != _generation) return;
      setState(() {
        _items = page.items;
        _total = page.total;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _goTo(int page) {
    if (page < 1 || page > _pages || page == _page) return;
    _page = page;
    _load();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _query = value.trim();
      _page = 1;
      _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _search,
                    onChanged: _onQueryChanged,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _lista(context)),
            _pie(context),
          ],
        ),
      ),
    );
  }

  Widget _pie(BuildContext context) {
    if (_error != null || (_total == 0 && !_loading)) return const SizedBox(height: 8);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Página anterior',
              onPressed: _page > 1 && !_loading ? () => _goTo(_page - 1) : null,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Página $_page de $_pages',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(_total == 1 ? '1 resultado' : '$_total resultados',
                    style: TextStyle(fontSize: 12, color: context.muted)),
              ],
            ),
            IconButton(
              tooltip: 'Página siguiente',
              onPressed: _page < _pages && !_loading ? () => _goTo(_page + 1) : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lista(BuildContext context) {
    if (_error != null) {
      return Center(child: Text('No se pudo cargar: $_error'));
    }
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _query.isEmpty ? widget.emptyHelp : 'Nada coincide con "$_query".',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.muted),
          ),
        ),
      );
    }
    return Opacity(
      opacity: _loading ? .5 : 1,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final option = _items[index];
          final selected = option.id == widget.selectedId;
          return ListTile(
            title: Text(option.label,
                style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
            trailing: selected ? Icon(Icons.check_rounded, color: context.brand) : null,
            onTap: () => Navigator.pop(context, option),
          );
        },
      ),
    );
  }
}
