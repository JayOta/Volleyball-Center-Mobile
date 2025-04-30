import 'package:flutter/material.dart';

class MenuBarFile extends StatefulWidget {
  final Function(int) onItemSelected; // Função para trocar de página
  const MenuBarFile({super.key, required this.onItemSelected});

  @override
  State<MenuBarFile> createState() => _MenuBarFileState();
}

class _MenuBarFileState extends State<MenuBarFile> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onItemSelected(index); // Chama a função para trocar a página
      },
      height: 75,
      backgroundColor: const Color(0xFF14276b),
      indicatorColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(Colors.amber),
      destinations: [
        NavigationDestination(
          icon: Image.asset("images/vector.png", width: 30, height: 30),
          label: "",
        ),
        NavigationDestination(
          icon: Image.asset("images/notices.png", width: 30, height: 30),
          label: "",
        ),
        NavigationDestination(
          icon: Image.asset("images/home.png", width: 45, height: 45),
          label: "",
        ),
        NavigationDestination(
          icon: Image.asset("images/loja.png", width: 30, height: 30),
          label: "",
        ),
        NavigationDestination(
          icon: Image.asset("images/perfil.png", width: 30, height: 30),
          label: "",
        ),
      ],
    );
  }
}
