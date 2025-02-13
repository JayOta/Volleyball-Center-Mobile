import 'package:flutter/material.dart';
import 'package:navbar/fundamentos.dart';
import 'package:navbar/login.dart';
import 'package:navbar/loja.dart';
import 'package:navbar/navbar.dart';
import 'package:navbar/noticias.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppWidget(title: ''), // Ajuste aqui
    );
  }
}

class AppWidget extends StatefulWidget {
  final String title;

  const AppWidget({super.key, required this.title});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int _selectedIndex = 2;

  // Lista de páginas correspondentes a cada índice do NavigationBar
  final List<Widget> _pages = [
    Fundamentos(),
    Noticias(), // Página de fundamentos
    HomePage(), // Página inicial
    Loja(), // Página da loja
    Login(), // Página de notícias
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
        destinations: [
          NavigationDestination(
            icon: Image.asset("images/vector.png", width: 30, height: 30),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: "Fundamentos",
          ),
          NavigationDestination(
            icon: Image.asset("images/notices.png", width: 30, height: 30),
            selectedIcon: Icon(Icons.info, color: Colors.white),
            label: "Notícias",
          ),
          NavigationDestination(
            icon: Image.asset("images/home.png", width: 30, height: 30),
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
            selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
            label: "Login",
          ),
        ],
      ),
    );
  }

  Text textCreator(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 13.5, color: Colors.blue.shade300),
    );
  }

  TextButton buttonCreator(String text, BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.transparent,
        ),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        side:
            WidgetStatePropertyAll(BorderSide(color: Colors.white, width: 1.8)),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

// Exemplo de páginas (substitua pelas suas próprias páginas)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar();
  }
}
