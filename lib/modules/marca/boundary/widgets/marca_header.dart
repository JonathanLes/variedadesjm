import "package:flutter/material.dart";

class MarcaHeader extends StatelessWidget{
  const MarcaHeader({super.key});

  @override
  Widget build(BuildContext context){
    return const Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Text(
          "Marcas",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
        SizedBox(height: 4),
        Text(
          "Administra tus marcas",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          )
        )
      ],
    );
  }
}