import 'package:flutter/material.dart';
import 'package:navbar/fundamentos.dart';
import 'package:navbar/login.dart';
import 'package:navbar/loja.dart';
import 'package:navbar/main.dart';
import 'package:navbar/noticias.dart';

class MenuBarFile extends StatefulWidget {
  const MenuBarFile({super.key});

  @override
  State<MenuBarFile> createState() => _MenuBarFileState();
}

class _MenuBarFileState extends State<MenuBarFile> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Fundamentos(), // Página inicial
    Noticias(), // Página de fundamentos
    MyApp(), // Página de notícias
    Loja(), // Página da loja
    Login() // Página de login
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Exibe a página correspondente ao índice
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Color(0xFF14276b), // Cor de fundo do NavigationBar
        indicatorColor: Color(0xFFFCCE00), // Cor de fundo do ícone selecionado
        labelBehavior: NavigationDestinationLabelBehavior
            .alwaysShow, // Mostra os labels sempre
        destinations: [
          NavigationDestination(
            icon: Image.asset("images/fundamentos.png", width: 30, height: 30),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: "Fundamentos",
          ),
          NavigationDestination(
            icon: Image.asset("images/notices.png", width: 30, height: 30),
            selectedIcon: Icon(Icons.info, color: Colors.white),
            label: "Notícias",
          ),
          NavigationDestination(
            icon: Image.asset("images/home.png", width: 35, height: 35),
            selectedIcon: Icon(Icons.notifications, color: Colors.white),
            label: "Início",
          ),
          NavigationDestination(
            icon: Image.asset("images/loja.png", width: 30, height: 30),
            selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
            label: "Loja",
          ),
          NavigationDestination(
            icon: Image.asset("images/perfil.png", width: 30, height: 30),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  Text textCreator(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
