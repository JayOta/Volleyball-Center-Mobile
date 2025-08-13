import 'package:flutter/material.dart';

class Navbaradmin extends StatelessWidget implements PreferredSizeWidget {
  const Navbaradmin({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 170, 129, 129),
      ),
      child: Stack(
        alignment: Alignment.center, // garante centro absoluto
        children: [
          // image centralizado vertical e horizontal
          Image.asset(
            'assets/images/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  
  @override
  Size get preferredSize => const Size.fromHeight(230); // altura da navbar
}
