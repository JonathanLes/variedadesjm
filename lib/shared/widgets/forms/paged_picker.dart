/// Selector con búsqueda y carga por páginas, para catálogos que pueden crecer.
///
/// Reemplaza a los `DropdownButton`, que construyen todas las opciones de una
/// vez. Aquí solo se piden [pageSize] opciones a la vez y se cargan más al
/// llegar al final de la lista.
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

/// Devuelve una página de opciones que coinciden con [query].
typedef PickerFetch = Future<List<PickerOption>> Function(String query, int offset, int limit);

/// Devuelve la opción que corresponde a [id], o `null` si ya no existe.
typedef PickerResolve = Future<PickerOption?> Function(String id);

const _pageSize = 20;

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
  final _scroll = ScrollController();
  final _items = <PickerOption>[];
  Timer? _debounce;
  String _query = '';
  bool _loading = false;
  bool _hasMore = true;
  Object? _error;

  /// Descarta respuestas de búsquedas anteriores que llegan tarde.
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 200) _loadMore();
    });
    _loadMore();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    final generation = _generation;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.fetch(_query, _items.length, _pageSize);
      if (!mounted || generation != _generation) return;
      setState(() {
        _items.addAll(page);
        _hasMore = page.length == _pageSize;
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

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _generation++;
      setState(() {
        _query = value.trim();
        _items.clear();
        _hasMore = true;
        _loading = false;
      });
      _loadMore();
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
          ],
        ),
      ),
    );
  }

  Widget _lista(BuildContext context) {
    if (_error != null && _items.isEmpty) {
      return Center(child: Text('No se pudo cargar: $_error'));
    }
    if (_items.isEmpty && _loading) {
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
    return ListView.builder(
      controller: _scroll,
      itemCount: _items.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          );
        }
        final option = _items[index];
        final selected = option.id == widget.selectedId;
        return ListTile(
          title: Text(option.label,
              style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
          trailing: selected ? Icon(Icons.check_rounded, color: context.brand) : null,
          onTap: () => Navigator.pop(context, option),
        );
      },
    );
  }
}
