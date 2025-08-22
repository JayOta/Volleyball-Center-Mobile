import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/noticias.dart';
import 'package:volleyball_center_mobile/editar_perfil.dart';
class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override 
  State<Perfil> createState() => _PerfilState();
  
}

class _PerfilState extends State<Perfil> {

    int _selectedIndex = 4; // Página inicial padrão

  void _onItemSelected(int index) {
    if (index == 4) {
      // índice 4 é o botão perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
        return bodyContent();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuBarFile(onItemSelected: _onItemSelected),
      body: _buildBody());
      }
  }
Widget bodyContent(){
  return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // centraliza horizontalmente
          children: [
            SizedBox(height: 80),
            Center( 
              child: SizedBox(width: 150, height: 150,child: Image.asset("assets/images/perfil.png", fit: BoxFit.fill,  color: const Color(0xFF14276b),),
              ),
            ),
               SizedBox(height: 20), 
            Center(
              child: Text('Nome', style: TextStyle(fontSize: 22, color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 30), 
        Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
    color: const Color(0xFF14276B).withOpacity(0.6), // Cor de fundo com opacidade
    borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'nome@gmail.com',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black, 
          ),
        ),
  ),
     SizedBox(height: 40), 
  Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Color(0xFF14276b),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // Botão Editar
      ElevatedButton.icon(
        onPressed: () {
          
  },
        icon: const Icon(Icons.edit, color: Colors.black),
        label: const Text("Editar", style: TextStyle(color: Colors.black, fontSize: 20),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // cor de fundo preto
          padding: const EdgeInsets.symmetric(horizontal: 170, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
   SizedBox(height: 20,),
      // Botão Configurações
      ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.settings, color: Colors.black),
        label: const Text("Configurações", style: TextStyle(color: Colors.black, fontSize: 20)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      SizedBox(height: 20,),
      // Botão Carrinho
      ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart, color: Colors.black),
        label: const Text("Carrinho de compras", style: TextStyle(color: Colors.black, fontSize: 20)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  ),
),
SizedBox(height: 50,),
ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Colors.black),
        label: const Text("Logout", style: TextStyle(color: Colors.black, fontSize: 20)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 219, 58, 46),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
          ]
        ),
      );   
      
  }

  

