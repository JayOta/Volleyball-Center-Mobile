import 'package:flutter/material.dart';
//import 'package:flutter/menuBar.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override 
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            SizedBox(height: 18), 
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
     SizedBox(height: 50), 
  Container(

  
    padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 200),
      decoration: BoxDecoration(
    color: const Color.fromARGB(255, 185, 185, 185),
    borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
    'Editar',
    style: TextStyle( 
      fontSize: 25,
      color: Colors.black,
    ),
  
      ),
  )
          ],
),
     
           
        ), 
      );
  }
}
