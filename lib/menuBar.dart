import 'package:flutter/material.dart';

class MenuBarFile extends StatefulWidget {
  final Function(int) onItemSelected;
  const MenuBarFile({super.key, required this.onItemSelected});

  @override
  State<MenuBarFile> createState() => _MenuBarFileState();
}

class _MenuBarFileState extends State<MenuBarFile> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // Remove o splash
        highlightColor: Colors.transparent, // Remove o highlight
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onItemSelected(index); // Função para trocar de página
        },
        type: BottomNavigationBarType
            .fixed, // Mantém os ícones visíveis mesmo com 5 itens
        backgroundColor: const Color(0xFF14276b),
        selectedItemColor: const Color(0xFFFCCE00),
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/vector.png", width: 30, height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/notices.png", width: 30, height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/home.png", width: 45, height: 45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/loja.png", width: 30, height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/p.png", width: 30, height: 30),
            label: '',
          ),
        ],
      ),
    );
  }
}
