import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';

class MarcaSearchBar extends ConsumerStatefulWidget{
  const MarcaSearchBar({super.key});

  @override
  ConsumerState<MarcaSearchBar> createState() => _MarcaSearchBarState();
}

class _MarcaSearchBarState extends ConsumerState<MarcaSearchBar>{
  late final TextEditingController _searchController;

  @override
  void initState(){
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query){
    setState((){}); //Actualiza la vista para mostrar/ocultar el botón de limpiar
    ref.read(marcaControllerProvider.notifier).buscarMarcas(query);
  }

  void _clearSearch(){
    _searchController.clear();
    _onSearchChanged("");
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:Colors.grey,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: "Buscar marca...",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty ? IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: Colors.grey.shade600,
            onPressed: _clearSearch,
          )
          : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          )
        )

      ),
    );
  }
}