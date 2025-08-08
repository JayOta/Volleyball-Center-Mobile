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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '🔥 BostaApp 🔥',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26, // Tamanho do texto
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              print('Menu apertado, porra!');
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(230);
}
