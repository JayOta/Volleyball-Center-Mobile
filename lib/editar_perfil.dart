import 'package:flutter/material.dart';

class EditarPerfil extends StatelessWidget {
  const EditarPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: const Center(
        child: Text("Aqui vai o conteúdo da tela Editar Perfil"),
      ),
    );
  }
}
