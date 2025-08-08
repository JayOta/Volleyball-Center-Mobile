import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override 
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // centraliza horizontalmente
          children: [
            SizedBox(height: 80),
            Center( 
              child: Container(width: 150, height: 150,child: Image.asset("assets/images/perfil.png", fit: BoxFit.fill,  color: const Color(0xFF14276b),),
              ),
            ),
               SizedBox(height: 20), 
            Center(
              child: Text('Nome', style: TextStyle(fontSize: 22, color: Colors.black87,
                ),
              ),
            ),
      
      
          ],
        ),
      ),
    );
  }
}
