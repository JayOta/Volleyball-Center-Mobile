import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/noticias.dart';
import 'package:volleyball_center_mobile/editar_perfil.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override 
  State<EditarPerfil> createState() => _PerfilState();
}

class _PerfilState extends State<EditarPerfil> {
  int _selectedIndex = 4; // Página inicial padrão

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return Fundamentos();
      case 1:
        return Noticias();
      case 2:
        return HomePage();
      case 3:
        return Loja();
      case 4:
        return bodyContent(context);
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuBarFile(onItemSelected: _onItemSelected),
      body: _buildBody(),
    );
  }
}

Widget bodyContent(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Center( 
          child: SizedBox(
            width: 150, height: 150,
            child: Image.asset(
              "assets/images/perfil.png",
              fit: BoxFit.fill,
              color: const Color(0xFF14276b),
            ),
            
          ),
        ),
        const SizedBox(height: 20), 
        const Text(
          'Nome',
          style: TextStyle(fontSize: 22, color: Colors.black87),
        ),
        const SizedBox(height: 30), 
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFF14276B).withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            'nome@gmail.com',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        const SizedBox(height: 40), 
        // Container dos botões
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20), 
        child:Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF14276b),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditarPerfil(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.black),
                label: const Text("Nome", style: TextStyle(color: Colors.black, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 180, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.black),
                label: const Text("nome@gmail.com", style: TextStyle(color: Colors.black, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save, color: Colors.black),
                label: const Text("Salvar", style: TextStyle(color: Colors.black, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 180, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
            ],
          ),
        ),
        ),
      ]
    ),
  );

}
