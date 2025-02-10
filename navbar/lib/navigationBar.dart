import 'package:flutter/material.dart';
import 'package:navbar/fundamentos.dart';
import 'package:navbar/loja.dart';
import 'package:navbar/main.dart';
import 'package:navbar/noticias.dart';

class NavigationBarFile extends StatefulWidget {
  const NavigationBarFile({super.key});

  @override
  State<NavigationBarFile> createState() => _NavigationBarFileState();
}

class _NavigationBarFileState extends State<NavigationBarFile> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 🚀 Substituído NavigationBar por NavigationRail para exibição vertical
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Color.fromARGB(255, 248, 202, 1),
            indicatorColor: Colors.white30,
            labelType: NavigationRailLabelType.all, // Exibe os rótulos sempre
            destinations: [
              NavigationRailDestination(
                icon: Image.asset("images/home.png", width: 30, height: 30),
                selectedIcon: Icon(Icons.home, color: Colors.white),
                label: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: textCreator(
                    "Início",
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Image.asset("images/info.png", width: 30, height: 30),
                selectedIcon: Icon(Icons.info, color: Colors.white),
                label: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Fundamentos()));
                  },
                  child: textCreator("Fundamentos"),
                ),
              ),
              NavigationRailDestination(
                icon: Image.asset("images/notification.png",
                    width: 30, height: 30),
                selectedIcon: Icon(Icons.notifications, color: Colors.white),
                label: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Noticias()));
                  },
                  child: textCreator("Notícias"),
                ),
              ),
              NavigationRailDestination(
                icon: Image.asset("images/cart.png", width: 30, height: 30),
                selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
                label: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Loja()));
                  },
                  child: textCreator("Loja"),
                ),
              ),
            ],
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
