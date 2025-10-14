import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbaradmin.dart';
// ATUALIZADO: Importando das novas localizações
import 'package:volleyball_center_mobile/pages/admin/admin_news_view.dart';
import 'package:volleyball_center_mobile/pages/admin/admin_users_view.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _selectedIndex = 0; // 0 para Notícias, 1 para Usuários

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody(int index) {
    // Retorna a view correta com base no índice selecionado
    switch (index) {
      case 0:
        return const AdminNewsView(); // Tela de Notícias (CRUD)
      case 1:
        return const AdminUsersView(); // Tela de Usuários (Listagem)
      default:
        return const Center(child: Text('Erro: Página não encontrada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbaradmin(),
      body: _buildBody(_selectedIndex),
      // Navegação inferior para as duas seções de administração
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemSelected,
        selectedItemColor: const Color(0xFF14276b),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Notícias'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuários'),
        ],
      ),
    );
  }
}
